#!/bin/sh
set -xe

CENTOS_MAJOR_VERSION=$(rpm -q --qf '%{VERSION}' $(rpm -q --whatprovides redhat-release))
PATCH_PATH=$HOME/nginx.spec.centos${CENTOS_MAJOR_VERSION}.patch

NGINX_VERSION=$(grep '^+Version:' $PATCH_PATH | cut -d ' ' -f 2)
NAXSI_VERSION=$(grep 'naxsi-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@naxsi-\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2.\3@')
HEADERS_MORE_VERSION=$(grep 'headers-more-nginx-module-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@headers-more-nginx-module-\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2@')
HTTP_AUTH_PAM_VERSION=$(grep 'http-auth-pam-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@http-auth-pam-\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2.\3@')
HTTP_CACHE_PURGE_VERSION=$(grep 'http-cache-purge-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@http-cache-purge-\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2@')
HTTP_FANCYINDEX_VERSION=$(grep 'http-fancyindex-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@http-fancyindex-\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2.\3@')
NCHAN_VERSION=$(grep 'nchan-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@nchan-\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2.\3@')
HTTP_UPLOADPROGRESS_VERSION=$(grep 'http-uploadprogress-.*\.tar\.gz' $PATCH_PATH | cut -d ' ' -f 2 | sed -e 's@http-uploadprogress-\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)\.tar\.gz@\1.\2.\3@')

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

cd $HOME/rpmbuild/SPECS
patch -p0 < $PATCH_PATH
rpmbuild -ba nginx.spec

cp $HOME/rpmbuild/RPMS/x86_64/* /shared
