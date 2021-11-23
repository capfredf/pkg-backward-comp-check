#lang racket/base
(provide (all-defined-out))

(define conf (make-parameter #f))
(conf (read (open-input-file "config.rktd")))
