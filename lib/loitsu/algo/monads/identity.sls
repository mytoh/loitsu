(library (loitsu algo monads identity)
    (export
      monad-identity)
  (import
    (silta base)
    (loitsu algo monads util))

  (begin

    (define (m-bind mv f)
      (f mv))

    (define (m-return v)
      v)

    (define-monad monad-identity
      m-bind m-return)

    ))

;; (do-monad list-m
;;           (a 9)
;;           (b 3)
;;           (* a b))
;; => 27
