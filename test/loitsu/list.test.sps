
(import
  (rnrs)
  (pieni check)
  (loitsu list))

(check (flatten '((a) b (c d))) => '(a b c d))

;; rassoc
(check (rassoc 3 '((a . 1) (b . 2) (c . 3))) => '(c . 3))
(check (rassoc 1 '((b . 2))) => #f)
(check (rassoc '(a) '((1 . (b)) (2 . (a)))) => '(2 . (a)))
(check (rassoc "a" '((1 . "b") (2 . "a"))) => '(2 . "a"))
;; rassq
(check (rassq 3 '((a . 1) (b . 2) (c . 3))) => '(c . 3))
(check (rassq #t '((a . #f) (b . #t))) => '(b . #t))
(check (rassq 'a '((1 . a) (2 . b))) => '(1 . a))
(check (rassq '(a) '((1 . (b)) (2 . (a)))) => #f)
(check (let ((x (list 'a)))
         (rassq x `((1 . (a)) (2 . ,x)))) => '(2 . (a)))
(check (rassq 1 '((b . 2))) => #f)
;; rassv
(check (rassv 3 '((a . 1) (b . 2) (c . 3))) => '(c . 3))
(check (rassv #\a '((1 . #\c) (2 . #\a))) => '(2 . #\a))
(check (rassv 1.0 '((a . 1) (b . 1.0))) => '(b . 1.0))
(check (rassv 1 '((a . 1.0) (b . 1))) => '(b . 1))
(check (rassv '(a) '((1 . (b)) (2 . (a)))) => #f)
(check (let ((x (list 'a)))
         (rassv x `((1 . (a)) (2 . ,x)))) => '(2 . (a)))
(check (rassv 1 '((b . 2))) => #f)



(check-report)
