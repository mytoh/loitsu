(library (loitsu alist)
    (export
      rassoc
      rassq
      rassv
      )
  (import
    (rnrs)
    (loitsu control))


  (begin

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


    ))
