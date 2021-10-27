#lang racket

(define RACKET-BUILD "../racket-src/")
(delete-directory/files "my-catalog" #:must-exist? #f)
(system "raco pkg catalog-copy --from-config my-catalog")
(delete-file "my-catalog/pkgs-all")
(require "catalog-updator.rkt")
(update-all "my-catalog")
(define catalog-path (path->complete-path "my-catalog"))
(parameterize ([current-directory RACKET-BUILD])
  (system (format "make site SRRC_CATALOG=~a" catalog-path)))
