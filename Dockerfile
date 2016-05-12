FROM jguillaumes/simh-allsims
MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>
ARG sims="vax vax780 pdp11"

WORKDIR /workdir

RUN cp /simh-bin/* /workdir && \
	rm /simh-bin/* && \
	for f in $sims; do cp $f /simh-bin; done && \
	rm -rf /workdir 

ENV PATH /simh-bin:$PATH

VOLUME /machines

EXPOSE 2323
EXPOSE 2324
EXPOSE 2325
EXPOSE 2326

WORKDIR /
COPY startup.sh /startup.sh

WORKDIR /machines
COPY /machines /machines

#ENTRYPOINT ["/startup.sh"]
