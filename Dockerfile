FROM centos:7
MAINTAINER COLUNDRUM

# setup
RUN yum clean all
RUN rm -rf /var/cache/yum/*
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y centos-release-scl
RUN yum upgrade -y
RUN yum install -y devtoolset-7 rpm-build redhat-lsb-core

# nginx dependencies
RUN yum -y install git openssl-devel pcre-devel zlib-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel pam-devel ImageMagick-devel zeromq-devel jq

# rpmbuild command recommends to use `builder:builder` as user:group.
RUN useradd -u 1000 builder

ADD script/build-nginx.sh /home/builder/
RUN chmod a+x /home/builder/build-nginx.sh

ADD nginx.spec.centos7.patch /home/builder/

WORKDIR /home/builder
