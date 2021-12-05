#lang info

(define name "package backward compatibility check")
(define collection "bc-checker")
(define version "0.1")
(define deps '("base" "raco-static-web" "package-analysis" "rebellion" "remote-shell" "pkg-build"))
(define build-deps '())
(define pkg-authors '(moonsolo@gmail.com))

(define raco-commands
  '(("bc-check"
     (submod bc-checker main)
     "checks the backward compatibility of a change to Racket or base packages"
     10)))
