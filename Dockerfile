FROM container-registry.k8s.kdm.wcss.pl/jhub-notebook-s3:v0.2
#FROM jupyter/base-notebook:latest

USER root
RUN apt-get install -y sl
#RUN apt-get install curl

#RUN git clone https://github.com/s3fs-fuse/s3fs-fuse /s3fs

#RUN cd /s3fs && ./autogen.sh && ./configure && make && make install
#RUN rm -rf /s3fs

#COPY /src/* /usr/local/bin/
#RUN install_oneclient.sh

USER $NB_UID

#RUN conda install --quiet --yes untangle requests minio
