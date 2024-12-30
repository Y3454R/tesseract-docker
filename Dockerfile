# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt update && apt install -y \
    git autoconf automake libtool pkg-config \
    libpng-dev libjpeg8-dev libtiff5-dev zlib1g-dev \
    libwebp-dev libopenjp2-7-dev libgif-dev \
    libarchive-dev libcurl4-openssl-dev libicu-dev \
    libpango1.0-dev libcairo2-dev libleptonica-dev \
    wget python3-pip vim && \
    apt clean

# Clone and build Tesseract
RUN git clone https://github.com/tesseract-ocr/tesseract.git && \
    cd tesseract && \
    ./autogen.sh && \
    ./configure && \
    make && make install && ldconfig && \
    make training && make training-install

# Clone tesstrain
RUN git clone https://github.com/tesseract-ocr/tesstrain.git /tesseract/tesstrain

# Set the working directory
WORKDIR /tesseract/tesstrain

# Install Python requirements
RUN pip3 install -r requirements.txt

# Set entry point (optional)
CMD ["bash"]

