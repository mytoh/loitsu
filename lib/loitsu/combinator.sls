
(library (loitsu combinator)
  (export
    comb-s
    comb-k
    comb-i
    comb-b
    comb-c
    comb-w
    comb-somega
    comb-lomega
    comb-y
    comb-z
    )
  (import
    (rnrs)
    (loitsu util))

  (begin

    (define (comb-s x)
      (lambda (y)
        (lambda (z)
        ((x z) (y z)))))

    (define (comb-k x)
      (lambda (y)
        x))

    (define (comb-i x)
      x)

    (define (comb-b x)
      (lambda (y)
        (lambda (z)
          (x (y z)))))

    (define (comb-c x)
      (lambda (y)
        (lambda (z)
          ((x z) y))))

    (define (comb-w x)
      (lambda (y)
        ((x y) y)))

    (define (comb-somega x)
      (x x))

    (define (comb-lomega)
      (comb-somega comb-somega))

    (define (comb-y g)
      ((lambda (x) (g (x x)))
       (lambda (x) (g (x x)))))

    (define (comb-z f)
      ((lambda (x)
         (f (lambda (y) ((x x) y))))
       (lambda (x)
         (f (lambda (y) ((x x) y))))))

    (comment
      (define (fact f)
        (lambda (x)
          (if (= x 0)
            1
            (* x (f (- x 1))))))
      ((comb-z fact) 5)
      120)

    ))
