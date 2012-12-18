

(library (loitsu util)
  (export
    tap
    comment
    nothing
    flip
    implications
    comp
    partial
    )
  (import
    (except (rnrs)
            cons*)
    (only (srfi :1)
          cons*)
    (loitsu control)
    )


  (begin

    (define (tap f x)
      (f x) x)


    (define nothing
      (lambda ()
        (values)))


    (define (flip f)
      (lambda args (apply f (reverse args))))

    ;; http://people.csail.mit.edu/jhbrown/scheme/macroslides03.pdf
    ;; http://valvallow.blogspot.jp/2010/05/implecations.html
    (define-syntax implications
      (syntax-rules (=>)
        ((_ (pred => body ...) ...)
         (begin
           (when pred body ...) ...))))

    (define-syntax comment
      (syntax-rules ()
        ((_ x ...)
         (values))))


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
              (* x (f (- x 1))))))))

    (define fib
      (Y
        (lambda (f)
          (lambda (x)
            (if (< x 2)
              x
              (+ (f (- x 1)) (f (- x 2))))))))

    (define-syntax comp
      (syntax-rules ()
        ((_ f) f)
        ((_ f g)
         (case-lambda
           (() (f (g)))
           ((x) (f (g x)))
           ((x y) (f (g x y)))
           ((x y z) (f (g x y z)))
           ((x y z . args) (f (apply g x y z args)))))
        ((_ f g h)
         (case-lambda
           (() (f (g (h))))
           ((x) (f (g (h x))))
           ((x y) (f (g (h x y))))
           ((x y z) (f (g (h x y z))))
           ((x y z . args) (f (g (apply h x y z args))))))
        ((_ f1 f2 f3 . fs)
         (let ((fs (reverse (cons* f1 f2 f3 fs))))
           (lambda args
             (let loop ((ret (apply (car fs) args))
                        (fs (cdr fs)))
               (if (null? fs)
                 ret
                 (loop ((car fs) ret) (cdr fs)))))))))


    (define-syntax partial
      (syntax-rules ()
      ((_ f arg)
       (lambda args (apply f arg args)))
      ((_ f arg ...)
       (lambda args (apply f arg ... args)))))



    ))
