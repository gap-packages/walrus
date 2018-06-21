FROM gapsystem/gap-docker-master:20180605

MAINTAINER Markus Pfeiffer <markus.pfeiffer@morphism.de>

RUN    cd /home/gap/inst/gap-master \
    && cd pkg \
    && git clone https://github.com/gap-packages/datastructures \
    && cd datastructures \
    && sh autogen.sh \
    && ./configure \
    && make \
    && cd .. \
    && git clone https://github.com/gap-packages/anatph \
    && cd ../..

COPY . /home/gap
