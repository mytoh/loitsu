(library (loitsu alist)
    (export
      rassoc
      rassq
      rassv
      )
  (import
    (silta base)
    (loitsu lamb)
    (loitsu control))


  (begin

    (define-case rassoc
      ((key alist)
       (rassoc key alist equal?))
      ((key alist eq-fn)
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


    ))
