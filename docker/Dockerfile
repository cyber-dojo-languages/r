FROM  cyberdojofoundation/ubuntu-build-essential:18.04
LABEL maintainer=jon@jaggersoft.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install --yes r-base

RUN Rscript --version 2>&1 | grep -q 3.4.3
