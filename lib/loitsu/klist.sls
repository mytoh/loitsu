
(library (loitsu klist)
  (export
    klist?
    klist-ref)
  (import
    (rnrs)
    (only (srfi :13)
          string-ref)
    )

  (begin

    (define (klist? klst)
      (cond
        ((null? klst)
         #t)
        ((not (list? klst))
         #f)
        ((even? (length klst))
         (check-klist klst))
        (else
          #f)))

    (define (check-klist klst)
      (cond
        ((null? klst)
         #t)
        ((char=? #\: (string-ref (symbol->string (car klst)) 0))
         (check-klist (cddr klst)))
        (else
          #f)))

    (define (klist-ref key klst)
      (find-key eq? key klst))

    (define (find-key proc key klst)
      (cond
        ((null? klst)
         #f)
        ((proc key (car klst))
         (list (car klst) (cadr klst)))
        (else
          (klist-ref key (cddr klst)))))

    ))
