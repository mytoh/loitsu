
(import
  (scheme base)
  (scheme write)
  (minikanren mk)
  (minikanren extraforms))

(define-syntax test-check
  (syntax-rules ()
    ((_ title tested-expression expected-result)
     (begin
       (cout "Testing " title nl)
       (let* ((expected expected-result)
              (produced tested-expression))
         (or (equal? expected produced)
             (errorf 'test-check
               "Failed: ~a~%Expected: ~a~%Computed: ~a~%"
               'tested-expression expected produced)))))))

(define nl (string #\newline))

(define (cout . args)
  (for-each (lambda (x)
              (if (procedure? x) (x) (display x)))
            args))

(define errorf
  (lambda (tag . args)
    (display "Failed: ") (display tag) (newline)
    (for-each  display args)
    (error 'WiljaCodeTester "That's all, folks!")))

; (define-syntax test-divergence
;   (syntax-rules ()
;     ((_ title tested-expression)
;      (let ((max-ticks 10000000))
;        (cout "Testing " title " (engine with " max-ticks " ticks fuel)" nl)
;        ((make-engine (lambda () tested-expression))
;         max-ticks
;         (lambda (t v)
;           (errorf title
;             "infinite loop returned " v " after " (- max-ticks t) " ticks"))
;         (lambda (e^) (void)))))))

;;; Comment out this definition to test divergent code (Chez Scheme only)
(define-syntax test-divergence
  (syntax-rules ()
    ((_ title tested-expression) (cout "Ignoring divergent test " title nl))))


(test-check "1.10"
  (run* (q)
    fail)
  `())

(test-check "1.11"
  (run* (q)
    (== #t q))
  `(#t))

(test-check "1.12"
  (run* (q)
    fail
    (== #t q))
  `())

(define g fail)

(test-check "1.13"
  (run* (q)
    succeed
    (== #t q))
  (list #t))

(test-check "1.14"
  (run* (q)
    succeed
    (== #t q))
  `(#t))

(test-check "1.15"
  (run* (r)
    succeed
    (== 'corn r))
  (list 'corn))

(test-check "1.16"
  (run* (r)
    succeed
    (== 'corn r))
  `(corn))

(test-check "1.17"
  (run* (r)
    fail
    (== 'corn r))
  `())

(test-check "1.18"
  (run* (q)
    succeed
    (== #f q))
  `(#f))

(test-check "1.22"
  (run* (x)
    (let ((x #f))
      (== #t x)))
  '())

(test-check "1.23"
  (run* (q)
    (fresh (x)
      (== #t x)
      (== #t q)))
  (list #t))

(test-check "1.26"
  (run* (q)
    (fresh (x)
      (== x #t)
      (== #t q)))
  (list #t))

(test-check "1.27"
  (run* (q)
    (fresh (x)
      (== x #t)
      (== q #t)))
  (list #t))

(test-check "1.28"
  (run* (x)
    succeed)
  (list `_.0))

(test-check "1.29"
  (run* (x)
    (let ((x #f))
      (fresh (x)
        (== #t x))))
  `(_.0))

(test-check "1.30"
  (run* (r)
    (fresh (x y)
      (== (cons x (cons y '())) r)))
  (list `(_.0 _.1)))

(test-check "1.31"
  (run* (s)
    (fresh (t u)
      (== (cons t (cons u '())) s)))
  (list `(_.0 _.1)))

(test-check "1.32"
  (run* (r)
    (fresh (x)
      (let ((y x))
        (fresh (x)
          (== (cons y (cons x (cons y '()))) r)))))
  (list `(_.0 _.1 _.0)))


(test-check "1.33"
  (run* (r)
    (fresh (x)
      (let ((y x))
        (fresh (x)
          (== (cons x (cons y (cons x '()))) r)))))
  (list `(_.0 _.1 _.0)))

(test-check "1.34"
  (run* (q)
    (== #f q)
    (== #t q))
  `())

(test-check "1.35"
  (run* (q)
    (== #f q)
    (== #f q))
  '(#f))

(test-check "1.36"
  (run* (q)
    (let ((x q))
      (== #t x)))
  (list #t))

(test-check "1.37"
  (run* (r)
    (fresh (x)
      (== x r)))
  (list `_.0))

(test-check "1.38"
  (run* (q)
    (fresh (x)
      (== #t x)
      (== x q)))
  (list #t))

(test-check "1.39"
  (run* (q)
    (fresh (x)
      (== x q)
      (== #t x)))
  (list #t))

(test-check "1.40.1"
  (run* (q)
    (fresh (x)
      (== (eq? x q) q)))
  (list #f))

(test-check "1.40.2"
  (run* (q)
    (let ((x q))
      (fresh (q)
        (== (eq? x q) x))))
  (list #f))

(test-check "1.41"
  (cond
    (#f #t)
    (else #f))
  #f)

(test-check "1.43"
  (cond
    (#f succeed)
    (else fail))
  fail)

(test-check "1.44"
  (run* (q)
    (conde
      (fail succeed)
      (else fail)))
  '())

(test-check "1.45"
  (not (null? (run* (q)
                (conde
                  (fail fail)
                  (else succeed)))))
  #t)

(test-check "1.46"
  (not (null? (run* (q)
                (conde
                  (succeed succeed)
                  (else fail)))))
  #t)


(test-check "1.47"
  (run* (x)
    (conde
      ((== 'olive x) succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(olive oil))

(test-check "1.49"
  (run 1 (x)
    (conde
      ((== 'olive x) succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(olive))

(test-check "1.50.1"
  (run* (x)
    (conde
      ((== 'virgin x) fail)
      ((== 'olive x) succeed)
      (succeed succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(olive _.0 oil))

(test-check "1.50.2"
  (run* (x)
    (conde
      ((== 'olive x) succeed)
      (succeed succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(olive _.0 oil))

(test-check "1.52"
  (run 2 (x)
    (conde
      ((== 'extra x) succeed)
      ((== 'virgin x) fail)
      ((== 'olive x) succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(extra olive))

(test-check "1.53"
  (run* (r)
    (fresh (x y)
      (== 'split x)
      (== 'pea y)
      (== (cons x (cons y '())) r)))
  (list `(split pea)))

(test-check "1.54"
  (run* (r)
    (fresh (x y)
      (conde
        ((== 'split x) (== 'pea y))
        ((== 'navy x) (== 'bean y))
        (else fail))
      (== (cons x (cons y '())) r)))
  `((split pea) (navy bean)))

(test-check "1.55"
  (run* (r)
    (fresh (x y)
      (conde
        ((== 'split x) (== 'pea y))
        ((== 'navy x) (== 'bean y))
        (else fail))
      (== (cons x (cons y (cons 'soup '()))) r)))
  `((split pea soup) (navy bean soup)))

; 1.56
(define teacupo
  (lambda (x)
    (conde
      ((== 'tea x) succeed)
      ((== 'cup x) succeed)
      (else fail))))

(test-check "1.56"
  (run* (x)
    (teacupo x))
  `(tea cup))

(test-check "1.57"
  (run* (r)
    (fresh (x y)
      (conde
        ((teacupo x) (== #t y) succeed)
        ((== #f x) (== #t y))
        (else fail))
      (== (cons x (cons y '())) r)))
  `((tea #t) (cup #t) (#f #t)))

(test-check "1.58"
  (run* (r)
    (fresh (x y z)
      (conde
        ((== y x) (fresh (x) (== z x)))
        ((fresh (x) (== y x)) (== z x))
        (else fail))
      (== (cons y (cons z '())) r)))
  `((_.0 _.1) (_.0 _.1)))

(test-check "1.59"
  (run* (r)
    (fresh (x y z)
      (conde
        ((== y x) (fresh (x) (== z x)))
        ((fresh (x) (== y x)) (== z x))
        (else fail))
      (== #f x)
      (== (cons y (cons z '())) r)))
  `((#f _.0) (_.0 #f)))

(test-check "1.60"
  (run* (q)
    (let ((a (== #t q))
          (b (== #f q)))
      b))
  '(#f))

(test-check "1.61"
  (run* (q)
    (let ((a (== #t q))
          (b (fresh (x)
               (== x q)
               (== #f x)))
          (c (conde
               ((== #t q) succeed)
               (else (== #f q)))))
      b))
  '(#f))

(test-check "2.1"
  (let ((x (lambda (a) a))
        (y 'c))
    (x y))
  'c)

(test-check "2.2"
  (run* (r)
    (fresh (y x)
      (== `(,x ,y) r)))
  (list `(_.0 _.1)))

(test-check "2.3"
  (run* (r)
    (fresh (v w)
      (== (let ((x v) (y w)) `(,x ,y)) r)))
  `((_.0 _.1)))

(test-check "2.4"
  (car `(grape raisin pear))
  `grape)

(test-check "2.5"
  (car `(a c o r n))
  'a)

; 2.9
(define caro
  (lambda (p a)
    (fresh (d)
      (== (cons a d) p))))

(test-check "2.6"
  (run* (r)
    (caro `(a c o r n) r))
  (list 'a))

(test-check "2.7"
  (run* (q)
    (caro `(a c o r n) 'a)
    (== #t q))
  (list #t))

(test-check "2.8"
  (run* (r)
    (fresh (x y)
      (caro `(,r ,y) x)
      (== 'pear x)))
  (list 'pear))

(test-check "2.10"
  (cons
    (car `(grape raisin pear))
    (car `((a) (b) (c))))
  `(grape a))

(test-check "2.11"
  (run* (r)
    (fresh (x y)
      (caro `(grape raisin pear) x)
      (caro `((a) (b) (c)) y)
      (== (cons x y) r)))
  (list `(grape a)))

(test-check "2.13"
  (cdr `(grape raisin pear))
  `(raisin pear))

(test-check "2.14"
  (car (cdr `(a c o r n)))
  'c)

; 2.16
(define cdro
  (lambda (p d)
    (fresh (a)
      (== (cons a d) p))))

(test-check "2.15"
  (run* (r)
    (fresh (v)
      (cdro `(a c o r n) v)
      (caro v r)))
  (list 'c))

(test-check "2.17"
  (cons
    (cdr `(grape raisin pear))
    (car `((a) (b) (c))))
  `((raisin pear) a))

(test-check "2.18"
  (run* (r)
    (fresh (x y)
      (cdro `(grape raisin pear) x)
      (caro `((a) (b) (c)) y)
      (== (cons x y) r)))
  (list `((raisin pear) a)))

(test-check "2.19.1"
  (run* (q)
    (cdro '(a c o r n) '(c o r n))
    (== #t q))
  (list #t))

(test-check "2.19.2"
  `(c o r n)
  (cdr '(a c o r n)))

(test-check "2.20.1"
  (run* (x)
    (cdro '(c o r n) `(,x r n)))
  (list 'o))

(test-check "2.20.2"
  `(o r n)
  (cdr `(c o r n)))

(test-check "2.21"
  (run* (l)
    (fresh (x)
      (cdro l '(c o r n))
      (caro l x)
      (== 'a x)))
  (list `(a c o r n)))

; 2.28
(define conso
  (lambda (a d p)
    (== (cons a d) p)))

(test-check "2.22"
  (run* (l)
    (conso '(a b c) '(d e) l))
  (list `((a b c) d e)))

(test-check "2.23.1"
  (run* (x)
    (conso x '(a b c) '(d a b c)))
  (list 'd))

(test-check "2.23.2"
  (cons 'd '(a b c))
  `(d a b c))

(test-check "2.24"
  (run* (r)
    (fresh (x y z)
      (== `(e a d ,x) r)
      (conso y `(a ,z c) r)))
  (list `(e a d c)))

(test-check "2.25.1"
  (run* (x)
    (conso x `(a ,x c) `(d a ,x c)))
  (list 'd))

(define x1 'd)

(test-check "2.25.2"
  (cons x1 `(a ,x1 c))
  `(d a ,x1 c))

(test-check "2.26"
  (run* (l)
    (fresh (x)
      (== `(d a ,x c) l)
      (conso x `(a ,x c) l)))
  (list `(d a d c)))

(test-check "2.27"
  (run* (l)
    (fresh (x)
      (conso x `(a ,x c) l)
      (== `(d a ,x c) l)))
  (list `(d a d c)))

(test-check "2.29"
  (run* (l)
    (fresh (d x y w s)
      (conso w '(a n s) s)
      (cdro l s)
      (caro l x)
      (== 'b x)
      (cdro l d)
      (caro d y)
      (== 'e y)))
  (list `(b e a n s)))

(test-check "2.30"
  (null? `(grape raisin pear))
  #f)

(test-check "2.31"
  (null? '())
  #t)

; 2.35
(define nullo
  (lambda (x)
    (== '() x)))

(test-check "2.32"
  (run* (q)
    (nullo `(grape raisin pear))
    (== #t q))
  `())

(test-check "2.33"
  (run* (q)
    (nullo '())
    (== #t q))
  `(#t))

(test-check "2.34"
  (run* (x)
    (nullo x))
  `(()))

(test-check "2.36"
  (eq? 'pear 'plum)
  #f)

(test-check "2.37"
  (eq? 'plum 'plum)
  #t)

; 2.40
(define eqo
  (lambda (x y)
    (== x y)))

(test-check "2.38"
  (run* (q)
    (eqo 'pear 'plum)
    (== #t q))
  `())

(test-check "2.39"
  (run* (q)
    (eqo 'plum 'plum)
    (== #t q))
  `(#t))

(test-check "2.43"
  (pair? `((split) . pea))
  #t)

(test-check "2.44"
  (pair? '())
  #f)

(test-check "2.48"
  (car `(pear))
  `pear)

(test-check "2.49"
  (cdr `(pear))
  `())

(test-check "2.51"
  (cons `(split) 'pea)
  `((split) . pea))

(test-check "2.52"
  (run* (r)
    (fresh (x y)
      (== (cons x (cons y 'salad)) r)))
  (list `(_.0 _.1 . salad)))

; 2.53
(define pairo
  (lambda (p)
    (fresh (a d)
      (conso a d p))))

(test-check "2.54"
  (run* (q)
    (pairo (cons q q))
    (== #t q))
  `(#t))

(test-check "2.55"
  (run* (q)
    (pairo '())
    (== #t q))
  `())

(test-check "2.56"
  (run* (q)
    (pairo 'pair)
    (== #t q))
  `())

(test-check "2.57"
  (run* (x)
    (pairo x))
  (list `(_.0 . _.1)))

(test-check "2.58"
  (run* (r)
    (pairo (cons r 'pear)))
  (list `_.0))

; 3.1.1
'(define list?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((pair? l) (list? (cdr l)))
      (else #f))))

(test-check "3.1.1"
  (list? `((a) (a b) c))
  #t)

(test-check "3.2"
  (list? `())
  #t)

(test-check "3.3"
  (list? 's)
  #f)

(test-check "3.4"
  (list? `(d a t e . s))
  #f)

; 3.5
(define listo
  (lambda (l)
    (conde
      ((nullo l) succeed)
      ((pairo l)
       (fresh (d)
         (cdro l d)
         (listo d)))
      (else fail))))

(test-check "3.7"
  (run* (x)
    (listo `(a b ,x d)))
  (list `_.0))

(test-check "3.10"
  (run 1 (x)
    (listo `(a b c . ,x)))
  (list `()))

(test-divergence "3.13"
  (run* (x)
    (listo `(a b c . ,x))))

(test-check "3.14"
  (run 5 (x)
    (listo `(a b c . ,x)))
  `(()
    (_.0)
    (_.0 _.1)
    (_.0 _.1 _.2)
    (_.0 _.1 _.2 _.3)))

; 3.16
(define lol?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((list? (car l)) (lol? (cdr l)))
      (else #f))))

; 3.17
(define lolo
  (lambda (l)
    (conde
      ((nullo l) succeed)
      ((fresh (a)
         (caro l a)
         (listo a))
       (fresh (d)
         (cdro l d)
         (lolo d)))
      (else fail))))

(test-check "3.20"
  (run 1 (l)
    (lolo l))
  `(()))

(test-check "3.21"
  (run* (q)
    (fresh (x y)
      (lolo `((a b) (,x c) (d ,y)))
      (== #t q)))
  (list #t))

(test-check "3.22"
  (run 1 (q)
    (fresh (x)
      (lolo `((a b) . ,x))
      (== #t q)))
  (list #t))

(test-check "3.23"
  (run 1 (x)
    (lolo `((a b) (c d) . ,x)))
  `(()))

(test-check "3.24"
  (run 5 (x)
    (lolo `((a b) (c d) . ,x)))
  `(()
    (())
    (() ())
    (() () ())
    (() () () ())))

; 3.31
(define twinso1
  (lambda (s)
    (fresh (x y)
      (conso x y s)
      (conso x '() y))))

(test-check "3.32"
  (run* (q)
    (twinso1 '(tofu tofu))
    (== #t q))
  (list #t))

(test-check "3.33"
  (run* (z)
    (twinso1 `(,z tofu)))
  (list `tofu))

; 3.36
(define twinso
  (lambda (s)
    (fresh (x)
      (== `(,x ,x) s))))

; 3.37
(define loto
  (lambda (l)
    (conde
      ((nullo l) succeed)
      ((fresh (a)
         (caro l a)
         (twinso a))
       (fresh (d)
         (cdro l d)
         (loto d)))
      (else fail))))

(test-check "3.38"
  (run 1 (z)
    (loto `((g g) . ,z)))
  (list `()))

(test-check "3.42"
  (run 5 (z)
    (loto `((g g) . ,z)))
  '(()
    ((_.0 _.0))
    ((_.0 _.0) (_.1 _.1))
    ((_.0 _.0) (_.1 _.1) (_.2 _.2))
    ((_.0 _.0) (_.1 _.1) (_.2 _.2) (_.3 _.3))))

(test-check "3.45"
  (run 5 (r)
    (fresh (w x y z)
      (loto `((g g) (e ,w) (,x ,y) . ,z))
      (== `(,w (,x ,y) ,z) r)))
  '((e (_.0 _.0) ())
    (e (_.0 _.0) ((_.1 _.1)))
    (e (_.0 _.0) ((_.1 _.1) (_.2 _.2)))
    (e (_.0 _.0) ((_.1 _.1) (_.2 _.2) (_.3 _.3)))
    (e (_.0 _.0) ((_.1 _.1) (_.2 _.2) (_.3 _.3) (_.4 _.4)))))

(test-check "3.47"
  (run 3 (out)
    (fresh (w x y z)
      (== `((g g) (e ,w) (,x ,y) . ,z) out)
      (loto out)))
  `(((g g) (e e) (_.0 _.0))
    ((g g) (e e) (_.0 _.0) (_.1 _.1))
    ((g g) (e e) (_.0 _.0) (_.1 _.1) (_.2 _.2))))

; 3.48
(define listofo
  (lambda (predo l)
    (conde
      ((nullo l) succeed)
      ((fresh (a)
         (caro l a)
         (predo a))
       (fresh (d)
         (cdro l d)
         (listofo predo d)))
      (else fail))))

(test-check "3.49"
  (run 3 (out)
    (fresh (w x y z)
      (== `((g g) (e ,w) (,x ,y) . ,z) out)
      (listofo twinso out)))
  `(((g g) (e e) (_.0 _.0))
    ((g g) (e e) (_.0 _.0) (_.1 _.1))
    ((g g) (e e) (_.0 _.0) (_.1 _.1) (_.2 _.2))))

; 3.50
(define loto2
  (lambda (l)
    (listofo twinso l)))

; 3.51.1
(define member?
  (lambda (x l)
    (cond
      ((null? l) '())
      ((eq-car? l x) #t)
      (else (member? x (cdr l))))))

; 3.51.2
(define eq-car?
  (lambda (l x)
    (eq? (car l) x)))

; 3.53
(test-check "3-21"
  (member? 'olive `(virgin olive oil))
  #t)

; 3.54.1
(define eq-caro
  (lambda (l x)
    (caro l x)))

; 3.54.2
(define membero
  (lambda (x l)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) succeed)
      (else
        (fresh (d)
          (cdro l d)
          (membero x d))))))

(test-check "3.57"
  (run* (q)
    (membero 'olive `(virgin olive oil))
    (== #t q))
  (list #t))

(test-check "3.58"
  (run 1 (y)
    (membero y `(hummus with pita)))
  (list `hummus))

(test-check "3.59"
  (run 1 (y)
    (membero y `(with pita)))
  (list `with))

(test-check "3.60"
  (run 1 (y)
    (membero y `(pita)))
  (list `pita))

(test-check "3.61"
  (run* (y)
    (membero y `()))
  `())

(test-check "3.62"
  (run* (y)
    (membero y `(hummus with pita)))
  `(hummus with pita))

; 3.65
(define identity
  (lambda (l)
    (run* (y)
      (membero y l))))

(test-check "3.66"
  (run* (x)
    (membero 'e `(pasta ,x fagioli)))
  (list `e))

(test-check "3.69"
  (run 1 (x)
    (membero 'e `(pasta e ,x fagioli)))
  (list `_.0))

(test-check "3.70"
  (run 1 (x)
    (membero 'e `(pasta ,x e fagioli)))
  (list `e))

(test-check "3.71"
  (run* (r)
    (fresh (x y)
      (membero 'e `(pasta ,x fagioli ,y))
      (== `(,x ,y) r)))
  `((e _.0) (_.0 e)))

(test-check "3.73"
  (run 1 (l)
    (membero 'tofu l))
  `((tofu . _.0)))

(test-divergence "3.75"
  (run* (l)
    (membero 'tofu l)))

(test-check "3.76"
  (run 5 (l)
    (membero 'tofu l))
  `((tofu . _.0)
    (_.0 tofu . _.1)
    (_.0 _.1 tofu . _.2)
    (_.0 _.1 _.2 tofu . _.3)
    (_.0 _.1 _.2 _.3 tofu . _.4)))

; 3.80.1
(define pmembero
  (lambda (x l)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) (cdro l '()))
      (else
        (fresh (d)
          (cdro l d)
          (pmembero x d))))))

(test-check "3.80.2"
  (run 5 (l)
    (pmembero 'tofu l))
  `((tofu)
    (_.0 tofu)
    (_.0 _.1 tofu)
    (_.0 _.1 _.2 tofu)
    (_.0 _.1 _.2 _.3 tofu)))

(test-check "3.81"
  (run* (q)
    (pmembero 'tofu `(a b tofu d tofu))
    (== #t q))
  `(#t))

; 3.83
(define pmembero1
  (lambda (x l)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) (cdro l '()))
      ((eq-caro l x) succeed)
      (else
        (fresh (d)
          (cdro l d)
          (pmembero1 x d))))))

(test-check "3.84"
  (run* (q)
    (pmembero1 'tofu `(a b tofu d tofu))
    (== #t q))
  `(#t #t #t))

; 3.86
(define pmembero2
  (lambda (x l)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) (cdro l '()))
      ((eq-caro l x)
       (fresh (a d)
         (cdro l `(,a . ,d))))
      (else
        (fresh (d)
          (cdro l d)
          (pmembero2 x d))))))

(test-check "3.88"
  (run* (q)
    (pmembero2 'tofu `(a b tofu d tofu))
    (== #t q))
  `(#t #t))

(test-check "3.89"
  (run 12 (l)
    (pmembero2 'tofu l))
  `((tofu)
    (tofu _.0 . _.1)
    (_.0 tofu)
    (_.0 tofu _.1 . _.2)
    (_.0 _.1 tofu)
    (_.0 _.1 tofu _.2 . _.3)
    (_.0 _.1 _.2 tofu)
    (_.0 _.1 _.2 tofu _.3 . _.4)
    (_.0 _.1 _.2 _.3 tofu)
    (_.0 _.1 _.2 _.3 tofu _.4 . _.5)
    (_.0 _.1 _.2 _.3 _.4 tofu)
    (_.0 _.1 _.2 _.3 _.4 tofu _.5 . _.6)))

; 3.93
(define pmembero3
  (lambda (x l)
    (conde
      ((eq-caro l x)
       (fresh (a d)
         (cdro l `(,a . ,d))))
      ((eq-caro l x) (cdro l '()))
      (else
        (fresh (d)
          (cdro l d)
          (pmembero3 x d))))))

(test-check "3.94"
  (run 12 (l)
    (pmembero3 'tofu l))
  `((tofu _.0 . _.1)
    (tofu)
    (_.0 tofu _.1 . _.2)
    (_.0 tofu)
    (_.0 _.1 tofu _.2 . _.3)
    (_.0 _.1 tofu)
    (_.0 _.1 _.2 tofu _.3 . _.4)
    (_.0 _.1 _.2 tofu)
    (_.0 _.1 _.2 _.3 tofu _.4 . _.5)
    (_.0 _.1 _.2 _.3 tofu)
    (_.0 _.1 _.2 _.3 _.4 tofu _.5 . _.6)
    (_.0 _.1 _.2 _.3 _.4 tofu)))

; 3.95
(define first-value
  (lambda (l)
    (run 1 (y)
      (membero y l))))

(test-check "3.96"
  (first-value `(pasta e fagioli))
  `(pasta))

(test-check "3.97"
  (first-value `(pasta e fagioli))
  (list `pasta))

; 3.98
(define memberrevo
  (lambda (x l)
    (conde
      ((nullo l) fail)
      (succeed
        (fresh (d)
          (cdro l d)
          (memberrevo x d)))
      (else (eq-caro l x)))))

(test-check "3.100"
  (run* (x)
    (memberrevo x `(pasta e fagioli)))
  `(fagioli e pasta))

; 3.101
(define reverse-list
  (lambda (l)
    (run* (y)
      (memberrevo y l))))

; 4.1.1
(define mem
  (lambda (x l)
    (cond
      ((null? l) #f)
      ((eq-car? l x) l)
      (else (mem x (cdr l))))))

(test-check "4.1.2"
  (mem 'tofu `(a b tofu d peas e))
  `(tofu d peas e))

(test-check "4.2"
  (mem 'tofu `(a b peas d peas e))
  #f)

(test-check "4.3"
  (run* (out)
    (== (mem 'tofu `(a b tofu d peas e)) out))
  (list `(tofu d peas e)))

(test-check "4.4"
  (mem 'peas (mem 'tofu `(a b tofu d peas e)))
  `(peas e))

(test-check "4.5"
  (mem 'tofu (mem 'tofu `(a b tofu d tofu e)))
  `(tofu d tofu e))

(test-check "4.6"
  (mem 'tofu (cdr (mem 'tofu `(a b tofu d tofu e))))
  `(tofu e))

; 4.7
(define memo
  (lambda (x l out)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) (== l out))
      (else
        (fresh (d)
          (cdro l d)
          (memo x d out))))))

(test-check "4.10"
  (run 1 (out)
    (memo 'tofu `(a b tofu d tofu e) out))
  `((tofu d tofu e)))

(test-check "4.11"
  (run 1 (out)
    (fresh (x)
      (memo 'tofu `(a b ,x d tofu e) out)))
  `((tofu d tofu e)))

(test-check "4.12"
  (run* (r)
    (memo r `(a b tofu d tofu e) `(tofu d tofu e)))
  (list `tofu))

(test-check "4.13"
  (run* (q)
    (memo 'tofu '(tofu e) '(tofu e))
    (== #t q))
  (list #t))

(test-check "4.14"
  (run* (q)
    (memo 'tofu '(tofu e) '(tofu))
    (== #t q))
  `())

(test-check "4.15"
  (run* (x)
    (memo 'tofu '(tofu e) `(,x e)))
  (list `tofu))

(test-check "4.16"
  (run* (x)
    (memo 'tofu '(tofu e) `(peas ,x)))
  `())

(test-check "4.17"
  (run* (out)
    (fresh (x)
      (memo 'tofu `(a b ,x d tofu e) out)))
  `((tofu d tofu e) (tofu e)))

(test-check "4.18"
  (run 12 (z)
    (fresh (u)
      (memo 'tofu `(a b tofu d tofu e . ,z) u)))
  `(_.0
    _.0
    (tofu . _.0)
    (_.0 tofu . _.1)
    (_.0 _.1 tofu . _.2)
    (_.0 _.1 _.2 tofu . _.3)
    (_.0 _.1 _.2 _.3 tofu . _.4)
    (_.0 _.1 _.2 _.3 _.4 tofu . _.5)
    (_.0 _.1 _.2 _.3 _.4 _.5 tofu . _.6)
    (_.0 _.1 _.2 _.3 _.4 _.5 _.6 tofu . _.7)
    (_.0 _.1 _.2 _.3 _.4 _.5 _.6 _.7 tofu . _.8)
    (_.0 _.1 _.2 _.3 _.4 _.5 _.6 _.7 _.8 tofu . _.9)))

; 4.21
(define memo1
  (lambda (x l out)
    (conde
      ((eq-caro l x) (== l out))
      (else
        (fresh (d)
          (cdro l d)
          (memo1 x d out))))))

; 4.22
(define rember
  (lambda (x l)
    (cond
      ((null? l) '())
      ((eq-car? l x) (cdr l))
      (else
        (cons (car l)
          (rember x (cdr l)))))))

(test-check "4.23"
  (rember 'peas '(a b peas d peas e))
  `(a b d peas e))

; 4.24
(define rembero
  (lambda (x l out)
    (conde
      ((nullo l) (== '() out))
      ((eq-caro l x) (cdro l out))
      (else
        (fresh (res)
          (fresh (d)
            (cdro l d)
            (rembero x d res))
          (fresh (a)
            (caro l a)
            (conso a res out)))))))

; 4.27
(define rembero1
  (lambda (x l out)
    (conde
      ((nullo l) (== '() out))
      ((eq-caro l x) (cdro l out))
      (else (fresh (a d res)
              (conso a d l)
              (rembero1 x d res)
              (conso a res out))))))

(test-check "4.30"
  (run 1 (out)
    (fresh (y)
      (rembero1 'peas `(a b ,y d peas e) out)))
  `((a b d peas e)))

(test-check "4.31"
  (run* (out)
    (fresh (y z)
      (rembero1 y `(a b ,y d ,z e) out)))
  `((b a d _.0 e)
    (a b d _.0 e)
    (a b d _.0 e)
    (a b d _.0 e)
    (a b _.0 d e)
    (a b e d _.0)
    (a b _.0 d _.1 e)))

(test-check "4.49"
  (run* (r)
    (fresh (y z)
      (rembero1 y `(,y d ,z e) `(,y d e))
      (== `(,y ,z) r)))
  `((d d)
    (d d)
    (_.0 _.0)
    (e e)))

(test-check "4.57"
  (run 13 (w)
    (fresh (y z out)
      (rembero1 y `(a b ,y d ,z . ,w) out)))
  `(_.0
    _.0
    _.0
    _.0
    _.0
    ()
    (_.0 . _.1)
    (_.0)
    (_.0 _.1 . _.2)
    (_.0 _.1)
    (_.0 _.1 _.2 . _.3)
    (_.0 _.1 _.2)
    (_.0 _.1 _.2 _.3 . _.4)))

; 4.68
(define surpriseo
  (lambda (s)
    (rembero1 s '(a b c) '(a b c))))

(test-check "4.69"
  (run* (r)
    (== 'd r)
    (surpriseo r))
  (list 'd))

(test-check "4.70"
  (run* (r)
    (surpriseo r))
  `(_.0))

(test-check "4.72"
  (run* (r)
    (== 'b r)
    (surpriseo r))
  `(b))

; 5.2.1
'(define append
  (lambda (l s)
    (cond
      ((null? l) s)
      (else (cons (car l)
              (append (cdr l) s))))))

(test-check "5.2.2"
  (append `(a b c) `(d e))
  `(a b c d e))

(test-check "5.3"
  (append '(a b c) '())
  `(a b c))

(test-check "5.4"
  (append '() '(d e))
  `(d e))

(test-check "5.6"
  (append '(d e) 'a)
  `(d e . a))

; 5.9
(define appendo
  (lambda (l s out)
    (conde
      ((nullo l) (== s out))
      (else
        (fresh (a d res)
          (caro l a)
          (cdro l d)
          (appendo d s res)
          (conso a res out))))))

(test-check "5.10"
  (run* (x)
    (appendo
     '(cake)
     '(tastes yummy)
     x))
  (list `(cake tastes yummy)))

(test-check "5.11"
  (run* (x)
    (fresh (y)
      (appendo
       `(cake with ice ,y)
       '(tastes yummy)
       x)))
  (list `(cake with ice _.0 tastes yummy)))

(test-check "5.12"
  (run* (x)
    (fresh (y)
      (appendo
       '(cake with ice cream)
       y
       x)))
  (list `(cake with ice cream . _.0)))

(test-check "5.13"
  (run 1 (x)
    (fresh (y)
      (appendo `(cake with ice . ,y) '(d t) x)))
  (list `(cake with ice d t)))

(test-check "5.14"
  (run 1 (y)
    (fresh (x)
      (appendo `(cake with ice . ,y) '(d t) x)))
  (list '()))

; 5.15
(define appendo1
  (lambda (l s out)
    (conde
      ((nullo l) (== s out))
      (else
        (fresh (a d res)
          (conso a d l)
          (appendo1 d s res)
          (conso a res out))))))

(test-check "5.16"
  (run 5 (x)
    (fresh (y)
      (appendo1 `(cake with ice . ,y) '(d t) x)))
  `((cake with ice d t)
    (cake with ice _.0 d t)
    (cake with ice _.0 _.1 d t)
    (cake with ice _.0 _.1 _.2 d t)
    (cake with ice _.0 _.1 _.2 _.3 d t)))

(test-check "5.17"
  (run 5 (y)
    (fresh (x)
      (appendo1 `(cake with ice . ,y) '(d t) x)))
  `(()
    (_.0)
    (_.0 _.1)
    (_.0 _.1 _.2)
    (_.0 _.1 _.2 _.3)))

(define y1 `(_.0 _.1 _.2))

(test-check "5.18"
  `(cake with ice . ,y1)
  `(cake with ice . (_.0 _.1 _.2)))

(test-check "5.20"
  (run 5 (x)
    (fresh (y)
      (appendo1
       `(cake with ice . ,y)
       `(d t . ,y)
       x)))
  `((cake with ice d t)
    (cake with ice _.0 d t _.0)
    (cake with ice _.0 _.1 d t _.0 _.1)
    (cake with ice _.0 _.1 _.2 d t _.0 _.1 _.2)
    (cake with ice _.0 _.1 _.2 _.3 d t _.0 _.1 _.2 _.3)))

(test-check "5.21"
  (run* (x)
    (fresh (z)
      (appendo1
       `(cake with ice cream)
       `(d t . ,z)
       x)))
  `((cake with ice cream d t . _.0)))

(test-check "5.23"
  (run 6 (x)
    (fresh (y)
      (appendo1 x y `(cake with ice d t))))
  `(()
    (cake)
    (cake with)
    (cake with ice)
    (cake with ice d)
    (cake with ice d t)))

(test-check "5.25"
  (run 6 (y)
    (fresh (x)
      (appendo1 x y `(cake with ice d t))))
  `((cake with ice d t)
    (with ice d t)
    (ice d t)
    (d t)
    (t)
    ()))

; 5.26.1
(define appendxyquestion
  (lambda ()
    (run 6 (r)
      (fresh (x y)
        (appendo1 x y `(cake with ice d t))
        (== `(,x ,y) r)))))

; 5.26.2
(define appendxyanswer
  `((() (cake with ice d t))
    ((cake) (with ice d t))
    ((cake with) (ice d t))
    ((cake with ice) (d t))
    ((cake with ice d) (t))
    ((cake with ice d t) ())))

(test-check "appendxy"
  (appendxyquestion)
  appendxyanswer)

(test-divergence "5.29"
  (run 7 (r)
    (fresh (x y)
      (appendo1 x y `(cake with ice d t))
      (== `(,x ,y) r))))

; 5.31
(define appendo2
  (lambda (l s out)
    (conde
      ((nullo l) (== s out))
      (else
        (fresh (a d res)
          (conso a d l)
          (conso a res out)
          (appendo2 d s res))))))

(test-check "5.32"
  (run 7 (r)
    (fresh (x y)
      (appendo2 x y `(cake with ice d t))
      (== `(,x ,y) r)))
  appendxyanswer)

(test-check "5.33"
  (run 7 (x)
    (fresh (y z)
      (appendo2 x y z)))
  `(()
    (_.0)
    (_.0 _.1)
    (_.0 _.1 _.2)
    (_.0 _.1 _.2 _.3)
    (_.0 _.1 _.2 _.3 _.4)
    (_.0 _.1 _.2 _.3 _.4 _.5)))

(test-check "5.34"
  (run 7 (y)
    (fresh (x z)
      (appendo2 x y z)))
  `(_.0
    _.0
    _.0
    _.0
    _.0
    _.0
    _.0))

(test-check "5.36"
  (run 7 (z)
    (fresh (x y)
      (appendo2 x y z)))
  `(_.0
    (_.0 . _.1)
    (_.0 _.1 . _.2)
    (_.0 _.1 _.2 . _.3)
    (_.0 _.1 _.2 _.3 . _.4)
    (_.0 _.1 _.2 _.3 _.4 . _.5)
    (_.0 _.1 _.2 _.3 _.4 _.5 . _.6)))

(test-check "5.37"
  (run 7 (r)
    (fresh (x y z)
      (appendo2 x y z)
      (== `(,x ,y ,z) r)))
  `((() _.0 _.0)
    ((_.0) _.1 (_.0 . _.1))
    ((_.0 _.1) _.2 (_.0 _.1 . _.2))
    ((_.0 _.1 _.2) _.3 (_.0 _.1 _.2 . _.3))
    ((_.0 _.1 _.2 _.3) _.4 (_.0 _.1 _.2 _.3 . _.4))
    ((_.0 _.1 _.2 _.3 _.4) _.5 (_.0 _.1 _.2 _.3 _.4 . _.5))
    ((_.0 _.1 _.2 _.3 _.4 _.5) _.6 (_.0 _.1 _.2 _.3 _.4 _.5 . _.6))))

; 5.38
(define swappendo
  (lambda (l s out)
    (conde
      (succeed
        (fresh (a d res)
          (conso a d l)
          (conso a res out)
          (swappendo d s res)))
      (else (nullo l) (== s out)))))

(test-divergence "5.39"
  (run 1 (z)
    (fresh (x y)
      (swappendo x y z))))

; 5.41.1
(define unwrap
  (lambda (x)
    (cond
      ((pair? x) (unwrap (car x)))
      (else x))))

(test-check "5.41.2"
  (unwrap '((((pizza)))))
  `pizza)

(test-check "5.42"
  (unwrap '((((pizza pie) with)) extra cheese))
  `pizza)

; 5.45
(define unwrapo
  (lambda (x out)
    (conde
      ((pairo x)
       (fresh (a)
         (caro x a)
         (unwrapo a out)))
      (else (== x out)))))

(test-check "5.46"
  (run* (x)
    (unwrapo '(((pizza))) x))
  `(pizza
    (pizza)
    ((pizza))
    (((pizza)))))

(test-divergence "5.48"
  (run 1 (x)
    (unwrapo x 'pizza)))

(test-divergence "5.49"
  (run 1 (x)
    (unwrapo `((,x)) 'pizza)))

; 5.52
(define unwrapo1
  (lambda (x out)
    (conde
      (succeed (== x out))
      (else
        (fresh (a)
          (caro x a)
          (unwrapo1 a out))))))

(test-check "5.53"
  (run 5 (x)
    (unwrapo1 x 'pizza))
  `(pizza
    (pizza . _.0)
    ((pizza . _.0) . _.1)
    (((pizza . _.0) . _.1) . _.2)
    ((((pizza . _.0) . _.1) . _.2) . _.3)))

(test-check "5.54"
  (run 5 (x)
    (unwrapo1 x '((pizza))))
  `(((pizza))
    (((pizza)) . _.0)
    ((((pizza)) . _.0) . _.1)
    (((((pizza)) . _.0) . _.1) . _.2)
    ((((((pizza)) . _.0) . _.1) . _.2) . _.3)))

(test-check "5.55"
  (run 5 (x)
    (unwrapo1 `((,x)) 'pizza))
  `(pizza
    (pizza . _.0)
    ((pizza . _.0) . _.1)
    (((pizza . _.0) . _.1) . _.2)
    ((((pizza . _.0) . _.1) . _.2) . _.3)))

; 5.58.1
(define flatten
  (lambda (s)
    (cond
      ((null? s) '())
      ((pair? s)
       (append
         (flatten (car s))
         (flatten (cdr s))))
      (else (cons s '())))))

(test-check "5.58.1"
  (flatten '((a b) c))
  `(a b c))

; 5.59
(define flatteno
  (lambda (s out)
    (conde
      ((nullo s) (== '() out))
      ((pairo s)
       (fresh (a d res-a res-d)
         (conso a d s)
         (flatteno a res-a)
         (flatteno d res-d)
         (appendo res-a res-d out)))
      (else (conso s '() out)))))

(test-check "5.60"
  (run 1 (x)
    (flatteno '((a b) c) x))
  (list `(a b c)))

(test-check "5.61"
  (run 1 (x)
    (flatteno '(a (b c)) x))
  (list `(a b c)))

(test-check "5.62"
  (run* (x)
    (flatteno '(a) x))
  `((a)
    (a ())
    ((a))))

(test-check "5.64"
  (run* (x)
    (flatteno '((a)) x))
  `((a)
    (a ())
    (a ())
    (a () ())
    ((a))
    ((a) ())
    (((a)))))

(test-check "5.66"
  (run* (x)
    (flatteno '(((a))) x))
  `((a)
    (a ())
    (a ())
    (a () ())
    (a ())
    (a () ())
    (a () ())
    (a () () ())
    ((a))
    ((a) ())
    ((a) ())
    ((a) () ())
    (((a)))
    (((a)) ())
    ((((a))))))

; 5.68.1
(define flattenogrumblequestion
  (lambda ()
    (run* (x)
      (flatteno '((a b) c) x))))

; 5.68.2
(define flattenogrumbleanswer
  `((a b c)
    (a b c ())
    (a b (c))
    (a b () c)
    (a b () c ())
    (a b () (c))
    (a (b) c)
    (a (b) c ())
    (a (b) (c))
    ((a b) c)
    ((a b) c ())
    ((a b) (c))
    (((a b) c))))

(test-check "flattenogrumble"
  (flattenogrumblequestion)
  flattenogrumbleanswer)

(test-divergence "5.71"
  (run* (x)
    (flatteno x '(a b c))))

; 5.73
(define flattenrevo
  (lambda (s out)
    (conde
      (succeed (conso s '() out))
      ((nullo s) (== '() out))
      (else
        (fresh (a d res-a res-d)
          (conso a d s)
          (flattenrevo a res-a)
          (flattenrevo d res-d)
          (appendo res-a res-d out))))))

(test-check "5.75"
  (run* (x)
    (flattenrevo '((a b) c) x))
  `((((a b) c))
    ((a b) (c))
    ((a b) c ())
    ((a b) c)
    (a (b) (c))
    (a (b) c ())
    (a (b) c)
    (a b () (c))
    (a b () c ())
    (a b () c)
    (a b (c))
    (a b c ())
    (a b c)))

(test-check "5.76"
  (reverse
    (run* (x)
      (flattenrevo '((a b) c) x)))
  flattenogrumbleanswer)

(test-check "5.77"
  (run 2 (x)
    (flattenrevo x '(a b c)))
  `((a b . c)
    (a b c)))

(test-divergence "5.79"
  (run 3 (x)
    (flattenrevo x '(a b c))))

(test-check "5.80"
  (length
    (run* (x)
      (flattenrevo '((((a (((b))) c))) d) x)))
  574)

; 6.1
(define anyo
  (lambda (g)
    (conde
      (g succeed)
      (else (anyo g)))))

; 6.4
(define nevero (anyo fail))

(test-divergence "6.5"
  (run 1 (q)
    nevero
    (== #t q)))

; 6.7
(define alwayso (anyo succeed))

(test-check "6.7"
  (run 1 (q)
    alwayso
    (== #t q))
  (list #t))

(test-divergence "6.9"
  (run* (q)
    alwayso
    (== #t q)))

(test-check "6.10"
  (run 5 (q)
    alwayso
    (== #t q))
  `(#t #t #t #t #t))

(test-check "6.11"
  (run 5 (q)
    (== #t q)
    alwayso)
  `(#t #t #t #t #t))

; 6.12
(define salo
  (lambda (g)
    (conde
      (succeed succeed)
      (else g))))

(test-check "6.13"
  (run 1 (q)
    (salo alwayso)
    (== #t q))
  `(#t))

(test-check "6.14"
  (run 1 (q)
    (salo nevero)
    (== #t q))
  `(#t))

(test-divergence "6.15"
  (run* (q)
    (salo nevero)
    (== #t q)))

(test-divergence "6.16"
  (run 1 (q)
    (salo nevero)
    fail
    (== #t q)))

(test-divergence "6.17"
  (run 1 (q)
    alwayso
    fail
    (== #t q)))

(test-divergence "6.18"
  (run 1 (q)
    (conde
      ((== #f q) alwayso)
      (else (anyo (== #t q))))
    (== #t q)))

(test-check "6.19"
  (run 1 (q)
    (condi
      ((== #f q) alwayso)
      (else (== #t q)))
    (== #t q))
  `(#t))

(test-divergence "6.20"
  (run 2 (q)
    (condi
      ((== #f q) alwayso)
      (else (== #t q)))
    (== #t q)))

(test-check "6.21"
  (run 5 (q)
    (condi
      ((== #f q) alwayso)
      (else (anyo (== #t q))))
    (== #t q))
  `(#t #t #t #t #t))

(test-check "6.24"
  (run 5 (r)
    (condi
      ((teacupo r) succeed)
      ((== #f r) succeed)
      (else fail)))
  `(tea #f cup))

(test-check "6.25"
  (run 5 (q)
    (condi
      ((== #f q) alwayso)
      ((== #t q) alwayso)
      (else fail))
    (== #t q))
  `(#t #t #t #t #t))

(test-divergence "6.27"
  (run 5 (q)
    (conde
      ((== #f q) alwayso)
      ((== #t q) alwayso)
      (else fail))
    (== #t q)))

(test-check "6.28"
  (run 5 (q)
    (conde
      (alwayso succeed)
      (else nevero))
    (== #t q))
  `(#t #t #t #t #t))

(test-divergence "6.30"
  (run 5 (q)
    (condi
      (alwayso succeed)
      (else nevero))
    (== #t q)))

(test-divergence "6.31"
  (run 1 (q)
    (all
      (conde
        ((== #f q) succeed)
        (else (== #t q)))
      alwayso)
    (== #t q)))

(test-check "6.32"
  (run 1 (q)
    (alli
      (conde
        ((== #f q) succeed)
        (else (== #t q)))
      alwayso)
    (== #t q))
  `(#t))

(test-check "6.33"
  (run 5 (q)
    (alli
      (conde
        ((== #f q) succeed)
        (else (== #t q)))
      alwayso)
    (== #t q))
  `(#t #t #t #t #t))

(test-check "6.34"
  (run 5 (q)
    (alli
      (conde
        ((== #t q) succeed)
        (else (== #f q)))
      alwayso)
    (== #t q))
  `(#t #t #t #t #t))

(test-check "6.36"
  (run 5 (q)
    (all
      (conde
        (succeed succeed)
        (else nevero))
      alwayso)
    (== #t q))
  `(#t #t #t #t #t))

(test-divergence "6.38"
  (run 5 (q)
    (alli
      (conde
        (succeed succeed)
        (else nevero))
      alwayso)
    (== #t q)))

; 7.5
(define bit-xoro
  (lambda (x y r)
    (conde
      ((== 0 x) (== 0 y) (== 0 r))
      ((== 1 x) (== 0 y) (== 1 r))
      ((== 0 x) (== 1 y) (== 1 r))
      ((== 1 x) (== 1 y) (== 0 r))
      (else fail))))

(test-check "7.6"
  (run* (s)
    (fresh (x y)
      (bit-xoro x y 0)
      (== `(,x ,y) s)))
  `((0 0)
    (1 1)))

(test-check "7.8"
  (run* (s)
    (fresh (x y)
      (bit-xoro x y 1)
      (== `(,x ,y) s)))
  `((1 0)
    (0 1)))

(test-check "7.9"
  (run* (s)
    (fresh (x y r)
      (bit-xoro x y r)
      (== `(,x ,y ,r) s)))
  `((0 0 0)
    (1 0 1)
    (0 1 1)
    (1 1 0)))

; 7.10
(define bit-ando
  (lambda (x y r)
    (conde
      ((== 0 x) (== 0 y) (== 0 r))
      ((== 1 x) (== 0 y) (== 0 r))
      ((== 0 x) (== 1 y) (== 0 r))
      ((== 1 x) (== 1 y) (== 1 r))
      (else fail))))

(test-check "7.11"
  (run* (s)
    (fresh (x y)
      (bit-ando x y 1)
      (== `(,x ,y) s)))
  `((1 1)))

; 7.12.1
(define half-addero
  (lambda (x y r c)
    (all
      (bit-xoro x y r)
      (bit-ando x y c))))

(test-check "7.12.2"
  (run* (r)
    (half-addero 1 1 r 1))
  (list 0))

(test-check "7.13"
  (run* (s)
    (fresh (x y r c)
      (half-addero x y r c)
      (== `(,x ,y ,r ,c) s)))
  `((0 0 0 0)
    (1 0 1 0)
    (0 1 1 0)
    (1 1 0 1)))

; 7.15.1
(define full-addero
  (lambda (b x y r c)
    (fresh (w xy wz)
      (half-addero x y w xy)
      (half-addero w b r wz)
      (bit-xoro xy wz c))))

(test-check "7.15.2"
  (run* (s)
    (fresh (r c)
      (full-addero 0 1 1 r c)
      (== `(,r ,c) s)))
  (list `(0 1)))

; 7.15.3
(define full-addero1
  (lambda (b x y r c)
    (conde
      ((== 0 b) (== 0 x) (== 0 y) (== 0 r) (== 0 c))
      ((== 1 b) (== 0 x) (== 0 y) (== 1 r) (== 0 c))
      ((== 0 b) (== 1 x) (== 0 y) (== 1 r) (== 0 c))
      ((== 1 b) (== 1 x) (== 0 y) (== 0 r) (== 1 c))
      ((== 0 b) (== 0 x) (== 1 y) (== 1 r) (== 0 c))
      ((== 1 b) (== 0 x) (== 1 y) (== 0 r) (== 1 c))
      ((== 0 b) (== 1 x) (== 1 y) (== 0 r) (== 1 c))
      ((== 1 b) (== 1 x) (== 1 y) (== 1 r) (== 1 c))
      (else fail))))

(test-check "7.16"
  (run* (s)
    (fresh (r c)
      (full-addero1 1 1 1 r c)
      (== `(,r ,c) s)))
  (list `(1 1)))

(test-check "7.17"
  (run* (s)
    (fresh (b x y r c)
      (full-addero1 b x y r c)
      (== `(,b ,x ,y ,r ,c) s)))
  `((0 0 0 0 0)
    (1 0 0 1 0)
    (0 1 0 1 0)
    (1 1 0 0 1)
    (0 0 1 1 0)
    (1 0 1 0 1)
    (0 1 1 0 1)
    (1 1 1 1 1)))

; 7.43
(define build-num
  (lambda (n)
    (cond
      ((zero? n) '())
      ((and (not (zero? n)) (even? n))
       (cons 0
         (build-num (quotient n 2))))
      ((odd? n)
       (cons 1
         (build-num (quotient (- n 1) 2)))))))

(test-check "7.25"
  `(1 0 1)
  (build-num 5))

(test-check "7.26"
  `(1 1 1)
  (build-num 7))

(test-check "7.27"
  (build-num 9)
  `(1 0 0 1))

(test-check "7.28"
  (build-num 6)
  `(0 1 1))

(test-check "7.31"
  (build-num 19)
  `(1 1 0 0 1))

(test-check "7.32"
  (build-num 17290)
  `(0 1 0 1 0 0 0 1 1 1 0 0 0 0 1))

(test-check "7.40"
  (build-num 0)
  `())

(test-check "7.41"
  (build-num 36)
  `(0 0 1 0 0 1))

(test-check "7.42"
  (build-num 19)
  `(1 1 0 0 1))

; 7.44
(define build-num1
  (lambda (n)
    (cond
      ((odd? n)
       (cons 1
         (build-num1 (quotient (- n 1) 2))))
      ((and (not (zero? n)) (even? n))
       (cons 0
         (build-num1 (quotient n 2))))
      ((zero? n) '()))))

; 7.80.1
(define poso
  (lambda (n)
    (fresh (a d)
      (== `(,a . ,d) n))))

(test-check "7.80.2"
  (run* (q)
    (poso '(0 1 1))
    (== #t q))
  (list #t))

(test-check "7.81"
  (run* (q)
    (poso '(1))
    (== #t q))
  (list #t))

(test-check "7.82"
  (run* (q)
    (poso '())
    (== #t q))
  `())

(test-check "7.83"
  (run* (r)
    (poso r))
  (list `(_.0 . _.1)))

; 7.86.1
(define >1o
  (lambda (n)
    (fresh (a ad dd)
      (== `(,a ,ad . ,dd) n))))

(test-check "7.86.2"
  (run* (q)
    (>1o '(0 1 1))
    (== #t q))
  (list #t))

(test-check "7.87"
  (run* (q)
    (>1o '(0 1))
    (== #t q))
  `(#t))

(test-check "7.88"
  (run* (q)
    (>1o '(1))
    (== #t q))
  `())

(test-check "7.89"
  (run* (q)
    (>1o '())
    (== #t q))
  `())

(test-check "7.90"
  (run* (r)
    (>1o r))
  (list `(_.0 _.1 . _.2)))

; 7.118.1
(define addero
  (lambda (d n m r)
    (condi
      ((== 0 d) (== '() m) (== n r))
      ((== 0 d) (== '() n) (== m r)
       (poso m))
      ((== 1 d) (== '() m)
       (addero 0 n '(1) r))
      ((== 1 d) (== '() n) (poso m)
       (addero 0 '(1) m r))
      ((== '(1) n) (== '(1) m)
       (fresh (a c)
         (== `(,a ,c) r)
         (full-addero d 1 1 a c)))
      ((== '(1) n) (gen-addero d n m r))
      ((== '(1) m) (>1o n) (>1o r)
       (addero d '(1) n r))
      ((>1o n) (gen-addero d n m r))
      (else fail))))

; 7.118.2
(define gen-addero
  (lambda (d n m r)
    (fresh (a b c e x y z)
      (== `(,a . ,x) n)
      (== `(,b . ,y) m) (poso y)
      (== `(,c . ,z) r) (poso z)
      (alli
        (full-addero d a b c e)
        (addero e x y z)))))

(test-check "7.97"
  (run 3 (s)
    (fresh (x y r)
      (addero 0 x y r)
      (== `(,x ,y ,r) s)))
  `((_.0 () _.0)
    (() (_.0 . _.1) (_.0 . _.1))
    ((1) (1) (0 1))))

(test-check "7.101"
  (run 22 (s)
    (fresh (x y r)
      (addero 0 x y r)
      (== `(,x ,y ,r) s)))
  `((_.0 () _.0)
    (() (_.0 . _.1) (_.0 . _.1))
    ((1) (1) (0 1))
    ((1) (0 _.0 . _.1) (1 _.0 . _.1))
    ((0 _.0 . _.1) (1) (1 _.0 . _.1))
    ((1) (1 1) (0 0 1))
    ((0 1) (0 1) (0 0 1))
    ((1) (1 0 _.0 . _.1) (0 1 _.0 . _.1))
    ((1 1) (1) (0 0 1))
    ((1) (1 1 1) (0 0 0 1))
    ((1 1) (0 1) (1 0 1))
    ((1) (1 1 0 _.0 . _.1) (0 0 1 _.0 . _.1))
    ((1 0 _.0 . _.1) (1) (0 1 _.0 . _.1))
    ((1) (1 1 1 1) (0 0 0 0 1))
    ((0 1) (0 0 _.0 . _.1) (0 1 _.0 . _.1))
    ((1) (1 1 1 0 _.0 . _.1) (0 0 0 1 _.0 . _.1))
    ((1 1 1) (1) (0 0 0 1))
    ((1) (1 1 1 1 1) (0 0 0 0 0 1))
    ((0 1) (1 1) (1 0 1))
    ((1) (1 1 1 1 0 _.0 . _.1) (0 0 0 0 1 _.0 . _.1))
    ((1 1 0 _.0 . _.1) (1) (0 0 1 _.0 . _.1))
    ((1) (1 1 1 1 1 1) (0 0 0 0 0 0 1))))

(test-check "7.120"
  (run* (s)
    (gen-addero 1 '(0 1 1) '(1 1) s))
  (list `(0 1 0 1)))

(test-check "7.126"
  (run* (s)
    (fresh (x y)
      (addero 0 x y '(1 0 1))
      (== `(,x ,y) s)))
  `(((1 0 1) ())
    (() (1 0 1))
    ((1) (0 0 1))
    ((0 0 1) (1))
    ((1 1) (0 1))
    ((0 1) (1 1))))

; 7.128
(define plus-o
  ;; original +o
  (lambda (n m k)
    (addero 0 n m k)))

(test-check "7.129"
  (run* (s)
    (fresh (x y)
      (plus-o x y '(1 0 1))
      (== `(,x ,y) s)))
  `(((1 0 1) ())
    (() (1 0 1))
    ((1) (0 0 1))
    ((0 0 1) (1))
    ((1 1) (0 1))
    ((0 1) (1 1))))

; 7.130
(define minus-o
  ;; original -o
  (lambda (n m k)
    (plus-o m k n)))

(test-check "7.131"
  (run* (q)
    (minus-o '(0 0 0 1) '(1 0 1) q))
  `((1 1)))

(test-check "7.132"
  (run* (q)
    (minus-o '(0 1 1) '(0 1 1) q))
  `(()))

(test-check "7.133"
  (run* (q)
    (minus-o '(0 1 1) '(0 0 0 1) q))
  `())

; 8.10
(define *o
  (lambda (n m p)
    (condi
      ((== '() n) (== '() p))
      ((poso n) (== '() m) (== '() p))
      ((== '(1) n) (poso m) (== m p))
      ((>1o n) (== '(1) m) (== n p))
      ((fresh (x z)
         (== `(0 . ,x) n) (poso x)
         (== `(0 . ,z) p) (poso z)
         (>1o m)
         (*o x m z)))
      ((fresh (x y)
         (== `(1 . ,x) n) (poso x)
         (== `(0 . ,y) m) (poso y)
         (*o m n p)))
      ((fresh (x y)
          (== `(1 . ,x) n) (poso x)
          (== `(1 . ,y) m) (poso y)
          (odd-*o x n m p)))
      (else fail))))

; 8.18
(define odd-*o
  (lambda (x n m p)
    (fresh (q)
      (bound-*o q p n m)
      (*o x m q)
      (plus-o `(0 . ,q) m p))))

(define bound-*o
  (lambda (q p n m)
    (conde
      ((nullo q) (pairo p))
      (else
        (fresh (x y z)
          (cdro q x)
          (cdro p y)
          (condi
            ((nullo n)
             (cdro m z)
             (bound-*o x y z '()))
            (else
              (cdro n z)
              (bound-*o x y z m))))))))

(test-check "8.1"
  (run 34 (t)
    (fresh (x y r)
      (*o x y r)
      (== `(,x ,y ,r) t)))
  `((() _.0 ())
    ((_.0 . _.1) () ())
    ((1) (_.0 . _.1) (_.0 . _.1))
    ((_.0 _.1 . _.2) (1) (_.0 _.1 . _.2))
    ((0 1) (_.0 _.1 . _.2) (0 _.0 _.1 . _.2))
    ((1 _.0 . _.1) (0 1) (0 1 _.0 . _.1))
    ((0 0 1) (_.0 _.1 . _.2) (0 0 _.0 _.1 . _.2))
    ((1 1) (1 1) (1 0 0 1))
    ((0 1 _.0 . _.1) (0 1) (0 0 1 _.0 . _.1))
    ((1 _.0 . _.1) (0 0 1) (0 0 1 _.0 . _.1))
    ((0 0 0 1) (_.0 _.1 . _.2) (0 0 0 _.0 _.1 . _.2))
    ((1 1) (1 0 1) (1 1 1 1))
    ((0 1 1) (1 1) (0 1 0 0 1))
    ((1 1) (0 1 1) (0 1 0 0 1))
    ((0 0 1 _.0 . _.1) (0 1) (0 0 0 1 _.0 . _.1))
    ((1 1) (1 1 1) (1 0 1 0 1))
    ((0 1 _.0 . _.1) (0 0 1) (0 0 0 1 _.0 . _.1))
    ((1 _.0 . _.1) (0 0 0 1) (0 0 0 1 _.0 . _.1))
    ((0 0 0 0 1) (_.0 _.1 . _.2) (0 0 0 0 _.0 _.1 . _.2))
    ((1 0 1) (1 1) (1 1 1 1))
    ((0 1 1) (1 0 1) (0 1 1 1 1))
    ((1 0 1) (0 1 1) (0 1 1 1 1))
    ((0 0 1 1) (1 1) (0 0 1 0 0 1))
    ((1 1) (1 0 0 1) (1 1 0 1 1))
    ((0 1 1) (0 1 1) (0 0 1 0 0 1))
    ((1 1) (0 0 1 1) (0 0 1 0 0 1))
    ((0 0 0 1 _.0 . _.1) (0 1) (0 0 0 0 1 _.0 . _.1))
    ((1 1) (1 1 0 1) (1 0 0 0 0 1))
    ((0 1 1) (1 1 1) (0 1 0 1 0 1))
    ((1 1 1) (0 1 1) (0 1 0 1 0 1))
    ((0 0 1 _.0 . _.1) (0 0 1) (0 0 0 0 1 _.0 . _.1))
    ((1 1) (1 0 1 1) (1 1 1 0 0 1))
    ((0 1 _.0 . _.1) (0 0 0 1) (0 0 0 0 1 _.0 . _.1))
    ((1 _.0 . _.1) (0 0 0 0 1) (0 0 0 0 1 _.0 . _.1))))

(test-check "8.4"
  (run* (p)
    (*o '(0 1) '(0 0 1) p))
  (list `(0 0 0 1)))

; 8.19
(define bound-*o1
  (lambda (q p n m)
    succeed))

(test-check "8.20"
  (run 1 (t)
    (fresh (n m)
      (*o n m '(1))
      (== `(,n ,m) t)))
  (list `((1) (1))))

(test-divergence "8.21"
  (run 2 (t)
    (fresh (n m)
      (*o n m '(1))
      (== `(,n ,m) t))))

; 8.22
(define bound-*o2
  (lambda (q p n m)
    (conde
      ((nullo q) (pairo p))
      (else
        (fresh (x y z)
          (cdro q x)
          (cdro p y)
          (condi
            ((nullo n)
             (cdro m z)
             (bound-*o2 x y z '()))
            (else
              (cdro n z)
              (bound-*o2 x y z m))))))))

(test-check "8.23"
  (run 2 (t)
    (fresh (n m)
      (*o n m '(1))
      (== `(,n ,m) t)))
  `(((1) (1))))

(test-check "8.24"
  (run* (p)
    (*o '(1 1 1) '(1 1 1 1 1 1) p))
  (list `(1 0 0 1 1 1 0 1 1)))

; 8.26
(define =lo
  (lambda (n m)
    (conde
      ((== '() n) (== '() m))
      ((== '(1) n) (== '(1) m))
      (else
        (fresh (a x b y)
          (== `(,a . ,x) n) (poso x)
          (== `(,b . ,y) m) (poso y)
          (=lo x y))))))

(test-check "8.27"
  (run* (t)
    (fresh (w x y)
      (=lo `(1 ,w ,x . ,y) '(0 1 1 0 1))
      (== `(,w ,x ,y) t)))
  (list `(_.0 _.1 (_.2 1))))

(test-check "8.28"
  (run* (b)
    (=lo '(1) `(,b)))
  (list 1))

(test-check "8.29"
  (run* (n)
    (=lo `(1 0 1 . ,n) '(0 1 1 0 1)))
  (list `(_.0 1)))

(test-check "8.30"
  (run 5 (t)
    (fresh (y z)
      (=lo `(1 . ,y) `(1 . ,z))
      (== `(,y ,z) t)))
  `((() ())
    ((1) (1))
    ((_.0 1) (_.1 1))
    ((_.0 _.1 1) (_.2 _.3 1))
    ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))))

(test-check "8.31"
  (run 5 (t)
    (fresh (y z)
      (=lo `(1 . ,y) `(0 . ,z))
      (== `(,y ,z) t)))
  `(((1) (1))
    ((_.0 1) (_.1 1))
    ((_.0 _.1 1) (_.2 _.3 1))
    ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
    ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))))

(test-check "8.33"
  (run 5 (t)
    (fresh (y z)
      (=lo `(1 . ,y) `(0 1 1 0 1 . ,z))
      (== `(,y ,z) t)))
  `(((_.0 _.1 _.2 1) ())
    ((_.0 _.1 _.2 _.3 1) (1))
    ((_.0 _.1 _.2 _.3 _.4 1) (_.5 1))
    ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 1))
    ((_.0 _.1 _.2 _.3 _.4 _.5 _.6 1) (_.7 _.8 _.9 1))))

; 8.34
(define <lo
  (lambda (n m)
    (conde
      ((== '() n) (poso m))
      ((== '(1) n) (>1o m))
      (else
        (fresh (a x b y)
          (== `(,a . ,x) n) (poso x)
          (== `(,b . ,y) m) (poso y)
          (<lo x y))))))

(test-check "8.35"
  (run 8 (t)
    (fresh (y z)
      (<lo `(1 . ,y) `(0 1 1 0 1 . ,z))
      (== `(,y ,z) t)))
  `((() _.0)
    ((1) _.0)
    ((_.0 1) _.1)
    ((_.0 _.1 1) _.2)
    ((_.0 _.1 _.2 1) (_.3 . _.4))
    ((_.0 _.1 _.2 _.3 1) (_.4 _.5 . _.6))
    ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 . _.8))
    ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 _.8 _.9 . _.10))))

(test-divergence "8.37"
  (run 1 (n)
    (<lo n n)))

; 8.38
(define <=lo
  (lambda (n m)
    (conde
      ((=lo n m) succeed)
      ((<lo n m) succeed)
      (else fail))))

(test-check "8.39"
  (run 8 (t)
    (fresh (n m)
      (<=lo n m)
      (== `(,n ,m) t)))
  `((() ())
    ((1) (1))
    ((_.0 1) (_.1 1))
    ((_.0 _.1 1) (_.2 _.3 1))
    ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
    ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))
    ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 1))
    ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 _.8 _.9 _.10 _.11 1))))

(test-check "8.40"
  (run 1 (t)
    (fresh (n m)
      (<=lo n m)
      (*o n '(0 1) m)
      (== `(,n ,m) t)))
  (list `(() ())))

(test-divergence "8.41"
  (run 2 (t)
    (fresh (n m)
      (<=lo n m)
      (*o n '(0 1) m)
      (== `(,n ,m) t))))

(test-divergence "8-18"
  (run 2 (t)
    (fresh (n m)
      (<=lo n m)
      (*o n '(0 1) m)
      (== `(,n ,m) t))))

; 8.42
(define <=lo1
  (lambda (n m)
    (condi
      ((=lo n m) succeed)
      ((<lo n m) succeed)
      (else fail))))

(test-check "8.43"
  (run 10 (t)
    (fresh (n m)
      (<=lo1 n m)
      (*o n '(0 1) m)
      (== `(,n ,m) t)))
  `((() ())
    ((1) (0 1))
    ((0 1) (0 0 1))
    ((1 1) (0 1 1))
    ((0 0 1) (0 0 0 1))
    ((1 _.0 1) (0 1 _.0 1))
    ((0 1 1) (0 0 1 1))
    ((0 0 0 1) (0 0 0 0 1))
    ((1 _.0 _.1 1) (0 1 _.0 _.1 1))
    ((0 1 _.0 1) (0 0 1 _.0 1))))

(test-check "8.44"
  (run 15 (t)
    (fresh (n m)
      (<=lo1 n m)
      (== `(,n ,m) t)))
  `((() ())
    (() (_.0 . _.1))
    ((1) (1))
    ((1) (_.0 _.1 . _.2))
    ((_.0 1) (_.1 1))
    ((_.0 1) (_.1 _.2 _.3 . _.4))
    ((_.0 _.1 1) (_.2 _.3 1))
    ((_.0 _.1 1) (_.2 _.3 _.4 _.5 . _.6))
    ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
    ((_.0 _.1 _.2 1) (_.3 _.4 _.5 _.6 _.7 . _.8))
    ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))
    ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 _.8 _.9 . _.10))
    ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 1))
    ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 _.10 _.11 . _.12))
    ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 _.8 _.9 _.10 _.11 1))))

; 8.46.1
(define <o
  (lambda (n m)
    (condi
      ((<lo n m) succeed)
      ((=lo n m)
       (fresh (x)
         (poso x)
         (plus-o n x m)))
      (else fail))))

; 8.46.2
(define <=o2
  (lambda (n m)
    (condi
      ((== n m) succeed)
      ((<o n m) succeed)
      (else fail))))

(test-check "8.47"
  (run* (q)
    (<o '(1 0 1) '(1 1 1))
    (== #t q))
  (list #t))

(test-check "8.48"
  (run* (q)
    (<o '(1 1 1) '(1 0 1))
    (== #t q))
  `())

(test-check "8.49.1"
  (run* (q)
    (<o '(1 0 1) '(1 0 1))
    (== #t q))
  `())

(test-check "8.49.2"
  (run* (q)
    (<=o2 '(1 0 1) '(1 0 1))
    (== #t q))
  `(#t))

(test-check "8.50"
  (run 6 (n)
    (<o n `(1 0 1)))
  `(() (0 0 1) (1) (_.0 1)))

(test-check "8.51"
  (run 6 (m)
    (<o `(1 0 1) m))
  `((_.0 _.1 _.2 _.3 . _.4) (0 1 1) (1 1 1)))

(test-divergence "8.52"
  (run* (n)
    (<o n n)))

(define /o
  (lambda (n m q r)
    (condi
      ((== r n) (== '() q) (<o n m))
      ((== '(1) q) (=lo n m) (plus-o r m n)
       (<o r m))
      (else
        (alli
          (<lo m n)
          (<o r m)
          (poso q)
          (fresh (nh nl qh ql qlm qlmr rr rh)
            (alli
              (splito n r nl nh)
              (splito q r ql qh)
              (conde
                ((== '() nh)
                 (== '() qh)
                 (minus-o nl r qlm)
                 (*o ql m qlm))
                (else
                  (alli
                    (poso nh)
                    (*o ql m qlm)
                    (plus-o qlm r qlmr)
                    (minus-o qlmr nl rr)
                    (splito rr r '() rh)
                    (/o nh m qh rh)))))))))))

(define splito
  (lambda (n r l h)
    (condi
      ((== '() n) (== '() h) (== '() l))
      ((fresh (b n^)
         (== `(0 ,b . ,n^) n)
         (== '() r)
         (== `(,b . ,n^) h)
         (== '() l)))
      ((fresh (n^)
         (==  `(1 . ,n^) n)
         (== '() r)
         (== n^ h)
         (== '(1) l)))
      ((fresh (b n^ a r^)
         (== `(0 ,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== '() l)
         (splito `(,b . ,n^) r^ '() h)))
      ((fresh (n^ a r^)
         (== `(1 . ,n^) n)
         (== `(,a . ,r^) r)
         (== '(1) l)
         (splito n^ r^ '() h)))
      ((fresh (b n^ a r^ l^)
         (== `(,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== `(,b . ,l^) l)
         (poso l^)
         (splito n^ r^ l^ h)))
      (else fail))))

(test-check "8.53"
  (run 15 (t)
    (fresh (n m q r)
      (/o n m q r)
      (== `(,n ,m ,q ,r) t)))
  `((() (_.0 . _.1) () ())
    ((1) (1) (1) ())
    ((0 1) (1 1) () (0 1))
    ((0 1) (1) (0 1) ())
    ((1) (_.0 _.1 . _.2) () (1))
    ((_.0 1) (_.0 1) (1) ())
    ((0 _.0 1) (1 _.0 1) () (0 _.0 1))
    ((0 _.0 1) (_.0 1) (0 1) ())
    ((_.0 1) (_.1 _.2 _.3 . _.4) () (_.0 1))
    ((1 1) (0 1) (1) (1))
    ((0 0 1) (0 1 1) () (0 0 1))
    ((1 1) (1) (1 1) ())
    ((_.0 _.1 1) (_.2 _.3 _.4 _.5 . _.6) () (_.0 _.1 1))
    ((_.0 _.1 1) (_.0 _.1 1) (1) ())
    ((1 0 1) (0 1 1) () (1 0 1))))

; 8.63
(define /o1
  (lambda (n m q r)
    (condi
      ((== '() q) (== n r) (<o n m))
      ((== '(1) q) (== '() r) (== n m)
       (<o r m))
      ((<o m n) (<o r m)
       (fresh (mq)
         (<=lo mq n)
         (*o m q mq)
         (plus-o mq r n)))
      (else fail))))

(test-divergence "8.81"
  (run 3 (t)
    (fresh (y z)
      (/o1 `(1 0 . ,y) '(0 1) z '())
      (== `(,y ,z) t))))

; 8.76.1
(define /o2
  (lambda (n m q r)
    (condi
      ((== r n) (== '() q) (<o n m))
      ((== '(1) q) (=lo n m) (plus-o r m n)
       (<o r m))
      (else
        (alli
          (<lo m n)
          (<o r m)
          (poso q)
          (fresh (nh nl qh ql qlm qlmr rr rh)
            (alli
              (splito1 n r nl nh)
              (splito1 q r ql qh)
              (conde
                ((== '() nh)
                 (== '() qh)
                 (minus-o nl r qlm)
                 (*o ql m qlm))
                (else
                  (alli
                    (poso nh)
                    (*o ql m qlm)
                    (plus-o qlm r qlmr)
                    (minus-o qlmr nl rr)
                    (splito1 rr r '() rh)
                    (/o2 nh m qh rh)))))))))))

; 8.76.2
(define splito1
  (lambda (n r l h)
    (condi
      ((== '() n) (== '() h) (== '() l))
      ((fresh (b n^)
         (== `(0 ,b . ,n^) n)
         (== '() r)
         (== `(,b . ,n^) h)
         (== '() l)))
      ((fresh (n^)
         (==  `(1 . ,n^) n)
         (== '() r)
         (== n^ h)
         (== '(1) l)))
      ((fresh (b n^ a r^)
         (== `(0 ,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== '() l)
         (splito1 `(,b . ,n^) r^ '() h)))
      ((fresh (n^ a r^)
         (== `(1 . ,n^) n)
         (== `(,a . ,r^) r)
         (== '(1) l)
         (splito1 n^ r^ '() h)))
      ((fresh (b n^ a r^ l^)
         (== `(,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== `(,b . ,l^) l)
         (poso l^)
         (splito1 n^ r^ l^ h)))
      (else fail))))

; 8.82.1
(define logo
  (lambda (n b q r)
    (condi
      ((== '(1) n) (poso b) (== '() q) (== '() r))
      ((== '() q) (<o n b) (plus-o r '(1) n))
      ((== '(1) q) (>1o b) (=lo n b) (plus-o r b n))
      ((== '(1) b) (poso q) (plus-o r '(1) n))
      ((== '() b) (poso q) (== r n))
      ((== '(0 1) b)
       (fresh (a ad dd)
         (poso dd)
         (== `(,a ,ad . ,dd) n)
         (exp2 n '() q)
         (fresh (s)
           (splito1 n dd r s))))
      ((fresh (a ad add ddd)
         (conde
           ((== '(1 1) b))
           (else (== `(,a ,ad ,add . ,ddd) b))))
       (<lo b n)
       (fresh (bw1 bw nw nw1 ql1 ql s)
         (exp2 b '() bw1)
         (plus-o bw1 '(1) bw)
         (<lo q n)
         (fresh (q1 bwq1)
           (plus-o q '(1) q1)
           (*o bw q1 bwq1)
           (<o nw1 bwq1))
           (exp2 n '() nw1)
           (plus-o nw1 '(1) nw)
           (/o2 nw bw ql1 s)
           (plus-o ql '(1) ql1)
         (conde
           ((== q ql))
           (else (<lo ql q)))
         (fresh (bql qh s qdh qd)
           (repeated-mul b ql bql)
           (/o2 nw bw1 qh s)
           (plus-o ql qdh qh)
           (plus-o ql qd q)
           (conde
             ((== qd qdh))
             (else (<o qd qdh)))
           (fresh (bqd bq1 bq)
             (repeated-mul b qd bqd)
             (*o bql bqd bq)
             (*o b bq bq1)
             (plus-o bq r n)
             (<o n bq1)))))
      (else fail))))

; 8.82.2
(define exp2
  (lambda (n b q)
    (condi
      ((== '(1) n) (== '() q))
      ((>1o n) (== '(1) q)
       (fresh (s)
         (splito1 n b s '(1))))
      ((fresh (q1 b2)
         (alli
           (== `(0 . ,q1) q)
           (poso q1)
           (<lo b n)
           (appendo b `(1 . ,b) b2)
           (exp2 n b2 q1))))
      ((fresh (q1 nh b2 s)
          (alli
            (== `(1 . ,q1) q)
            (poso q1)
            (poso nh)
            (splito1 n b s nh)
            (appendo b `(1 . ,b) b2)
            (exp2 nh b2 q1))))
      (else fail))))

; 8.82.3
(define repeated-mul
  (lambda (n q nq)
    (conde
      ((poso n) (== '() q) (== '(1) nq))
      ((== '(1) q) (== n nq))
      ((>1o q)
       (fresh (q1 nq1)
         (plus-o q1 '(1) q)
         (repeated-mul n q1 nq1)
         (*o nq1 n nq)))
      (else fail))))

(test-check "8.89"
  (run* (r)
    (logo '(0 1 1 1) '(0 1) '(1 1) r))
  (list `(0 1 1)))

(cout "This next test takes several minutes to run!" nl)

(test-check "8.96"
  (run 8 (s)
    (fresh (b q r)
      (logo '(0 0 1 0 0 0 1) b q r)
      (>1o q)
      (== `(,b ,q ,r) s)))
  `(((1) (_.0 _.1 . _.2) (1 1 0 0 0 0 1))
    (() (_.0 _.1 . _.2) (0 0 1 0 0 0 1))
    ((0 1) (0 1 1) (0 0 1))
    ((0 0 1) (1 1) (0 0 1))
    ((1 0 1) (0 1) (1 1 0 1 0 1))
    ((0 1 1) (0 1) (0 0 0 0 0 1))
    ((1 1 1) (0 1) (1 1 0 0 1))
    ((0 0 0 1) (0 1) (0 0 1))))

; 8.91
(define expo
  (lambda (b q n)
    (logo n b q '())))

(test-check "8.92"
  (run* (t)
    (expo '(1 1) '(1 0 1) t))
  (list `(1 1 0 0 1 1 1 1)))

; 9.6
(define u (var 'u))
(define v (var 'v))
(define w (var 'w))
(define x (var 'x))
(define y (var 'y))
(define z (var 'z))

(test-check "9.8"
  (rhs `(,z . b))
  'b)

(test-check "9.9"
  (rhs `(,z . ,w))
  w)

(test-check "9.10"
  (rhs `(,z . (,x e ,y)))
  `(,x e ,y))

(test-check "9.14"
  (walk z `((,z . a) (,x . ,w) (,y . ,z)))
  'a)

(test-check "9.15"
  (walk y `((,z . a) (,x . ,w) (,y . ,z)))
  'a)

(test-check "9.16"
  (walk x `((,z . a) (,x . ,w) (,y . ,z)))
  w)

(test-check "9.17"
  (walk w `((,z . a) (,x . ,w) (,y . ,z)))
  w)

(test-divergence "9.18"
  (walk x `((,x . ,y) (,z . ,x) (,y . ,z))))

(test-check "9.19"
  (walk w `((,x . ,y) (,w . b) (,z . ,x) (,y . ,z)))
  'b)

(test-check "9.25"
  (walk u `((,x . b) (,w . (,x e ,x)) (,u . ,w)))
  `(,x e ,x))

(test-divergence "9.29"
  (walk x (ext-s x y `((,z . ,x) (,y . ,z)))))

(test-check "9.30"
  (walk y `((,x . e)))
  y)

(test-check "9.31"
  (walk y (ext-s y x `((,x . e))))
  'e)

(test-check "9.32"
  (walk x `((,y . ,z) (,x . ,y)))
  z)

(test-check "9.33"
  (walk x (ext-s z 'b `((,y . ,z) (,x . ,y))))
  'b)

(test-check "9.34"
  (walk x (ext-s z w `((,y . ,z) (,x . ,y))))
  w)

(test-check "9.44"
  (walk* x `((,y . (a ,z c)) (,x . ,y) (,z . a)))
  `(a a c))

(test-check "9.45"
  (walk* x `((,y . (,z ,w c)) (,x . ,y) (,z . a)))
  `(a ,w c))

(test-check "9.46"
  (walk* y `((,y . (,w ,z c)) (,v . b) (,x . ,v) (,z . ,x)))
  `(,w b c))

(test-check "9.47"
  (run* (q)
    (== #f q)
    (project (q)
      (== (not (not q)) q)))
  '(#f))

(test-check "9.53"
  (let ((r `(,w ,x ,y)))
    (walk* r (reify-s r empty-s)))
  `(_.0 _.1 _.2))

(test-check "9.54"
  (let ((r (walk* `(,x ,y ,z) empty-s)))
    (walk* r (reify-s r empty-s)))
  `(_.0 _.1 _.2))

(test-check "9.55"
  (let ((r `(,u (,v (,w ,x) ,y) ,x)))
    (walk* r (reify-s r empty-s)))
  `(_.0 (_.1 (_.2 _.3) _.4) _.3))

(test-check "9.56"
  (let ((s `((,y . (,z ,w c ,w)) (,x . ,y) (,z . a))))
    (let ((r (walk* x s)))
      (walk* r (reify-s r empty-s))))
  `(a _.0 c _.0))

(test-check "9.58"
  (let ((s `((,y . (,z ,w c ,w)) (,x . ,y) (,z . a))))
    (reify (walk* x s)))
  `(a _.0 c _.0))

(test-divergence "9.61"
  (run 1 (x)
    (== `(,x) x)))

(test-check "9.62"
  (run 1 (q)
    (fresh (x)
      (== `(,x) x)
      (== #t q)))
  `(#t))

(test-check "9.63"
  (run 1 (q)
    (fresh (x y)
      (== `(,x) y)
      (== `(,y) x)
      (== #t q)))
  `(#t))

(test-check "9.64"
  (run 1 (x)
    (==-check `(,x) x))
  `())

(test-divergence "9.65"
  (run 1 (x)
    (fresh (y z)
      (== x z)
      (== `(a b ,z) y)
      (== x y))))

(test-check "9.66"
  (run 1 (x)
    (fresh (y z)
      (== x z)
      (== `(a b ,z) y)
      (==-check x y)))
  `())

(test-divergence "9.69"
  (run 1 (x)
    (== `(,x) x)))

(test-check "10.1"
  (run* (q)
    (conda
      (fail succeed)
      (else fail)))
  '())

(test-check "10.2"
  (not (null? (run* (q)
                (conda
                  (fail succeed)
                  (else succeed)))))
  #t)

(test-check "10.3"
  (not (null? (run* (q)
                (conda
                  (succeed fail)
                  (else succeed)))))
  #f)

(test-check "10.4"
  (not (null? (run* (q)
                (conda
                  (succeed succeed)
                  (else fail)))))
  #t)

(test-check "10.5"
  (run* (x)
    (conda
      ((== 'olive x) succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `(olive))

(test-check "10.7"
  (run* (x)
    (conda
      ((== 'virgin x) fail)
      ((== 'olive x) succeed)
      ((== 'oil x) succeed)
      (else fail)))
  `())

(test-check "10.8"
  (run* (q)
    (fresh (x y)
      (== 'split x)
      (== 'pea y)
      (conda
        ((== 'split x) (== x y))
        (else succeed)))
    (== #t q))
  `())

(test-check "10.9"
  (run* (q)
    (fresh (x y)
      (== 'split x)
      (== 'pea y)
      (conda
        ((== x y) (== 'split x))
        (else succeed)))
    (== #t q))
  (list #t))

; 10.11.1
(define not-pastao
  (lambda (x)
    (conda
      ((== 'pasta x) fail)
      (else succeed))))

(test-check "10.11.2"
  (run* (x)
    (conda
      ((not-pastao x) fail)
      (else (== 'spaghetti x))))
  '(spaghetti))

(test-check "10.12"
  (run* (x)
    (== 'spaghetti x)
    (conda
      ((not-pastao x) fail)
      (else (== 'spaghetti x))))
  '())

(test-divergence "10.13"
  (run* (q)
    (conda
      (alwayso succeed)
      (else fail))
    (== #t q)))

(test-check "10.14"
  (run* (q)
    (condu
      (alwayso succeed)
      (else fail))
    (== #t q))
  `(#t))

(test-divergence "10.15"
  (run* (q)
    (condu
      (succeed alwayso)
      (else fail))
    (== #t q)))

(test-divergence "10.17"
  (run 1 (q)
    (conda
      (alwayso succeed)
      (else fail))
    fail
    (== #t q)))

(test-check "10.18"
  (run 1 (q)
    (condu
      (alwayso succeed)
      (else fail))
    fail
    (== #t q))
  `())

; 10.19.1
(define onceo
  (lambda (g)
    (condu
      (g succeed)
      (else fail))))

(test-check "10.19.2"
  (run* (x)
    (onceo (teacupo x)))
  `(tea))

(test-check "10.20"
  (run 1 (q)
    (onceo (salo nevero))
    fail)
  `())

(test-check "10.21"
  (run* (r)
    (conde
      ((teacupo r) succeed)
      ((== #f r) succeed)
      (else fail)))
  `(tea cup #f))

(test-check "10.22"
  (run* (r)
    (conda
      ((teacupo r) succeed)
      ((== #f r) succeed)
      (else fail)))
  `(tea cup))

(test-check "10.23"
  (run* (r)
    (== #f r)
    (conda
      ((teacupo r) succeed)
      ((== #f r) succeed)
      (else fail)))
  `(#f))

(test-check "10.24"
  (run* (r)
    (== #f r)
    (condu
      ((teacupo r) succeed)
      ((== #f r) succeed)
      (else fail)))
  `(#f))

; 10.26.1
(define bumpo
  (lambda (n x)
    (conde
      ((== n x) succeed)
      (else
        (fresh (m)
          (minus-o n '(1) m)
          (bumpo m x))))))

(test-check "10.26.2"
  (run* (x)
    (bumpo '(1 1 1) x))
  `((1 1 1)
    (0 1 1)
    (1 0 1)
    (0 0 1)
    (1 1)
    (0 1)
    (1)
    ()))

; 10.27.1
(define gen&testo
  (lambda (op i j k)
    (onceo
      (fresh (x y z)
        (op x y z)
        (== i x)
        (== j y)
        (== k z)))))

(test-check "10.27.2"
  (run* (q)
    (gen&testo plus-o '(0 0 1) '(1 1) '(1 1 1))
    (== #t q))
  (list #t))

(test-divergence "10.42"
  (run 1 (q)
    (gen&testo plus-o '(0 0 1) '(1 1) '(0 1 1))))

; 10.43.1
(define enumerateo
  (lambda (op r n)
    (fresh (i j k)
      (bumpo n i)
      (bumpo n j)
      (op i j k)
      (gen&testo op i j k)
      (== `(,i ,j ,k) r))))

(test-check "10.43.2"
  (run* (s)
    (enumerateo plus-o s '(1 1)))
  `(((1 1) (1 1) (0 1 1))
    ((1 1) (0 1) (1 0 1))
    ((1 1) (1) (0 0 1))
    ((1 1) () (1 1))
    ((0 1) (1 1) (1 0 1))
    ((0 1) (0 1) (0 0 1))
    ((0 1) (1) (1 1))
    ((0 1) () (0 1))
    ((1) (1 1) (0 0 1))
    ((1) (0 1) (1 1))
    ((1) (1) (0 1))
    ((1) () (1))
    (() (1 1) (1 1))
    (() (0 1) (0 1))
    (() (1) (1))
    (() () ())))

(test-check "10.56"
  (run 1 (s)
    (enumerateo plus-o s '(1 1 1)))
  `(((1 1 1) (1 1 1) (0 1 1 1))))

; 10.57
(define gen-addero1
  (lambda (d n m r)
    (fresh (a b c e x y z)
      (== `(,a . ,x) n)
      (== `(,b . ,y) m) (poso y)
      (== `(,c . ,z) r) (poso z)
      (all
        (full-addero d a b c e)
        (addero e x y z)))))

(test-divergence "10.58"
  (run 1 (q)
    (gen&testo plus-o '(0 1) '(1 1) '(1 0 1))))

(test-divergence "10.62"
  (run* (q)
    (enumerateo plus-o q '(1 1 1))))
