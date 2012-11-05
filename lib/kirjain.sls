
(library (kirjain)
  (export
    b f  o t)
  (import
    (rnrs)
    (srfi :19))

  (define (b x)
    (display "")
    (newline)
    x)


  (define (o x)
    (write x)
    (newline)
    x)


  (define (f x . name)
    (call-with-output-file
      (if (null? name) "log" name)
      (lambda (in)
        (write x in)))
    x)

  (define (t x)
    (write (date->string (current-date)))
    (newline)
    x)


  ; (define (l x)
  ;   (log-open #t)
  ;   (log-format "~s" x)
  ;   x)
  )

