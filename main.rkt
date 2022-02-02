#lang racket/base
(require package-analysis
         (for-syntax syntax/parse racket/base racket/syntax)
         rebellion/collection/multidict
         "conf.rkt"
         "catalog-updator.rkt"
         remote-shell/docker
         racket/set
         racket/file
         racket/system
         "build.rkt")

(define CONTAINER-NAME "build-racket")
(define-syntax (with-docker stx)
  (syntax-parse stx
    [(_ container-name e:expr ...)
     (with-syntax ([copy (format-id stx "copy")]
                   [exec (format-id stx "exec")]
                   [remote (format-id stx "remote")])
       #'(begin
           (docker-start #:name container-name)
           (let ([remote (lambda (dir)
                           (format "~a:~a" container-name dir))]
                 [copy (lambda (src dest)
                         (docker-copy #:name container-name #:src src #:dest dest))]
                 [exec (lambda (cmd . args)
                         (apply docker-exec cmd args #:name container-name))])
             e ...
             (docker-stop #:name container-name))))]))

(define (build-racket!)
  (delete-directory/files local-catalog-dir #:must-exist? #f)
  (system (format "raco pkg catalog-copy https://pkgs.racket-lang.org/ ~a" local-catalog-dir))
  (delete-file (build-path local-catalog-dir "pkgs-all"))
  (update-all local-catalog-dir)
  (with-docker CONTAINER-NAME
    (copy local-catalog-dir (remote remote-catalog-dir))
    (exec "git" "clone" "--depth" "1" "https://github.com/racket/racket.git"
          "/root/racket-src")
    (exec "make" "-C" "/root/racket-src" "site"
          (format "SRC_CATALOG=~a" remote-catalog-dir)
          "SERVER_HOSTS=127.0.0.1"
          "SERVER=127.0.0.1")
    (delete-directory/files local-site-dir #:must-exist? #f)
    (copy (remote "/root/racket-src/build/site")
          local-site-dir)))

(define (build-docker-images!)
  (docker-build #:name pkg-build-image-name #:content pkg-build-docker-file)
  (docker-build #:name racket-build-image-name #:content racket-build-docker-file))

(define (build-dependent-packages!)
  (define g (get-dependency-graph))
  (define pkgs (sort (set->list
                      (foldl (lambda (p acc)
                               (set-union (multidict-ref (multidict-inverse g) p) acc))
                             (set)
                             (hash-ref (conf) 'pkgs)))
                     string<=?))
  (build-packages pkgs))


(define (start-site-server)
  (define racket-path (find-system-path 'exec-file))
  (system (format "~a -l raco -- static-web -d ~a" racket-path local-site-dir)))

(define (create-fresh-container!)
  (when (docker-id #:name CONTAINER-NAME)
    (when (docker-running? #:name CONTAINER-NAME)
      (docker-stop #:name CONTAINER-NAME))
    (docker-remove #:name CONTAINER-NAME))
  (docker-create #:name CONTAINER-NAME #:image-name racket-build-image-name))

(define (init-env!)
  (unless (directory-exists? build-dir)
    (make-directory build-dir)))

(module+ main
  (require racket/cmdline)
  (command-line
   #:args (cmd)
   (if (equal? cmd "new-config")
       (copy-file config-example-file (build-path (current-directory) "config.rktd") #t)
       (parameterize ((conf (read (open-input-file "config.rktd"))))
         (case cmd
           [("build-docker-images")
            (build-docker-images!)]
           [("create-fresh-container")
            (create-fresh-container!)]
           [("build-racket")
            (init-env!)
            (build-racket!)]
           [("start-site-server")
            (start-site-server)]
           [("build-packages")
            (build-dependent-packages!)]
           [else (eprintf "invalid command: ~a" cmd)])))))
