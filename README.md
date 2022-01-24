# Backward Compatibility Checker

A package to check backward compatibility of changes to Racket or packages
included the Racket base distribution. In other words, this is an executable version of
[Running a pkg-build
today](https://blog.racket-lang.org/2020/03/running-pkg-build-today.html).

## Usage

Since the package builds racket and packages using docker, you need to
run all the following commands except `raco pkg-bcc new-config` as a root user or
run your docker daemon in the rootless mode.

1. use `raco bc-check new-config` to create a new config file, `config.rktd`, in
the current directory. Change the file accordingly.

2. use `raco bc-check create-fresh-container` to create a new container for building racket.

3. use `raco bc-check build-racket` to build a racket installer.

4. use `raco bc-check start-site-server` to start a web server to serve the installer site

5. use `raco bc-check build-dependent-packages` to build and check all dependents of
the packages specified in the `config.rktd`. After it is done, results of building and testing
those packages can be found in `workdir/server/built`. See [the
page](https://docs.racket-lang.org/pkg-build/work-dir.html) of the
documentation for pkg-build for more details.
