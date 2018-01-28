#!/bin/sh
set -xe

CENTOS_MAJOR_VERSION=$(rpm -q --qf '%{VERSION}' $(rpm -q --whatprovides redhat-release))
PATCH_PATH=$HOME/nginx.spec.centos${CENTOS_MAJOR_VERSION}.patch

NGINX_VERSION=$(grep '^+Version:' $PATCH_PATH | cut -d ' ' -f 2)

HEADERS_MORE_VERSION=$(curl --silent https://api.github.com/repos/openresty/headers-more-nginx-module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_ACCOUNTING_MODULE=$(curl --silent https://api.github.com/repos/Lax/ngx_http_accounting_module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_AUTH_PAM_VERSION=$(curl --silent https://api.github.com/repos/sto/ngx_http_auth_pam_module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_CACHE_PURGE_VERSION=$(curl --silent https://api.github.com/repos/FRiCKLE/ngx_cache_purge/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_FANCYINDEX_VERSION=$(curl --silent https://api.github.com/repos/aperezdc/ngx-fancyindex/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_INTERNAL_REDIRECT_VERSION=$(curl --silent https://api.github.com/repos/flygoast/ngx_http_internal_redirect/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
HTTP_UPLOADPROGRESS_VERSION=$(curl --silent https://api.github.com/repos/masterzen/nginx-upload-progress-module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
NAXSI_VERSION=$(curl --silent https://api.github.com/repos/nbs-system/naxsi/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
NCHAN_VERSION=$(curl --silent https://api.github.com/repos/slact/nchan/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
NGINX_OPENSSL_VERSION=$(curl --silent https://api.github.com/repos/apcera/nginx-openssl-version/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
NGINX_PUSH_STREAM_VERSION=$(curl --silent https://api.github.com/repos/wandenberg/nginx-push-stream-module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)
NGINX_VOD_VERSION=$(curl --silent https://api.github.com/repos/kaltura/nginx-vod-module/git/refs/tags | jq -r '.|reverse|.[].ref' | grep -v 'rc' | head -1 | cut -d '/' -f3)

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
git clone --single-branch --recurse-submodules -b ${HTTP_ACCOUNTING_MODULE} https://github.com/Lax/ngx_http_accounting_module.git
git clone --single-branch --recurse-submodules -b ${NGINX_VOD_VERSION} https://github.com/kaltura/nginx-vod-module.git

cd $HOME/rpmbuild/SPECS
patch -p0 < $PATCH_PATH
rpmbuild -ba nginx.spec

cp $HOME/rpmbuild/RPMS/x86_64/* /shared
