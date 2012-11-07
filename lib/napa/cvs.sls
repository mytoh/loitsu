

(library (napa cvs)
  (export cvs)
  (import
    (scheme base)
    (match)
    (only (srfi :13 strings)
          string-join)
    (mosh process))

  (begin

    (define (cvs args)
      (cond
        ((null? args)
         (call-process "cvs"))
        (else
          (match (car args)
            ("up"
             (call-process (string-join '("cvs" "update"))))
            (_
              (call-process (string-join `("cvs" ,@args))))))))) 




  )

