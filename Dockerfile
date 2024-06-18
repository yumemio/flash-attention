# Use the Python 3.12 image with Bookworm
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel

# Set the working directory inside the container
WORKDIR /work

# Install APT packages
RUN apt-get update \
  && apt-get install --yes libaio-dev git python3-packaging

# Install Python packages
RUN pip install packaging
COPY requirements.txt .
COPY frozen-colab.txt .
RUN DS_BUILD_UTILS=1 DS_BUILD_FUSED_LAMB=1 \
    pip install --no-cache-dir -r requirements.txt --constraint frozen-colab.txt
RUN python -m spacy download en_core_web_sm

# Install helper apps
RUN apt install --yes vim less tmux htop

# Install Jupyter
RUN pip install jupyterlab

# Set the default command to run Jupyter Notebook
CMD [ "jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token='JulianJovyan'", "--notebook-dir=/work" ]
