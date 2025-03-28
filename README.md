# OpenCV with Gstreamer docker

Docker image with different OpenCV (with Gstreamer) and Ubuntu versions combination

### Docker Hub

* OpenCV 4.8.1 with Python 3.10.12, Gstreamer 1.20.3 support on Ubuntu 22.04 (amd64, arm64)

    [shalex88/opencv-4.8](https://hub.docker.com/r/shalex88/opencv-4.8)

* OpenCV 4.11.0 with Python 3.12.3, Gstreamer 1.24.2 support on Ubuntu 24.04 (amd64, arm64)

    [shalex88/opencv-4.11](https://hub.docker.com/r/shalex88/opencv-4.11)

## Build

```bash
# Build default versions (Ubuntu 24.04, OpenCV 4.11.0)
docker buildx build -t opencv-4.11 .

# Build with specific Ubuntu version and OpenCV version
docker buildx build -t opencv-4.8 . --build-arg UBUNTU_VER=22.04 --build-arg OPENCV_VER=4.8.1

# Build ARM64 and AMD64 versions
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t shalex88/opencv-4.8:latest . --build-arg UBUNTU_VER=22.04 --build-arg OPENCV_VER=4.8.1 --load
```

## Pull

```bash
docker pull shalex88/opencv-4.8
```

## Run

```bash
docker run -it --rm shalex88/opencv-4.11:latest
# Run with GUI support
docker run -it --rm -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix shalex88/opencv-4.11:latest

```