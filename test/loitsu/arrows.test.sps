(import
  (rnrs)
  (only (srfi :1)
        iota)
  (pieni check)
  (loitsu arrows))

;; ->
(check (-> 3 (+ 3) (- 2)) => 4)
(check (-> 3 number->string) => (number->string 3))
(check (-> 3 number->string (string-append "test")) => (string-append (number->string 3) "test"))
(check (-> (sqrt 25) (list 3 9) car sin number->string) =>
       (number->string (sin (car (list (sqrt 25) 3 9)))))
;; ->>
(check (->> 3 (+ 3) (- 9)) => 3)
(check (->> '() (cons 'a) (cons 'b) (cons 'c) (cons 'd)) => '(d c b a))

;; -<>
(check (-<> 0 (list 1 2 3)) => '(0 1 2 3)) ; default
(check (-<> 2 (* <> 5) (list 1 2 <> 3 4)) => '(1 2 10 3 4))

;; -<>>
(check (-<>> 0 (list 1 2 3)) => '(1 2 3 0)) ; default
(check (-<> 2 (* <> 5) (list 1 2 <> 3 4)) => '(1 2 10 3 4))



(check-report)
