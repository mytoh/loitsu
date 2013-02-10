;;;
;;;  taken from
;;;  gauche.experimental.lamb - shorthand notation of lambda
;;;

(library (loitsu lamb)
    (export
      ^.
      ^*
      ^:)
  (import
    (silta base)
    (silta case-lambda)
    (match))

  (begin

    (define-syntax ^.
      (syntax-rules ()
        ((_ clause ...)
         (match-lambda  clause ...))))

    (define-syntax ^*
      (syntax-rules ()
        ((_  clause ...)
         (match-lambda* clause ...))))

    (define-syntax ^:
      (syntax-rules ()
        ((_ clause ...)
         (case-lambda clause ...))))

    ))
