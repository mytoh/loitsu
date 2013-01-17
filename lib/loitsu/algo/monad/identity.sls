
(library (loitsu algo monad identity)
  (export
    identity-m)
  (import
    (rnrs)
    (loitsu algo monad util))

  (begin

    (define (m-bind mv f)
      (f mv))

    (define (m-result v)
      v)

    (define-monad identity-m
      m-bind m-result)

    ))

 ; (do-monad list-m
 ;           (a <- 9)
 ;           (b <- 3)
 ;           (* a b))
