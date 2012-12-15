
(import
  (rnrs)
  (pieni check)
  (loitsu list))

(check (flatten '((a) b (c d))) => '(a b c d))



(check-report)
