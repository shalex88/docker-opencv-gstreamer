# Define the Ubuntu versions as a build argument
ARG UBUNTU_VER=24.04

# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:${UBUNTU_VER}

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    gfortran \
    openexr \
    libatlas-base-dev \
    python3-dev \
    python3-numpy \
    python3-pip \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define the OpenCV versions as a build argument
ARG OPENCV_VER=4.11.0

# Clone the OpenCV and OpenCV contrib repositories
RUN git clone https://github.com/opencv/opencv.git -b ${OPENCV_VER} /opencv && \
    git clone https://github.com/opencv/opencv_contrib.git -b ${OPENCV_VER} /opencv_contrib

# Create a build directory and compile OpenCV with GStreamer and Python support
RUN cd /opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_EXAMPLES=OFF \
          -D BUILD_TESTS=OFF \
          -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
          -D WITH_GSTREAMER=ON \
          -D OPENCV_GENERATE_PKGCONFIG=ON \
          -D PYTHON_EXECUTABLE=$(which python3) \
          .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Clean up
RUN rm -rf /opencv /opencv_contrib

# Additional GStreamer packages that are not required by OpenCV but are useful for video processing
RUN apt-get update && apt-get install -y \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-rtsp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the startup directory
WORKDIR /root

# Set the prompt hostname
ENV HOSTNAME=opencv-${OPENCV_VER}-container

# Set the default command to run a bash shell
CMD ["bash"]
