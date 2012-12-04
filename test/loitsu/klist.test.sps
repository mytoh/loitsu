
(import
  (rnrs)
  (pieni check)
  (loitsu klist))


;; non proper klist
(check (klist? 'a) => #f)
(check (klist? "test") => #f)
(check (klist? 1) => #f)
(check (klist? '(a . b)) => #f)
(check (klist? '(a  b)) => #f)
(check (klist? '(:a 1 :b )) => #f)

;; klist
(check (klist? '(:a 1 :b 2)) => #t)

;; klist-ref
(check (klist-ref ':a '(:a 1 :b 2)) => '(:a 1))


(check-report)
