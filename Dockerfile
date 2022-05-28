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
# MioGatto's instructions require 3.9, which isn't the default for Ubuntu 20.04 LTS (comes with python 3.6)
         python3.9 \
         python3.9-distutils \
# because python 3.9 isn't part of the OS, the blas library needs to be compiled from source. This depends on gcc, which is in
         build-essential \
# need python.h for compiling source code
         python3.9-dev \
# matplotlib wants
         pkg-config \
# and matplotlib wants
         libfreetype6-dev \
# 0.8.2 is "too old" according to https://github.com/wtsnjp/MioGatto/issues/45
         # latexml \ 
         libtext-unidecode-perl \
# for latexml
         libparse-recdescent-perl \
         libfile-which-perl \
         libxml-perl \
         libxml-libxslt-perl \
         libxml2 \
         libio-string-perl \
# to verify that .tex files actually compile
         texlive 
# inadequate set of .sty? 
# see https://tex.stackexchange.com/questions/245982/differences-between-texlive-packages-in-linux


WORKDIR /opt/

# from https://github.com/wtsnjp/MioGatto
COPY MioGatto MioGatto 

COPY LaTeXML LaTeXML

#Latexml REQUIREMENTS
#        A sufficiently Unicode supporting Perl: 5.8, maybe 5.6
#        XML::LibXML and XML::LibXSLT  (See www.CPAN.org)
#        (which require libxml2 and libxslt: See http://www.xmlsoft.org/)
#        Parse::RecDescent
#        Image::Magick

# deadsnakes doesn't include pip 3.9, so manual installation is necessary
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.9 get-pip.py

RUN python3.9 -m pip install -r /opt/MioGatto/requirements.txt

# MioGatto requires npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get install -y nodejs

RUN cd /opt/MioGatto/client && npm install

RUN cd /opt/MioGatto/client && npx tsc

#*************8

WORKDIR /opt/LaTeXML

RUN apt-get install -y libarchive-zip-perl \
      libjson-xs-perl \
# while texlive-full eliminates any tex dependency problems, 1) it's huge on disk and 2) it takes time to install
      texlive-full

RUN apt-get install -y latexml

# fails on "from . import ft2font" which indicates a dependence on Visual Studio C++
# https://github.com/matplotlib/matplotlib/issues/14558#issuecomment-502769057
#RUN python3.9 -m pip install msvc-runtime
# https://pypi.org/project/msvc-runtime/

RUN perl Makefile.PL
RUN make
RUN make test
RUN make install

RUN echo "alias python=python3.9" > /root/.bashrc


