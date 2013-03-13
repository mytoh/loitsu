(library (loitsu list)
    (export
      flatten
      reductions
      scar
      scdr
      drop*
      take*
      ensure-list
      safe-length
      cond-list)
  (import
    (rnrs)
    (only (srfi :1)
          drop
          take)
    (loitsu lamb)
    (loitsu control))


  (begin

    (define (scdr lst)
      ;; safe cdr
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

    (define (ensure-list x)
      (cond
          ((list? x) x)
        (else (list x))))

    ;; from info combinator page
    (define (safe-length lst)
      (if (list? lst)
        (length lst)
        #f))

    (define (take* lis k)
      (if (< (length lis) k)
        lis
        (take lis k)))

    (define (drop* lis k)
      (if (< (length lis) k)
        '()
        (drop lis k)))

    (define-case reductions
      ((f l)
       (if (null? l)
         (list (f))
         (reductions f (car l) (cdr l))))
      ((f init l)
       (cons init
         (if (null? l)
           '()
           (reductions f (f init (car l)) (cdr l))))))

    ;;; from gauche lib/gauche/common-macros.scm
    ;; cond-list - a syntax to construct a list
    ;;
    ;;   (cond-list clause clause2 ...)
    ;;
    ;;   clause : (test expr ...)
    ;;          | (test => proc)
    ;;          | (test @ expr ...) ;; splice
    ;;          | (test => @ proc)  ;; splice

    (define-syntax cond-list
      (syntax-rules (=> :)
        ((_) '())
        ((_ (test) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons tmp r) r)))
        ((_ (test => proc) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons (proc tmp) r) r)))
        ((_ (test => : proc) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (append (proc tmp) r) r)))
        ((_ (test : . expr) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (append (begin . expr) r) r)))
        ((_ (test . expr) . rest)
         (let* ((tmp test)
                (r (cond-list . rest)))
           (if tmp (cons (begin . expr) r) r)))))


    ))
