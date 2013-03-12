(library (loitsu algo monads state)
    (export
      monad-state)
  (import
    (silta base)
    (loitsu algo monads util))

  (begin

    (define (m-bind mv f)
      (lambda (s)
        (let* ((res (mv s))
               (val (car res))
               (new-state (cadr res)))
          ((f val) new-state))))

    (define (m-return v)
      (lambda (s)
        (list v s)))

    (define-monad monad-state
      m-bind m-return)

    ))

;; (do-monad monad-maybe
;;           (a #f)
;;           (b 3)
;;           (* a b))
;;  => #f
