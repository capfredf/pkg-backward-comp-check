#lang racket/base
;; Usage:
;;   racket edit-catalog.rkt my-catalog/

;; ---
;; TODO edit these variables
(define pkg*
  '("source-syntax" "typed-racket" "typed-racket-doc"
    "typed-racket-lib" "typed-racket-more" "typed-racket-test"))

(define tgt-repo "typed-racket")

(define tgt-branch "kinding")
(define tgt-user "capfredf")
(define tgt-commit "3ec3f43e61e9b775c2b4af47273e562ab0453a24")
;; ---

; format a GitHub package URL for a branch, see:
; https://docs.racket-lang.org/pkg/getting-started.html#(part._github-deploy)
(define (make-tgt-url pkg-name)
  (format "git://github.com/~a/~a.git?path=~a#~a"
          tgt-user tgt-repo pkg-name tgt-branch))

;; update three fields: '(source checksum versions)
(define (update-pkg-hash h pkg-name)
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
  (for ((pkg-name (in-list pkg*)))
    (define p (build-path cat-dir "pkg" pkg-name))
    (update-pkg-file p pkg-name)))

(module+ main
  (require racket/cmdline)
  (command-line
    #:args (cat-dir)
    (update-all cat-dir)))
