
(library (loitsu message)
  (export
    ohei)
  (import
    (rnrs)
    (loitsu string)
    (loitsu maali))

  (begin

    ; (define (ohei . msg)
    ;   )

    (define-syntax ohei
      (syntax-rules ()
        ((_ msg)
         (begin
           (display (paint "==>" 42))
           (display " ")
           (display msg)
           (newline)))
        ((_ msg ...)
         (begin
           (display (paint "==>" 42))
           (display " ")
           (display (str msg ...))
           (newline)))))

    ))
