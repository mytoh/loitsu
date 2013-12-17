(library (loitsu algo monads list)
    (export
      monad-list)
  (import
    (silta base)
    (loitsu algo monads util))

  (begin

    (define (m-bind mv f)
      (apply append (map f mv)))

    (define (m-return v)
      (list v))

    (define-monad monad-list
      m-bind m-return)

    ))

;; (do-monad list-m
;;           (a '(9))
;;           (b '(3 3))
;;           (* a b))
;; => (27 27)
