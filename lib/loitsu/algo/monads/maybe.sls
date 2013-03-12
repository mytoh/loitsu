(library (loitsu algo monads maybe)
    (export
      monad-maybe)
  (import
    (rnrs)
    (loitsu algo monads util))

  (begin

    (define (m-bind mv f)
      (if mv (f mv) #f))

    (define (m-return v)
      v)

    (define-monad monad-maybe
      m-bind m-return)

    ))

;; (do-monad monad-maybe
;;           (a #f)
;;           (b 3)
;;           (* a b))
;;  => #f
