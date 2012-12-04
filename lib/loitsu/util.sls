

(library (loitsu util)
  (export
    tap
    comment
    nothing
    flip
    implications
    )
  (import
    (rnrs))


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



    ))
