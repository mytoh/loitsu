
(library (loitsu string)
  (export
    x->string)
  (import
    (scheme base)
    (srfi :48 )
    )

  (begin

    (define (x->string obj)
      (cond
        ((string? obj) obj)
        ((number? obj) (number->string obj))
        ((symbol? obj) (symbol->string obj))
        ((char?   obj) (string obj))
        (else          (format "~a" obj))))
    )
  )
