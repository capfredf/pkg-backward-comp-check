#lang racket/base
(require pkg-build
         racket/runtime-path)

;; Don't run as a test:
(module test racket/base)

(define-runtime-path workdir "workdir")

(provide build-packages)
(define (build-packages packages)
  (build-pkgs
   #:work-dir workdir
   #:snapshot-url "http://127.0.0.1:8000"

   #:installer-name "racket-8.3.0.5-x86_64-linux.sh"

   #:pkgs-for-version "8.3.0.5"

   #:extra-packages '("main-distribution-test")
   #:only-packages packages

   #:built-at-site? #t
   #:site-url "https://127.0.0.1:8000"

   #:install-doc-list-file "orig-docs.txt"

   #:timeout 2400

   #:vms (list
          (make-docker-vms "pkg-build")
          #;
          (make-docker-vms "pkg-build2"))

   #:steps (steps-in 'download 'site)))

;; Set to #f to disable the memory limit on cnotainers; if not #f,
;; twice as much memory will be available counting swap:
(define memory-mb 1024)

;; Create Docker "full" and "minimal" variants:
(define (make-docker-vms name)
  (docker-vm
   #:name name
   #:from-image "racket/pkg-build:pkg-build-deps"
   #:env test-env
   #:shell xvfb-shell
   #:memory-mb memory-mb
   #:minimal-variant (docker-vm #:name (string-append name "-min")
                                #:from-image "racket/pkg-build:pkg-build-deps-min"
                                #:memory-mb memory-mb)))

;; Some packages may depend on this, since pkg-build.racket-lang.org
;; defines it:
(define test-env
  (list (cons "PLT_PKG_BUILD_SERVICE" "1")))

;; Use `xvfb-run` on the non-minimal VM to allow GUI programs to work:
(define xvfb-shell
  '("/usr/bin/xvfb-run" "-n" "1" "/bin/sh" "-c"))
