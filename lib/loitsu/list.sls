
(library (loitsu list)
    (export
      flatten
      reductions
      rassoc
      rassq
      rassv
      scar
      scdr
      drop*
      take*
      safe-length)
  (import
    (rnrs)
    (only (srfi :1)
          drop
          take)
    (loitsu lamb)
    (loitsu control))


  (begin

    (define (scdr lst)
                                        ; safe cdr
      (cond
       ((null? lst)
        '())
       ((or (list? lst)
            (pair? lst))
        (cdr lst))
       (else
        '())))

    (define (scar lst)
      (cond
       ((pair? lst)
        (car lst))
       (else
        lst)))


    (define (flatten lst)
      (cond
       ((null? lst) '())
       ((list? lst) (append (flatten (car lst)) (flatten (cdr lst))))
       (else (list lst))))

    ;; from info combinator page
    (define (safe-length lst)
      (if (list? lst)
          (length lst)
          #f))

    (define (rassoc key alist . args)
      (let-optionals* args ((eq-fn equal?))
                      (let loop ((lst alist))
                        (cond
                         ((null? lst) #f)
                         ((eq-fn key (cdr (car lst)))
                          (car lst))
                         (else
                          (loop (cdr lst)))))))

    (define (rassq key alist)
      (rassoc key alist eq?))

    (define (rassv key alist)
      (rassoc key alist eqv?))

    (define (take* lis k)
      (if (< (length lis) k)
          lis
          (take lis k)))

    (define (drop* lis k)
      (if (< (length lis) k)
          '()
          (drop lis k )))

    (define reductions
      (^:
       ((f l)
        (if (null? l)
            (list (f))
            (reductions f (car l) (cdr l))))
       ((f init l)
        (cons init
          (if (null? l)
              '()
              (reductions f (f init (car l)) (cdr l)))))))

    ))
