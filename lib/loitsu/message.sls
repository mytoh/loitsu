
(library (loitsu message)
  (export
    message
    ohei)
  (import
    (rnrs)
    (loitsu string)
    (loitsu maali))

  (begin

    (define-syntax ohei
      (syntax-rules ()
        ((_ msg)
         (begin
           (message ">>>" msg 42)
           (newline)))
        ((_ msg ...)
         (begin
           (message ">>>" (str msg ...)  42)
           (newline)))))

    (define (message symbol text colour)
      (display (string-append (paint symbol colour) " " text)))

    ))
