
(library (loitsu list)
  (export
    scar
    scdr)
  (import
    (scheme base))


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
        lst)))) 

  )
