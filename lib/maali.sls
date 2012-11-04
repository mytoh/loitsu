
(library (maali)
  (export paint)
  (import
    (rnrs)
    ; (srfi :13)
    (match))

  (define (escape s)
    (string-append "[" s))

  (define (reset)
    (wrap (escape "0")))

  (define (wrap str)
    (string-append str "m"))

  (define (colour-simple-number str)
    (escape (string-append "38;5;" (number->string str))))

  (define (make-colour lst)
    (map (lambda (str)
           (cond
             ((number? str)
              (colour-simple-number str))))
         lst))

  (define (paint s . rest)
    (string-append
      (wrap (apply string-append (make-colour rest)))
      s (reset)))




  )
