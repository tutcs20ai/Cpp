FROM ubuntu:20.04

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install tzdata
ENV TZ=Asia/Tokyo

RUN apt-get install --no-install-recommends -y build-essential cmake \
ca-certificates unzip wget \
pkg-config \
libgtk2.0-dev \
libjpeg-dev libpng-dev \
ffmpeg libavcodec-dev libavformat-dev libavresample-dev libswscale-dev \
libv4l-dev \
libtbb-dev
RUN apt-get clean

ARG var="4.1.2"
WORKDIR /tmp/opencv
RUN wget https://github.com/opencv/opencv/archive/${var}.zip && unzip ${var}.zip -d .
WORKDIR /tmp/opencv/opencv-${var}/build/
RUN cmake -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D WITH_FFMPEG=ON -D WITH_TBB=ON .. | tee /tmp/opencv_cmake.log
RUN make -j "$(nproc)" | tee /tmp/opencv_build.log && make install | tee /tmp/opencv_install.log
RUN cd && rm -rf /tmp/opencv