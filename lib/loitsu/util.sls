(library (loitsu util)
    (export
      tap
      comment
      nothing
      flip
      implications
      compose
      partial
      rpartial
      complement
      nor
      fork
      mtrace
      )
  (import
    (except (rnrs)
            cons*)
    (only (srfi :1 lists)
          cons*)
    (loitsu control)
    (loitsu lamb)
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
         (nothing))))


    (define-syntax compose
      (syntax-rules ()
        ((_ f) f)
        ((_ f g)
         (^:
          (() (f (g)))
          ((x) (f (g x)))
          ((x y) (f (g x y)))
          ((x y z) (f (g x y z)))
          ((x y z . args) (f (apply g x y z args)))))
        ((_ f g h)
         (^:
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

    (define (rpartial f . sargs)
      (lambda pargs
        (apply f (append pargs sargs))))

    (define-syntax nor
      (syntax-rules ()
        ((_ x ...)
         (not (or x ...)))))

    (define-case (complement f)
      (() (not (f)))
      ((x . zs) (not (apply f x zs))))

    (define (fork f g)
      ;; www.t3x.org/s9fes/hof.scm.html
      (lambda x
        (apply f (map g x))))

    ;; okmij.org/ftp/Scheme/macro-trace.txt
    (define-syntax mtrace
      (syntax-rules ()
        ((_ x)
         (begin
           (display "Trace: ")
           (write 'x)
           (newline)
           x))))

    ))
