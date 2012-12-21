
(import
  (except (rnrs)
          filter)
  (only (srfi :1)
        filter
        second)
  (pieni check)
  (loitsu util))


(check ((comp number->string +) 8 3 8 3 9) => "31")
(check ((comp length filter) even? '(2 9 3 3 0)) => 2)
(check ((comp second reverse) '("a" 2 7 "b")) => 7)
(check (map (comp - *) '(2 4 6) '(1 2 3)) => '(-2 -8 -18))

(check ((partial * 100) 5) => 500)
(check ((partial * 100) 4 5 6) => 12000)
(check ((partial - 100) 10) => 90)
(check (map (partial + 2) '(1 2 3)) => '(3 4 5))
(check ((partial apply vector 1) 2 3 '(4 5)) => '#(1 2 3 4 5))

;; complement
(check (map (complement zero?) '(3 2 1 0)) => '(#t #t #t #f))

;; fork
(check ((fork < car) '(1 . a) '(2 . b) '(3 . c)) => #t)
(check ((fork append reverse) '(3 2 1) '(6 5 4)) => '(1 2 3 4 5 6))


(check-report)
