(import
  (rnrs)
  (only (srfi :1)
        iota)
  (pieni check)
  (loitsu arrows))

; (check (-<> <> (car '(1))) => 1)

; (check (-<> <>
;             0
;             (* <> 5)
;             (list 1 2 <> 3 4))
;        => '(1 2 0 3 4))

; (check (-<> <> [1 2 3]
;             ([-1 0] <> [4 5]
;                     (-<> 10
;                          [7 8 9 <> 11 12]
;                          (cons 6 <>))))
;        => (iota 13 -1))

; (check-report)
