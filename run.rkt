#lang racket/base
(require package-analysis
         rebellion/collection/multidict
         "catalog-updator.rkt"
         racket/set
         racket/file
         racket/pretty
         racket/system
         "conf.rkt"
         "build.rkt")

(define (build-racket! catalog-dir)
  (define RACKET-BUILD "../racket-src/")
  (delete-directory/files catalog-dir #:must-exist? #f)
  (system (format "raco pkg catalog-copy --from-config ~a" catalog-dir))
  (delete-file (build-path catalog-dir "pkgs-all"))
  (update-all catalog-dir)
  (define catalog-path (path->complete-path "my-catalog"))
  (parameterize ([current-directory RACKET-BUILD])
    (system (format "make site SRC_CATALOG=~a" catalog-path))))

(define (build-dependent-packages!)
  (define g (get-dependency-graph))
  (define pkgs (sort (set->list
                      (foldl (lambda (p acc)
                               (set-union (multidict-ref (multidict-inverse g) p) acc))
                             (set)
                             (hash-ref (conf) "pkgs")))
                     string<=?))
  (build-packages pkgs))


(define (start-site-server)
  (void))

(module+ main
  (require racket/cmdline)
  (define-values (cmd args)
    (command-line #:args (cmd . args)
                  (values cmd args)))
  (case cmd
    [("build-racket")
     (build-racket! (car args))]
    [("start-site-server")
     (start-site-server)]
    [("build-dependent-packages")
     (build-dependent-packages!)]))
