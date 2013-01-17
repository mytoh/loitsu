;;;
;;;  taken from
;;;  gauche.experimental.lamb - shorthand notation of lambda
;;;

(library (loitsu lamb)
  (export
    ^.
    ^*)
  (import
    (rnrs)
    (match))

  (begin

    (define-syntax ^.
      (syntax-rules ()
        ((^. . clauses)
         (match-lambda . clauses))))

    (define-syntax ^*
      (syntax-rules ()
        ((^* . clauses)
         (match-lambda* . clauses))))

    ))

