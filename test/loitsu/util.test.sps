
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

(check ((partial * 100) 5) => 500)
(check ((partial * 100) 4 5 6) => 12000)
(check ((partial - 100) 10) => 90)


(check-report)
