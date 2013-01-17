
(library (loitsu algo monad list)
  (export
    list-m)
  (import
    (rnrs)
    (loitsu algo monad util))

  (begin

    (define (m-bind mv f)
      (apply append (map f mv)))

    (define (m-result v)
      (list v))

    (define-monad list-m
      m-bind m-result)

    ))

 ; (do-monad list-m
 ;           (a <- '(9))
 ;           (b <- '(3 3))
 ;           (* a b))
