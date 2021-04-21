# Build an image that can do training and inference in SageMaker
# This is a Python 2 image that uses the nginx, gunicorn, flask stack
# for serving inferences in a stable way.

FROM ubuntu:16.04

MAINTAINER Amazon AI <sage-learner@amazon.com>


RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         python3.5 \
         nginx \
         libgcc-5-dev \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Here we get all python packages.
# There's substantial overlap between scipy and numpy that we eliminate by
# linking them together. Likewise, pip leaves the install caches populated which uses
# a significant amount of space. These optimizations save a fair amount of space in the
# image, which reduces start up time.
RUN wget https://bootstrap.pypa.io/3.3/get-pip.py && \
        python3.5 get-pip.py && \
        pip install --upgrade pip && \
        pip3 install numpy==1.18.5 scipy==1.4.1 scikit-learn==0.22.2.post1 xgboost==1.1.1 pandas flask==1.1.2 gevent==1.4 gunicorn==20.0.4 && \
        (cd /usr/local/lib/python3.5/dist-packages/scipy/.libs; rm *) && \
        rm -rf /root/.cache

# ; ln ../../numpy/.libs/* . (removed from after the rm* command)

# Set some environment variables. PYTHONUNBUFFERED keeps Python from buffering our standard
# output stream, which means that logs can be delivered to the user quickly. PYTHONDONTWRITEBYTECODE
# keeps Python from writing the .pyc files which are unnecessary in this case. We also update
# PATH so that the train and serve programs are found when the container is invoked.

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Set up the program in the image
COPY xgboost /opt/program
WORKDIR /opt/program

