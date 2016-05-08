FROM jguillaumes/simh-base
MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>
ARG buildsims="vax vax780 pdp11"

WORKDIR /workdir

RUN cd simh && \
    git pull && \
    make ${buildsims} && \
    cp BIN/* /simh-bin


ENV PATH /simh-bin:$PATH

EXPOSE 2323
RUN mkdir /machines
VOLUME /machines

WORKDIR /
RUN rm -rf /workdir
COPY startup.sh /startup.sh

WORKDIR /machines
COPY /machines /machines

#ENTRYPOINT ["/startup.sh"]
