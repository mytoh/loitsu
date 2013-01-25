
(import
  (rnrs)
  (pieni check)
  (loitsu plist))


;; non proper klist
(check (plist? 'a) => #f)
(check (plist? "test") => #f)
(check (plist? 1) => #f)
(check (plist? '(a . b)) => #f)
(check (plist? '(a  b)) => #f)
(check (plist? '(:a 1 :b )) => #f)

;; klist
(check (plist? '(:a 1 :b 2)) => #t)

;; klist-ref
(check (pref '(:a 1 :b 2) ':a) => 1)


(check-report)
