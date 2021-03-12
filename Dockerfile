FROM jupyter/base-notebook:latest

USER root
RUN apt-get update && apt-get install -y pkg-config libssl-dev build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool fuse
RUN apt-get install curl

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse /s3fs

RUN cd /s3fs && ./autogen.sh && ./configure && make && make install
RUN rm -rf /s3fs

COPY /src/* /usr/local/bin/
#RUN install_oneclient.sh

USER $NB_UID

RUN conda install --quiet --yes untangle requests minio
