ARG UBUNTU_VERSION=22.04

# This needs to generally match the container host's environment.
ARG ROCM_VERSION=5.6

# Target the CUDA build image
ARG BASE_ROCM_DEV_CONTAINER=rocm/dev-ubuntu-${UBUNTU_VERSION}:${ROCM_VERSION}-complete

FROM ${BASE_ROCM_DEV_CONTAINER} as build

# Unless otherwise specified, we make a fat build.
# List from https://github.com/ggerganov/llama.cpp/pull/1087#issuecomment-1682807878
# This is mostly tied to rocBLAS supported archs.
ARG ROCM_DOCKER_ARCH=\
    gfx803 \
    gfx900 \
    gfx906 \
    gfx908 \
    gfx90a \
    gfx1010 \
    gfx1030 \
    gfx1100 \
    gfx1101 \
    gfx1102

RUN apt-get update
RUN apt-get install -y \
    git \
    cmake

# Install setuptools and wheel
RUN pip install --upgrade pip setuptools wheel --no-cache-dir

# Get Llama.cpp
ADD https://api.github.com/repos/ggerganov/llama.cpp/git/refs/heads/master version.json
RUN git clone https://github.com/ggerganov/llama.cpp.git /app
WORKDIR /app
RUN pip install -r requirements.txt

# Set nvcc architecture
ENV GPU_TARGETS=${ROCM_DOCKER_ARCH}

# Enable ROCm
# ENV LLAMA_HIPBLAS=1
ENV CC=/opt/rocm/llvm/bin/clang
ENV CXX=/opt/rocm/llvm/bin/clang++

RUN mkdir build
WORKDIR build
RUN cmake .. -DLLAMA_HIPBLAS=ON
RUN cmake --build . --config Release

#ENTRYPOINT ["/app/.devops/tools.sh"]
