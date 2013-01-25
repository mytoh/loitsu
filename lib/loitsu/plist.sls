
(library (loitsu plist)
    (export
      plist?
      pref)
  (import
    (rnrs)
    (only (srfi :13)
          string-ref))

  (begin

    (define (plist? lst)
      (cond
       ((null? lst)
        #t)
       ((not (list? lst))
        #f)
       ((even? (length lst))
        (check-plist lst))
       (else
        #f)))

    (define (check-plist lst)
      (cond
       ((null? lst)
        #t)
       ((char=? #\: (string-ref (symbol->string (car lst)) 0))
        (check-plist (cddr lst)))
       (else
        #f)))

    (define (pref lst key)
      (let ((found-pair (find-key eq? key lst)))
        (cadr found-pair)))

    (define (find-key proc key lst)
      (cond
       ((null? lst)
        #f)
       ((proc key (car lst))
        (list (car lst) (cadr lst)))
       (else
        (plist-ref key (cddr lst)))))

    ))
