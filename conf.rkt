#lang racket/base
(require racket/runtime-path)
(provide (all-defined-out))

(define conf (make-parameter #f))

(define-runtime-path build-dir "build")
(define-runtime-path docker-dir "docker")
(define-runtime-path config-example-file "config.rktd.example")

(define docker-image-prefix "capfredf/")

(define racket-build-image-name (string-append docker-image-prefix "racket-pkg-bcc:racket-build"))
(define racket-build-docker-file (build-path docker-dir "pkg-build-racket/"))

(define pkg-build-image-name (string-append docker-image-prefix "racket-pkg-bcc:pkg-build"))
(define pkg-build-docker-file (build-path docker-dir "pkg-build-deps/"))

(define local-site-dir (build-path build-dir "site"))
(define catalog "catalog")
(define local-catalog-dir (build-path build-dir catalog))
(define remote-catalog-dir (path->string (build-path "/root/" catalog)))
