#lang racket/base
(require racket/runtime-path)
(provide (all-defined-out))

(define-runtime-path build-dir "build")
(define conf (make-parameter #f))
(define racket-build-image-name "capfredf/build-racket")
(define local-site-dir (build-path build-dir "site"))
(define catalog "catalog")
(define local-catalog-dir (build-path build-dir catalog))
(define remote-catalog-dir (path->string (build-path "/root/" catalog)))
