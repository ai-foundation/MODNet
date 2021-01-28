#
# Usage:
#
# docker build . -t modnet
# docker run -v /home/ubuntu/gandemic/data:/data modnet python -m demo.video_matting.custom.run --video /data/coco-512.mp4 --fps 25 --result-type matte
#

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        mesa-utils \
        unzip \
        wget

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b && \
    rm /tmp/Miniconda3-latest-Linux-x86_64.sh


RUN mkdir -p /opt/modnet

WORKDIR /opt/modnet

ENV PATH /root/miniconda3/bin:$PATH

COPY ./demo ./demo
COPY ./pretrained ./pretrained
COPY ./src ./src

RUN conda create -n modnet python=3.6 && \
  /root/miniconda3/envs/modnet/bin/pip install \
    numpy==1.19.5 \
    Pillow==8.1.0 \
    opencv-python==4.5.1.48 \
    torch==1.7.1 \
    torchvision==0.8.2 \
    tqdm==4.56.0 \
    dataclasses==0.8 \
    typing-extensions==3.7.4.3

ENV PATH /root/miniconda3/envs/modnet/bin:$PATH
