# docker build . -t 'latex'
# docker run -it --rm latexml:latest /bin/bash
# docker run -it --rm -v `pwd`:/scratch latexml:latest /bin/bash

# https://hub.docker.com/r/phusion/baseimage/tags
#FROM phusion/focal-1.2.0
FROM phusion/baseimage:0.11

RUN apt-get update && \
    apt install -y software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get install -y \
# edit source code
         python3.9 \
         python3-pip \
         python3-dev \
         latexml \
         libtext-unidecode-perl 

WORKDIR /opt/

# from https://github.com/wtsnjp/MioGatto
COPY MioGatto MioGatto 

RUN pip3 install -r /opt/MioGatto/requirements.txt

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get install -y nodejs

RUN cd /opt/MioGatto/client && npm install

RUN cd /opt/MioGatto/client && npx tsc

RUN echo "alias python=python3" > /root/.bashrc



