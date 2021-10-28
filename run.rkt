#lang racket/base
(require package-analysis
         rebellion/collection/multidict
         "catalog-updator.rkt"
         racket/set
         racket/file
         racket/system
         "build.rkt")

(define (build-racket!)
  (define RACKET-BUILD "../racket-src/")
  (delete-directory/files "my-catalog" #:must-exist? #f)
  (system "raco pkg catalog-copy --from-config my-catalog")
  (delete-file "my-catalog/pkgs-all")
  (update-all "my-catalog")
  (define catalog-path (path->complete-path "my-catalog"))
  (parameterize ([current-directory RACKET-BUILD])
    (system (format "make site SRC_CATALOG=~a" catalog-path))))

(define (build-dependent-packages!)
  (define g (get-dependency-graph))
  (define pkgs (set->list
                (foldl (lambda (p acc)
                         (set-union (multidict-ref (multidict-inverse g) p) acc))
                       (set)
                       (list "source-syntax" "typed-racket" "typed-racket-doc"
                             "typed-racket-lib" "typed-racket-more" "typed-racket-test"))))
  (build-packages pkgs))

(build-dependent-packages!)
