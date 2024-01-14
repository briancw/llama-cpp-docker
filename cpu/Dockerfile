FROM ubuntu:22.04

# Baseline Update and tools
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl git build-essential cmake

# Get Llama.cpp
ADD https://api.github.com/repos/ggerganov/llama.cpp/git/refs/heads/master version.json
RUN git clone https://github.com/ggerganov/llama.cpp.git /app
WORKDIR /app

# Make with Cmake
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN cmake --build . --config Release
