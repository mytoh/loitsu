(library (pikkukivi commands colours)
    (export
      colours)
  (import
    (silta base)
    (silta write)
    (only (srfi :1 lists)
          iota)
    (only (srfi :13 strings)
          string-join
          string-every)
    (maali)
    )


  (define (colours-boxes-base)
    (display "base:")
    (newline)
    (for-each
        (lambda (n)
          (display (paint "█" n)))
      (iota 16))
    (newline))

  (define (colours-boxes-others)
    (display "others:")
    (newline)
    (for-each
        (lambda (n)
          (display (paint "█" n))
          (if (exact-integer? (/ n 27))
            (newline)))
      (iota 240 16 1))
    (newline))

  (define (colours-boxes)
    (colours-boxes-base)
    (colours-boxes-others))

  (define (colours type)
    (colours-boxes))

  ))
