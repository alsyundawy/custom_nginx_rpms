[![CircleCI](https://circleci.com/gh/colundrum/custom_nginx_rpms.svg?style=svg)](https://circleci.com/gh/colundrum/custom_nginx_rpms)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms?ref=badge_shield)

To use this package, you need to install :

- epel            : `yum install epel-release`
- epel-multimedia : `yum-config-manager --add-repo=https://negativo17.org/repos/epel-multimedia.repo`

# What is this repository?

[Nginx](http://nginx.org) with :

- compat
- file-aio
- http_addition_module
- http_auth_request_module
- http_geoip_module=dynamic
- http_gunzip_module
- http_gzip_static_module
- http_image_filter_module=dynamic
- http_mp4_module
- http_perl_module=dynamic
- http_realip_module
- http_secure_link_module
- http_slice_module
- http_ssl_module
- http_stub_status_module
- http_sub_module
- http_v2_module
- http_xslt_module=dynamic
- pcre-jit
- stream
- stream_realip_module
- stream_ssl_module
- stream_ssl_preread_module
- threads


- Additional CC FLAGS :
  - DTCP_FASTOPEN : activate TCP FASTOPEN usage


- External modules :
  - [brotli](https://github.com/google/ngx_brotli)
  - [cache_purge](https://github.com/FRiCKLE/ngx_cache_purge)
  - [circle_gif](https://github.com/evanmiller/nginx_circle_gif)
  - [ct](https://github.com/grahamedgecombe/nginx-ct)
  - [fancyindex](https://github.com/aperezdc/ngx-fancyindex)
  - [headers-more](https://github.com/openresty/headers-more-nginx-module)
  - [traffic-accounting-nginx-module](https://github.com/Lax/traffic-accounting-nginx-module)
  - [http_auth_pam](https://github.com/sto/ngx_http_auth_pam_module)
  - [http_internal_redirect](https://github.com/flygoast/ngx_http_internal_redirect)
  - [http-rdns](https://github.com/flant/nginx-http-rdns)
  - [log_if](https://github.com/cfsego/ngx_log_if)
  - [log-zmq](https://github.com/alticelabs/nginx-log-zmq)
  - [naxsi](https://github.com/nbs-system/naxsi)
  - [nchan](https://github.com/slact/nchan)
  - [openssl-version](https://github.com/apcera/nginx-openssl-version)
  - [push-stream-module](https://github.com/wandenberg/nginx-push-stream-module)
  - [upload-progress](https://github.com/masterzen/nginx-upload-progress-module)

# How to build RPM?

1. Create your feature branch(e.g nginx-1.8.1)
2. Update `nginx.spec.centos7.patch` according to the methods described below
3. Push to the branch
4. Create a Pull request
5. When the Pull request is merged, CircleCI will release nginx rpms to https://github.com/colundrum/custom_nginx_rpms/releases

# How to update nginx.spec.centos7.patch?

### Requirement

* rpm2cpio

### CentOS7

```
$ curl -LO http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.13.10-1.el7_4.ngx.src.rpm
$ rpm2cpio.pl nginx-1.8.1-1.el7.ngx.src.rpm | cpio -idv nginx.spec
$ cp nginx.spec nginx.spec.org
$ patch -p0 < nginx.spec.centos7.patch
patching file nginx.spec
Hunk #1 FAILED at 59.
Hunk #9 FAILED at 346.
2 out of 9 hunks FAILED -- saving rejects to file nginx.spec.rej

# Modify `nginx.spec` as below using your favorite editor.
#   Fix `Release:`
#   Add `Packager:`
#   Add your changelog to `%changelog`
#   Update exaternal modules version if needed

$ diff -u nginx.spec.org nginx.spec >! nginx.spec.centos7.patch
```


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms?ref=badge_large)
