(library (loitsu combinator)
    (export
      S
      K
      I
      B
      C
      W
      o
      O
      Y
      Z
      )
  (import
    (rnrs)
    (loitsu util))

  (begin

    (define (S x)
      (lambda (y)
        (lambda (z)
          ((x z) (y z)))))

    (define (K x)
      (lambda (y)
        x))

    (define (I x)
      x)

    (define (B x)
      (lambda (y)
        (lambda (z)
          (x (y z)))))

    (define (C x)
      (lambda (y)
        (lambda (z)
          ((x z) y))))

    (define (W x)
      (lambda (y)
        ((x y) y)))

    (define (o x)
      (x x))

    (define (O)
      (o o))

    (define (Y g)
      ((lambda (x) (g (x x)))
       (lambda (x) (g (x x)))))

    (define (Z f)
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
     ((Z fact) 5)
     120


     ;; http://rosettacode.org/wiki/Y_combinator#Scheme
     (define Y
       (lambda (f)
         ((lambda (x) (x x))
          (lambda (g)
            (f (lambda args (apply (g g) args)))))))

     (define fac
       (Y
        (lambda (f)
          (lambda (x)
            (if (< x 2)
              1
              (* x (f (- x 1))))))))  ;

     (define fib
       (Y
        (lambda (f)
          (lambda (x)
            (if (< x 2)
              x
              (+ (f (- x 1)) (f (- x 2))))))))
     )

    ))
