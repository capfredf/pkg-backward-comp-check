#lang racket/base
(require "conf.rkt")

; format a GitHub package URL for a branch, see:
; https://docs.racket-lang.org/pkg/getting-started.html#(part._github-deploy)
(define (make-tgt-url pkg-name)
  (define tgt-repo (hash-ref (conf) 'repo))
  (define tgt-branch (hash-ref (conf) 'branch))
  (format "git://github.com/~a.git?path=~a#~a"
          tgt-repo pkg-name tgt-branch))

;; update three fields: '(source checksum versions)
(define (update-pkg-hash h pkg-name)
  (define tgt-commit (hash-ref (conf) 'commit))
  (define u (make-tgt-url pkg-name))
  (let* ((h (hash-set h 'source u))
         (h (hash-set h 'checksum tgt-commit))
         (h (if (hash-has-key? h 'versions)
              (hash-update
                h 'versions
                (lambda (vh)
                  (hash-set
                    vh 'default
                    (hash 'source u 'checksum tgt-commit 'source-url u))))
              h)))
    h))

;; edit one file
(define (update-pkg-file p pkg-name)
  (let* ((h (with-input-from-file p read))
         (h (update-pkg-hash h pkg-name)))
    (with-output-to-file p #:exists 'replace (lambda () (writeln h)))))

(provide update-all)

(define (update-all cat-dir)
  (define pkg* (hash-ref (conf) 'pkgs))
  (for ((pkg-name (in-list pkg*)))
    (define p (build-path cat-dir "pkg" pkg-name))
    (update-pkg-file p pkg-name)))
