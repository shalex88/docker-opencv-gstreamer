# Define the Ubuntu versions as a build argument
ARG UBUNTU_VER=24.04

# Select the base image
ARG CUDA=ubuntu:
ARG BASE_IMAGE=${CUDA}${UBUNTU_VER}
FROM ${BASE_IMAGE}

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    gfortran \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-python3-plugin-loader \
    gstreamer1.0-qt5 \
    gstreamer1.0-rtsp \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev \
    libgtk-3-dev \
    libjpeg-dev \
    libpng-dev \
    libswscale-dev \
    libtiff-dev \
    libv4l-dev \
    libx264-dev \
    libxvidcore-dev \
    openexr \
    pkg-config \
    python3-dev \
    python3-gst-1.0 \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN python3 -m pip install --no-cache-dir numpy

# Define the OpenCV versions as a build argument
ARG OPENCV_VER=4.11.0

# Clone the OpenCV and OpenCV contrib repositories
RUN git clone --depth 1 --branch ${OPENCV_VER} https://github.com/opencv/opencv.git /opencv && \
    git clone --depth 1 --branch ${OPENCV_VER} https://github.com/opencv/opencv_contrib.git /opencv_contrib

# Configure and build OpenCV
RUN if [ "${CUDA}" != "ubuntu:" ]; then \
    CUDA_FLAGS="-D WITH_CUDA=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON -D WITH_CUBLAS=ON -D OPENCV_DNN_CUDA=ON"; \
else \
    CUDA_FLAGS=""; \
fi && \
cmake -S /opencv -B /opencv/build \
    ${CUDA_FLAGS} \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
    -D WITH_GSTREAMER=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D PYTHON_EXECUTABLE=$(which python3) && \
cmake --build /opencv/build --parallel $(nproc) && \
cmake --install /opencv/build && \
ldconfig

# Clean up
RUN rm -rf /opencv /opencv_contrib

# Set the shell prompt to use the HOSTNAME environment variable
ENV HOSTNAME=opencv-${OPENCV_VER}-container
RUN echo "export PS1='\[\033[01;32m\]\u@\${HOSTNAME}:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc

# Set the startup directory
WORKDIR /root

# Set the default command to run a bash shell
CMD ["bash"]