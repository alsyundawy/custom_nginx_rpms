[![CircleCI](https://circleci.com/gh/colundrum/custom_nginx_rpms.svg?style=svg)](https://circleci.com/gh/colundrum/custom_nginx_rpms)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms?ref=badge_shield)

# What is this repository?

[Nginx](http://nginx.org) with :

- [naxsi](https://github.com/nbs-system/naxsi)
- [headers-more](https://github.com/openresty/headers-more-nginx-module)
- [auth-pam](https://github.com/sto/ngx_http_auth_pam_module<Paste>)
- [cache-purge](https://github.com/FRiCKLE/ngx_cache_purge)
- [fancyindex](https://github.com/aperezdc/ngx-fancyindex)
- [nchan](https://github.com/slact/nchan)
- [upload-progress](https://github.com/masterzen/nginx-upload-progress-module)

You can build RPM with headers-more-module using the official SRPM.

# How to build RPM?

1. Create your feature branch(e.g nginx-1.8.1)
2. Update 2 files according to the methods described below
    - nginx.spec.centos7.patch
3. Push to the branch
4. Create a Pull request
5. When the Pull request is merged, CircleCI will release nginx rpms to https://github.com/colundrum/custom_nginx_rpms/releases

# How to update nginx.spec.centos[7].patch?

### Requirement

* rpm2cpio

    ```
    # OSX
    $ brew install rpm2cpio

### CentOS7

```
$ curl -LO http://nginx.org/packages/centos/7/SRPMS/nginx-1.8.1-1.el7.ngx.src.rpm
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
#   Update headers-more-nginx-module version if needed

$ diff -u nginx.spec.org nginx.spec >! nginx.spec.centos7.patch
```


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fcolundrum%2Fcustom_nginx_rpms?ref=badge_large)