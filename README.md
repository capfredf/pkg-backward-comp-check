# Package Backward Compatibility Check

A package to check the backward compatibility of changes to Racket or a package
included Racket installers. In other words, this is an executable version of
[Running a pkg-build
today](https://blog.racket-lang.org/2020/03/running-pkg-build-today.html).

## Usage

Since the package builds racket and packages using docker, you need to
run this following commands except `raco pkg-bcc new-config` as a root user or
run your docker daemon in the rootless mode.

0. (optional) use `raco pkg-bcc build-docker-images` to build all necessary docker images.

1. use `raco pkg-bcc new-config` to create a new config file, `config.rktd`, in the current directory. Change the file accordingly.

2. use `raco pkg-bcc build-racket` to build an racket installer.

3. use `raco pkg-bcc start-site-server` to start a web server to serve the installer site

4. use `raco pkg-bcc build-dependent-packages` to build and check all packages
specified in the `config.rktd`. After it is done, results of building and test
the packages sit in `workdir/server/built`. See [the
page](https://docs.racket-lang.org/pkg-build/work-dir.html) of the
documentation for pkg-build for more details.
