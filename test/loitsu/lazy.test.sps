(import
  (rnrs)
  (pieni check)
  (loitsu lazy))

;; lcar
(define lz (lcons 1 (lcons 2 (lcons 3 '()))))
(check (lcar lz) => 1)

;; lcdr
(check (lcar (lcdr lz)) => 2)
(check (lcar (lcdr (lcdr lz))) => 3)
(check (lcdr (lcdr (lcdr lz))) => '())

;; lrepeat
(define lz1 (lrepeat "a"))
(check (lcar lz1) => "a")
(check (lcar (lcdr lz1)) => "a")
(check (lcar (lcdr (lcdr lz1))) => "a")

;; liota
(define lz2 (liota 1 2))
(check (lcar lz2) => 1)
(check (lcar (lcdr lz2)) => 3)
(check (lcar (lcdr (lcdr lz2))) => 5)

(check-report)
