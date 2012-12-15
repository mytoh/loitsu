
(library (loitsu list)
  (export
    flatten
    scar
    scdr)
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

    ))
