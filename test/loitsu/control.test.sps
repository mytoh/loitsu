
(import
  (rnrs)
  (pieni check)
  (loitsu control))

(check (-> 3 (+ 3) (- 2)) => 4)
(check (-> 3 number->string) => (number->string 3))
(check (-> 3 number->string (string-append "test")) => (string-append (number->string 3) "test") )
(check (-> (sqrt 25) (list 3 9) car sin number->string) =>
       (number->string (sin (car (list (sqrt 25) 3 9)))))

(check (->> 3 (+ 3) (- 9)) => 3)
(check (->> '() (cons 'a) (cons 'b) (cons 'c) (cons 'd)) => '(d c b a))


(check-report)
