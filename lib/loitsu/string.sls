
(library (loitsu string)
  (export
    string-split
    str
    x->string)
  (import
    (scheme base)
    (scheme write)
    (only (srfi :13)
          string-join)
    (srfi :48)
    (loitsu string compat)
    )

  (begin

    (define (x->string obj)
      (cond
        ((string? obj) obj)
        ((number? obj) (number->string obj))
        ((symbol? obj) (symbol->string obj))
        ((char?   obj) (string obj))
        (else          (format "~a" obj))))

    (define (str . rest)
      (string-join (map x->string rest)
                   ""))

    ))
