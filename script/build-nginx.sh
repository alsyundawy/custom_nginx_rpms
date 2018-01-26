#!/bin/sh
set -xe

export LD_LIBRARY_PATH=/usr/local/lib/
echo /usr/local/lib >> /etc/ld.so.conf.d/custom-libs.conf
ldconfig
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

CENTOS_MAJOR_VERSION=$(rpm -q --qf '%{VERSION}' $(rpm -q --whatprovides redhat-release))
PATCH_PATH=$HOME/nginx.spec.centos${CENTOS_MAJOR_VERSION}.patch

NGINX_VERSION=$(grep '^+Version:' $PATCH_PATH | cut -d ' ' -f 2)

HEADERS_MORE_VERSION=0.33
HTTP_ACCOUNTING_MODULE=0.5
HTTP_AUTH_PAM_VERSION=1.5.1
HTTP_CACHE_PURGE_VERSION=2.3
HTTP_FANCYINDEX_VERSION=0.4.2
HTTP_INTERNAL_REDIRECT_VERSION=0.6
HTTP_UPLOADPROGRESS_VERSION=0.9.2
NAXSI_VERSION=0.55.3
NCHAN_VERSION=1.1.14
NGINX_OPENSSL_VERSION=0.04
NGINX_PUSH_STREAM_VERSION=0.5.4
NGINX_VOD_VERSION=1.22

NGINX_SRPM_FILE=nginx-${NGINX_VERSION}-1.el${CENTOS_MAJOR_VERSION}_4.ngx.src.rpm
curl -LO http://nginx.org/packages/centos/${CENTOS_MAJOR_VERSION}/SRPMS/${NGINX_SRPM_FILE}
rpm -Uvh $NGINX_SRPM_FILE

cd $HOME/rpmbuild/SOURCES
git clone --single-branch --recurse-submodules https://github.com/google/ngx_brotli.git
git clone --single-branch --recurse-submodules -b ${NAXSI_VERSION} https://github.com/nbs-system/naxsi.git
git clone --single-branch --recurse-submodules -b v${HEADERS_MORE_VERSION} https://github.com/openresty/headers-more-nginx-module.git
git clone --single-branch --recurse-submodules -b v${HTTP_AUTH_PAM_VERSION} https://github.com/sto/ngx_http_auth_pam_module.git
git clone --single-branch --recurse-submodules -b ${HTTP_CACHE_PURGE_VERSION} https://github.com/FRiCKLE/ngx_cache_purge.git
git clone --single-branch --recurse-submodules -b v${HTTP_FANCYINDEX_VERSION} https://github.com/aperezdc/ngx-fancyindex.git
git clone --single-branch --recurse-submodules -b v${NCHAN_VERSION} https://github.com/slact/nchan.git
git clone --single-branch --recurse-submodules -b v${HTTP_UPLOADPROGRESS_VERSION} https://github.com/masterzen/nginx-upload-progress-module.git
git clone --single-branch --recurse-submodules https://github.com/evanmiller/nginx_circle_gif.git
git clone --single-branch --recurse-submodules -b v${NGINX_OPENSSL_VERSION} https://github.com/apcera/nginx-openssl-version.git
git clone --single-branch --recurse-submodules https://github.com/cfsego/ngx_log_if.git
git clone --single-branch --recurse-submodules -b v${HTTP_INTERNAL_REDIRECT_VERSION} https://github.com/flygoast/ngx_http_internal_redirect.git
git clone --single-branch --recurse-submodules -b ${NGINX_PUSH_STREAM_VERSION} https://github.com/wandenberg/nginx-push-stream-module.git
git clone --single-branch --recurse-submodules https://github.com/flant/nginx-http-rdns.git
git clone --single-branch --recurse-submodules https://github.com/alticelabs/nginx-log-zmq.git
git clone --single-branch --recurse-submodules -b v${HTTP_ACCOUNTING_MODULE} https://github.com/Lax/ngx_http_accounting_module.git
git clone --single-branch --recurse-submodules -b ${NGINX_VOD_VERSION} https://github.com/kaltura/nginx-vod-module.git

cd $HOME/rpmbuild/SPECS
patch -p0 < $PATCH_PATH
rpmbuild -ba nginx.spec

cp $HOME/rpmbuild/RPMS/x86_64/* /shared
