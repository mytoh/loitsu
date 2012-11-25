;; -*- coding: utf-8 -*-

(library (pieni mini)
  (export
    define-test
    is
    are
    )
  (import
    (scheme base)
    (scheme write)
    (pieni check))

  (begin

    (define-syntax define-test
      (syntax-rules ()
        ((_ name expr ...)
         (do-test
           (display (symbol->string 'name))
           (newline)
           expr
           ...))))


    (define-syntax is
      (syntax-rules ()
        ((_ form expect)
         (check form => expect))))

    (define-syntax are
      (syntax-rules ()
        ((_ form expect)
         (is form expect))
        ((_ form expect . rest)
         (begin
           (is form expect)
           (are . rest)
           ))
        ))

    ; (define (== t1 t2)
    ;   (cond
    ;     ((boolean? t1)
    ;      (eq? t1 t2))
    ;     ((string? t1)
    ;      (string=? t1 t2))
    ;     ((number? t1)
    ;      (= t1 t2))
    ;     (else
    ;       (equal? t1 t2))))


    (define-syntax do-test
      (syntax-rules ()
        ((_ body ...)
         (begin
           body
           ...))))

    ))



