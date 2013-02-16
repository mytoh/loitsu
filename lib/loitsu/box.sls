;; -*- coding: utf-8 -*-

;; module to convert rgb.txt to list

(library (loitsu box)
    (export
      box
      unbox)
  (import
    (silta base)
    )

  (begin

    (define (box value)
      (cons '<box> value))

    (define (unbox b)
      (cdr b))

    ))
