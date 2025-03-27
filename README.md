# OpenCV with Gstreamer docker

Docker image with different OpenCV (with Gstreamer) and Ubuntu versions combination

## Build

```bash
# Build default versions (Ubuntu 24.04, OpenCV 4.11.0)
docker buildx build -t opencv-4.11 .

# Build with specific Ubuntu version and OpenCV version
docker buildx build -t opencv-4.8 . --build-arg UBUNTU_VER=22.04 --build-arg OPENCV_VER=4.8.1
```

## Run

```bash
docker run -it --rm opencv-4.x
```