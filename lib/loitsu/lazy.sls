;; -*- coding: utf-8 -*-

(library (loitsu lazy)
    (export
      lcons
      lcar
      lcdr
      lrepeat
      liota
      ltake
      ltake-while
      lmap)
  (import
    (silta base)
    (silta lazy))

  (begin

    (define-syntax lcons
      (syntax-rules ()
        ((_ x y)
         (cons x (delay y)))))

    (define lcar car)

    (define (lcdr s)
      (force (cdr s)))

    (define (lrepeat x)
      (let ((x x))
        (lcons x (lrepeat x))))

    (define (liota n m)
      (let ((n n) (m m))
        (lcons n (liota (+ n m) m))))

    (define (ltake l n)
      (when (and l (> n 0))
        (let ((n n) (l l))
          (lcons (lcar l)
                 (ltake (- n 1) (lcdr l))))))

    (define (ltake-while pred l)
      (when (and l (pred (lcar l)))
        (let ((pred pred) (l l))
          (lcons (lcar l)
                 (ltake-while pred (lcdr l))))))

    (define (lmap proc l)
      (let ((proc proc) (l l))
        (lcons (proc l)
               (lmap proc (lcdr l)))))

    ))
