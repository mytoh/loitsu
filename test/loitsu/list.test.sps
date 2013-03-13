(import
  (rnrs)
  (only (srfi :1)
        last
        reduce)
  (pieni check)
  (loitsu list))

;; flatten
(check (flatten '((a) b (c d))) => '(a b c d))
(check (flatten '((a) b ())) => '(a b))

;; reductions
(check (reductions + '(1 1 1 1)) => '(1 2 3 4))
(check (reductions + '(1 2 3)) => '(1 3 6))
(check (= (reduce + '() '(1 2 3))
         (last (reductions + '(1 2 3)))) => #t)

;; ensure-list
(check (ensure-list 'a) => '(a))
(check (ensure-list '(a)) => '(a))
(check (ensure-list 3) => '(3))



(check-report)
