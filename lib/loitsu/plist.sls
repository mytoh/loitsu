(library (loitsu plist)
    (export
      plist?
      pref
      pappend
      pmap
      plist
      pkeys
      pvals
      )
  (import
    (silta base)
    (only (srfi :13)
          string-ref)
    (loitsu lamb))

  (begin

    ;; internal functions

    (define (%check-plist lst)
      (cond
          ((null? lst)
           #t)
        ((char=? #\: (string-ref (symbol->string (car lst)) 0))
         (%check-plist (cddr lst)))
        (else
            #f)))

    (define (%find-key proc key lst)
      (cond
          ((null? lst)
           #f)
        ((proc key (car lst))
         (list (car lst) (cadr lst)))
        (else
            (%find-key proc key (cddr lst)))))


    ;;;

    (define (pref lst key)
      (let ((found-pair (%find-key eq? key lst)))
        (cadr found-pair)))

    (define (plist? lst)
      (cond
          ((null? lst)
           #f)
        ((not (list? lst))
         #f)
        ((even? (length lst))
         (%check-plist lst))
        (else
            #f)))

    (define-case plist
      ((key value)
       (list key value))
      ((key value . rest)
       (apply list key value rest)))

    (define (pkeys lst)
      (cond
          ((null? lst) '())
        (else
            (cons (car lst)
              (pkeys (cddr lst))))))

    (define (pvals lst)
      (cond
          ((null? lst) '())
        (else
            (cons (cadr lst)
              (pvals (cddr lst))))))


    (define (pappend lst key value)
      (append lst (list key value)))

    (define (pmap proc lst)
      (cond
          ((null? lst) '())
        (else
            (let ((key (car lst))
                  (value (cadr lst)))
              (append (list key (proc value))
                (pmap proc (cddr lst)))))))



    ))
