
(library (loitsu list)
  (export
    flatten
    rassoc
    rassq
    rassv
    scar
    scdr
    safe-length)
  (import
    (rnrs)
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


    ))
