#lang info

(define name "package backward compatibility check")
(define collection "pkg-bc-check")
(define version "0.1")
(define deps '("raco-static-web" "package-analysis" "rebellion" "remote-shell" "pkg-build"))
(define build-deps '())
(define pkg-authors '(moonsolo@gmail.com))

(define raco-commands
  '(("pkg-bcc"
     (submod pkg-bc-check main)
     "checks the backward compatibility of a change to Racket or base packages"
     10)))
