FROM ubuntu:latest
MAINTAINER Zekeriya Akgül


RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apache2 iputils-ping iproute2 net-tools wget ethtool

EXPOSE 80 443
