ARG CUDA_IMAGE="12.1.1-devel-ubuntu22.04"
FROM nvidia/cuda:${CUDA_IMAGE}

# Hide some banner stuff
RUN rm /opt/nvidia/entrypoint.d/15-container-copyright.txt
RUN rm /opt/nvidia/entrypoint.d/30-container-license.txt
RUN rm /opt/nvidia/entrypoint.d/10-banner.sh
RUN rm /opt/nvidia/entrypoint.d/12-banner.sh

# Baseline Update and tools
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl git build-essential cmake

# Get Llama.cpp
ADD https://api.github.com/repos/ggerganov/llama.cpp/git/refs/heads/master version.json
RUN git clone https://github.com/ggerganov/llama.cpp.git /app
WORKDIR /app

# I'm not sure if this works for Cmake
ENV CUDA_DOCKER_ARCH=all

# Make with Cmake
RUN mkdir build
WORKDIR build
RUN cmake .. -DLLAMA_CUBLAS=ON
RUN cmake --build . --config Release
