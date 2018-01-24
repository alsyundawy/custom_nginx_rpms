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
curl -L -o naxi-${NAXSI_VERSION}.tar.gz https://github.com/nbs-system/naxsi/archive/${NAXSI_VERSION}.tar.gz
curl -L -o headers-more-nginx-module-${HEADERS_MORE_VERSION}.tar.gz https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz
curl -L -o http-auth-pam-${HTTP_AUTH_PAM_VERSION}.tar.gz https://github.com/sto/ngx_http_auth_pam_module/archive/v${HTTP_AUTH_PAM_VERSION}.tar.gz
curl -L -o http-cache-purge-${HTTP_CACHE_PURGE_VERSION}.tar.gz https://github.com/FRiCKLE/ngx_cache_purge/archive/${HTTP_CACHE_PURGE_VERSION}.tar.gz
curl -L -o http-fancyindex-${HTTP_FANCYINDEX_VERSION}.tar.gz https://github.com/aperezdc/ngx-fancyindex/archive/v${HTTP_FANCYINDEX_VERSION}.tar.gz
curl -L -o nchan-${NCHAN_VERSION}.tar.gz https://github.com/slact/nchan/archive/v${NCHAN_VERSION}.tar.gz
curl -L -o http-uploadprogress-${HTTP_UPLOADPROGRESS_VERSION}.tar.gz https://github.com/masterzen/nginx-upload-progress-module/archive/v${HTTP_UPLOADPROGRESS_VERSION}.tar.gz
curl -L -o http-upstream-fair.zip https://github.com/gnosek/nginx-upstream-fair/archive/master.zip

cd $HOME/rpmbuild/SPECS
patch -p0 < $PATCH_PATH
rpmbuild -ba nginx.spec

cp $HOME/rpmbuild/RPMS/x86_64/* /shared
