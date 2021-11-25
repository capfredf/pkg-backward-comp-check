# Package Backward Compatibility Check

A package to check the backward compatibility of changes to Racket or a package
included Racket installers. In other words, this is an executable version of
[Running a pkg-build
today](https://blog.racket-lang.org/2020/03/running-pkg-build-today.html).

## Usage
1. use `raco pkg-bcc new-config` to create a new config file, `config.rktd`, in the current directory. Change the file accordingly.

2. use `raco pkg-bcc build-docker-images` to build all necessary docker images.

3. use `raco pkg-bcc build-racket` to build an racket installer.

4. use `raco pkg-bcc start-site-server` to start a web server to serve the installer site

5. use `raco pkg-bcc build-dependent-packages` to build and check all packages specified in the `config.rktd`
