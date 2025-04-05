# OpenCV with Gstreamer docker

Docker image with different OpenCV (with Gstreamer) and Ubuntu versions combination

### Docker Hub

* OpenCV 4.8.1 with Python 3.10.12, Gstreamer 1.20.3 support on Ubuntu 22.04 (amd64, arm64)

    [shalex88/opencv-4.8](https://hub.docker.com/r/shalex88/opencv-4.8)

* OpenCV 4.8.1 with Cuda 11.8.0, cuDNN 8.9.6, Python 3.10.12, Gstreamer 1.20.3 support on Ubuntu 22.04 (amd64, arm64)

    [shalex88/opencv-cuda-4.8](https://hub.docker.com/r/shalex88/opencv-cuda-4.8)

* OpenCV 4.11.0 with Python 3.12.3, Gstreamer 1.24.2 support on Ubuntu 24.04 (amd64, arm64)

    [shalex88/opencv-4.11](https://hub.docker.com/r/shalex88/opencv-4.11)

* OpenCV 4.11.0 with Cuda 12.8.1, cuDNN 9.8.0, Python 3.12.3, Gstreamer 1.24.2 support on Ubuntu 24.04 (amd64, arm64)

    [shalex88/opencv-cuda-4.11](https://hub.docker.com/r/shalex88/opencv-cuda-4.11)

## Manual Build

```bash
# Build default versions (Ubuntu 24.04, OpenCV 4.11.0, No CUDA)
docker buildx build -t opencv-4.11 .

# Build with specific Ubuntu version and OpenCV version
docker buildx build -t opencv-4.8 . --build-arg UBUNTU_VER=22.04 --build-arg OPENCV_VER=4.8.1

# Build with specific CUDA version (Nvidia Docker with Ubuntu version)
docker buildx build -t opencv-cuda-4.11 . --build-arg CUDA=nvidia/cuda:12.8.1-cudnn-devel-ubuntu

# Build ARM64 and AMD64 versions
docker buildx build --platform linux/amd64,linux/arm64 -t opencv-4.11 . --load
```

## Pull

```bash
docker pull shalex88/opencv-4.8
```

## Run

```bash
# Simple container
docker run -it --rm shalex88/opencv-4.11
# With GUI support
docker run -it --rm -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix shalex88/opencv-4.11
# With GPU support (check if nvidia runtime is available 'docker info | grep Runtimes')
docker run -it --rm --runtime=nvidia --gpus all shalex88/opencv-cuda-4.11
```