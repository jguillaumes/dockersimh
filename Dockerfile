FROM debian:latest
MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>
ARG buildsims="vax vax780 pdp11"

RUN apt-get update && apt-get install -y \ 
	gcc \
	make \ 
	git \
	net-tools \
	libpcap-dev \
	nano

RUN mkdir /simh-bin

WORKDIR /workdir
RUN git clone git://github.com/simh/simh
RUN cd simh && \
	git pull \
	make ${buildsims} && \
	cp BIN/* /simh-bin

ENV PATH /simh-bin:$PATH

EXPOSE 23 50023
RUN mkdir /machines
VOLUME /machines

WORKDIR /machines
COPY /machines /machines
COPY startup.sh /startup.sh 

ENTRYPOINT ["/startup.sh"]
