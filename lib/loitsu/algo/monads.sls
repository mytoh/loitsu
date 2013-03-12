(library (loitsu algo monads)
    (export
      monad-maybe
      monad-list
      monad-identity
      monad-state
      do-monad)
  (import
    (rnrs)
    (loitsu algo monads list)
    (loitsu algo monads state)
    (loitsu algo monads identity)
    (loitsu algo monads maybe))

  (begin

    (define do-bind
      car)

    (define do-return
      cadr)

    (define-syntax do-monad
      (syntax-rules ()
        ((_ m (x e) body)
         ((do-bind m)
          e (lambda (x)
              ((do-return m) body))))
        ((_ m (x e x2 e2 ...) body)
         ((do-bind m)
          e (lambda (x)
              (do-monad m (x2 e2 ...)
                        body))))))

    ))
