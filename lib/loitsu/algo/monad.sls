
(library (loitsu algo monad)
  (export
    maybe-m
    list-m
    identity-m
    do-monad)
  (import
    (rnrs)
    (loitsu algo monad list)
    (loitsu algo monad identity)
    (loitsu algo monad maybe))

  (begin

    (define bind
      car)

    (define result
      cadr)

    (define-syntax do-monad
      (syntax-rules (<-)
        ((_ m (x <- e ) body)
         ((bind m)
          e
          (lambda (x)
            ((result m) body))))
        ((_ m (x <- e x2 <- e2 ...) body)
         ((bind m)
          e (lambda (x)
              (do-monad m (x2 <- e2 ...)
                        body))))))

    ))
