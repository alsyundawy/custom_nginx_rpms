#!/bin/sh
set -xe

CENTOS_MAJOR_VERSION=$(rpm -q --qf '%{VERSION}' $(rpm -q --whatprovides redhat-release))
PATCH_PATH=$HOME/nginx.spec.centos${CENTOS_MAJOR_VERSION}.patch

NGINX_VERSION=$(grep '^+Version:' $PATCH_PATH | cut -d ' ' -f 2)

HEADERS_MORE_VERSION=v0.33
HTTP_ACCOUNTING_MODULE_VERSION=v0.5
HTTP_AUTH_PAM_VERSION=v1.5.1
HTTP_CACHE_PURGE_VERSION=2.3
HTTP_FANCYINDEX_VERSION=v0.4.2
HTTP_INTERNAL_REDIRECT_VERSION=v0.6
HTTP_UPLOADPROGRESS_VERSION=v0.9.2
NAXSI_VERSION=0.55.3
NCHAN_VERSION=v1.1.14
NGINX_OPENSSL_VERSION=v0.04
NGINX_PUSH_STREAM_VERSION=0.5.4
NGINX_VOD_VERSION=1.22

cat <<EOS > /shared/modules_version.md

Modules version (branch or tag) :

- brotli                 : MASTER
- cache_purge            : ${HTTP_CACHE_PURGE_VERSION}
- circle_gif             : MASTER
- fancyindex             : ${HTTP_FANCYINDEX_VERSION}
- headers-more           : ${HEADERS_MORE_VERSION}
- http_accounting_module : ${HTTP_ACCOUNTING_MODULE_VERSION}
- http_auth_pam          : ${HTTP_AUTH_PAM_VERSION}
- http_internal_redirect : ${HTTP_INTERNAL_REDIRECT_VERSION}
- http-rdns              : MASTER
- log_if                 : MASTER
- log-zmq                : MASTER
- naxsi                  : ${NAXSI_VERSION}
- nchan                  : ${NCHAN_VERSION}
- openssl-version        : ${NGINX_OPENSSL_VERSION}
- push-stream-module     : ${NGINX_PUSH_STREAM_VERSION}
- upload-progress        : ${HTTP_UPLOADPROGRESS_VERSION}
- vod                    : ${NGINX_VOD_VERSION}

EOS

NGINX_SRPM_FILE=nginx-${NGINX_VERSION}-1.el${CENTOS_MAJOR_VERSION}_4.ngx.src.rpm
curl -LO http://nginx.org/packages/centos/${CENTOS_MAJOR_VERSION}/SRPMS/${NGINX_SRPM_FILE}
rpm -Uvh $NGINX_SRPM_FILE

cd $HOME/rpmbuild/SOURCES
git clone --single-branch --recurse-submodules https://github.com/google/ngx_brotli.git
git clone --single-branch --recurse-submodules -b ${NAXSI_VERSION} https://github.com/nbs-system/naxsi.git
git clone --single-branch --recurse-submodules -b ${HEADERS_MORE_VERSION} https://github.com/openresty/headers-more-nginx-module.git
git clone --single-branch --recurse-submodules -b ${HTTP_AUTH_PAM_VERSION} https://github.com/sto/ngx_http_auth_pam_module.git
git clone --single-branch --recurse-submodules -b ${HTTP_CACHE_PURGE_VERSION} https://github.com/FRiCKLE/ngx_cache_purge.git
git clone --single-branch --recurse-submodules -b ${HTTP_FANCYINDEX_VERSION} https://github.com/aperezdc/ngx-fancyindex.git
git clone --single-branch --recurse-submodules -b ${NCHAN_VERSION} https://github.com/slact/nchan.git
git clone --single-branch --recurse-submodules -b ${HTTP_UPLOADPROGRESS_VERSION} https://github.com/masterzen/nginx-upload-progress-module.git
git clone --single-branch --recurse-submodules https://github.com/evanmiller/nginx_circle_gif.git
git clone --single-branch --recurse-submodules -b ${NGINX_OPENSSL_VERSION} https://github.com/apcera/nginx-openssl-version.git
git clone --single-branch --recurse-submodules https://github.com/cfsego/ngx_log_if.git
git clone --single-branch --recurse-submodules -b ${HTTP_INTERNAL_REDIRECT_VERSION} https://github.com/flygoast/ngx_http_internal_redirect.git
git clone --single-branch --recurse-submodules -b ${NGINX_PUSH_STREAM_VERSION} https://github.com/wandenberg/nginx-push-stream-module.git
git clone --single-branch --recurse-submodules https://github.com/flant/nginx-http-rdns.git
git clone --single-branch --recurse-submodules https://github.com/alticelabs/nginx-log-zmq.git
git clone --single-branch --recurse-submodules -b ${HTTP_ACCOUNTING_MODULE_VERSION} https://github.com/Lax/ngx_http_accounting_module.git
git clone --single-branch --recurse-submodules -b ${NGINX_VOD_VERSION} https://github.com/kaltura/nginx-vod-module.git

cd $HOME/rpmbuild/SPECS
patch -p0 < $PATCH_PATH
rpmbuild -ba nginx.spec

cp $HOME/rpmbuild/RPMS/x86_64/* /shared
