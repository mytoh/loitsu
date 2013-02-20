;;;
;;;  taken from
;;;  gauche.experimental.lamb - shorthand notation of lambda
;;;

(library (loitsu lamb)
    (export
      ^.
      ^*
      ^:
      define-case)
  (import
    (silta base)
    (silta case-lambda)
    (loitsu match))

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

    (define-syntax define-case
      (syntax-rules ()
        ((_ name clause ...)
         (define name
           (case-lambda
            clause ...)))))

    ))
