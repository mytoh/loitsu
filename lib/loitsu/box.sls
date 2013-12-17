;; -*- coding: utf-8 -*-

(library (loitsu box)
    (export
      make-box
      box
      unbox
      box?)
  (import
    (silta base))

  (begin

    (define-syntax make-box
      (syntax-rules ()
        ((_ name value)
         (define name
           (box value)))))

    (define (box value)
      (cons '<box> value))

    (define (unbox b)
      (cdr b))

    (define (box? x)
      (cond
          ((pair? x)
           (if (eq? '<box> (car x))
             #t #f))
        (else
            #f)))

    ))
