# OpenCV with Gstreamer docker

Docker image with different OpenCV (with Gstreamer) and Ubuntu versions combination

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

# Pull

```bash
docker pull shalex88/opencv-4.8
```

## Run

```bash
docker run -it --rm opencv-4.11
```