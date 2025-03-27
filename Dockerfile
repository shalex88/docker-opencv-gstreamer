# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

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

# Clone the OpenCV and OpenCV contrib repositories
RUN git clone https://github.com/opencv/opencv.git -b 4.x /opencv && \
    git clone https://github.com/opencv/opencv_contrib.git -b 4.x /opencv_contrib

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

# Set the default command to run a bash shell
CMD ["bash"]
