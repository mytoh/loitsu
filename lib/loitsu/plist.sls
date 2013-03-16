(library (loitsu plist)
    (export
      plist?
      pref
      passoc
      pdissoc
      pmap
      plist
      pkeys
      pvals
      pfirst
      psecond
      pthird
      prest
      pcar
      pcdr
      )
  (import
    (silta base)
    (silta write)
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
        (if found-pair
          found-pair
          #f)))

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


    (define-case passoc
      ((lst key value)
       (letrec ((update (lambda (l k v)
                          (cond
                              ((null? l)
                               '())
                            ((equal? (car l) k)
                             (append (plist k v) (cddr l)))
                            (else
                                (append (pfirst l)
                                  (update (cddr l) k v))))))
                (found (pref lst key)))
         (cond
             (found
              (if (equal? (plist key value) found)
                lst
                (update lst key value)))
           (else
               (append lst (plist key value))))))
      ((lst k v k2 v2)
       (passoc (passoc lst k v) k2 v2))
      ((lst k v . rest)
       (apply passoc (passoc lst k v) rest)))

    (define-case pdissoc
      ((lst key)
       (if (equal? (car lst) key)
         (cddr lst)
         (append (pfirst lst)
           (pdissoc (cddr lst) key))))
      ((lst k k2)
       (pdissoc (pdissoc lst k) k2))
      ((lst k . rest)
       (apply pdissoc (pdissoc lst k) rest)))

    (define (pmap proc lst)
      (cond
          ((null? lst) '())
        (else
            (let ((key (car lst))
                  (value (cadr lst)))
              (append (plist key (proc value))
                (pmap proc (cddr lst)))))))

    (define (pcar lst)
      (list (car lst) (cadr lst)))

    (define (pcdr lst)
      (cddr lst))

    (define (prest lst)
      (pcdr lst))

    (define (pfirst lst)
      (pcar lst))

    (define (psecond lst)
      (pcar (prest lst)))

    (define (pthird lst)
      (pcar (prest (prest lst))))

    ))
