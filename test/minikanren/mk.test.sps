
(import
  (rnrs)
  (pieni check)
  (minikanren mk))

(check ((lambdag@ (s) #t) #f) => #t)

(check ((lambdaf@ () #t)) => #t)

(check (rhs '(a b)) => '(b))

(check (lhs '(a b)) => 'a)

(check (var 'a) => '#(a))

(check (var? '#(a)) => #t)

(check (size-s '#(a)) => 1)

(check empty-s => '())

(let ((e '#(a)))
  (check (walk e `((,e b))) => '(b))
  (check (walk e '((a b))) => '#(a)))

(check (ext-s 'a 'b 'c) => '((a . b) . c))

(let  ((e '#(a)))
  (check (unify e e '((a . b))) => '((a . b)))
  (check (unify e 'a '((b . c))) => '((#(a) . a) (b . c)))
  (check (unify 'a e '((b . c))) => '((#(a) . a) (b . c))))

(check-report)
