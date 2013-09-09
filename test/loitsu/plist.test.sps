(import
  (rnrs)
  (pieni check)
  (loitsu plist))

(define pls1 (plist ':a 1 ':b 2))

;; non proper klist
(check (plist? 'a) => #f)
(check (plist? "test") => #f)
(check (plist? 1) => #f)
(check (plist? '()) => #f)
(check (plist? '(a . b)) => #f)
(check (plist? '(a  b)) => #f)
(check (plist? '(:a 1 :b)) => #f)

;; plist?
(check (plist? pls1) => #t)

;; pref
(check (pref pls1 ':a) => '(:a 1))
(check (pref pls1 ':c) => #f)

;; plist
(check (plist ':a 1) => '(:a 1))
(check (plist ':a 1 ':b 2 ':c 3) => '(:a 1 :b 2 :c 3))

;; passoc
(check (passoc pls1 ':a 1) => '(:a 1 :b 2))
(check (passoc pls1 ':c 3) => '(:a 1 :b 2 :c 3))
(check (passoc pls1 ':b 10) => '(:a 1 :b 10))
(check (passoc pls1 ':c 3 ':d 4) => '(:a 1 :b 2 :c 3 :d 4))
(check (passoc pls1 ':a 2 ':b 3) => '(:a 2 :b 3))
(check (passoc pls1 ':c 3 ':d 4 ':e 5) => '(:a 1 :b 2 :c 3 :d 4 :e 5))

;; pdissoc
(check (pdissoc pls1 ':b) => '(:a 1))
(check (pdissoc (plist ':a 1 ':b 2 ':c 3) ':a ':b) => '(:c 3))
(check (pdissoc (plist ':a 1 ':b 2 ':c 3 ':d 4) ':a ':b ':c) => '(:d 4))

;; pkeys
(check (pkeys pls1) => '(:a :b))

;; pval
(check (pval pls1 ':a) => 1)
(check (pval pls1 ':b) => 2)

;; pvals
(check (pvals pls1) => '(1 2))

;; pmap
(check (pmap (lambda (x) (* x x)) (plist ':a 1 ':b 2))
       => '(:a 1 :b 4))

;; pfirst
(check (pfirst pls1) => '(:a 1))

;; psecond
(check (psecond pls1) => '(:b 2))

;; pthird
(check (pthird (plist ':a 1 ':b 2 ':c 3)) => '(:c 3))

;; prest
(check (prest (plist ':a 1 ':b 2 ':c 3)) => '(:b 2 :c 3))


(check-report)
