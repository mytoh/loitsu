
(library (loitsu algo monad util)
  (export
    define-monad)
  (import
    (rnrs)
    )

  (begin

    (define-syntax define-monad
      (syntax-rules  ()
        ((_ name bind result)
         (define name
           (list bind result)))))

    ))
