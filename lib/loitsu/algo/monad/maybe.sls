
(library (loitsu algo monad maybe)
    (export
      maybe-m)
  (import
    (rnrs)
    (loitsu algo monad util))

  (begin

    (define (m-bind mv f)
      (if mv (f mv) #f))

    (define (m-result v)
      v)

    (define-monad maybe-m
      m-bind m-result)

    ))

;; (do-monad list-m
;;           (a <- #f)
;;           (b <- 3)
;;           (* a b))
