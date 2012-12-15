
(import
  (rnrs)
  (pieni check)
  (loitsu control))

(check (-> 3 (+ 3) (- 2)) => 4)

(check (->> 3 (+ 3) (- 9)) => 3)
(check (->> '() (cons 'a) (cons 'b) (cons 'c) (cons 'd)) => '(d c b a))


(check-report)
