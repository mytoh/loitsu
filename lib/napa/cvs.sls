

(library (napa cvs)
  (export cvs)
  (import
    (rnrs)
    (match)
    (only (srfi :13 strings)
      string-join)
    (mosh process))

(define (cvs args)
  (cond
    ((null? args)
    (call-process "cvs"))
   (else
     (match (car args)
      ("up"
       (call-process (string-join '("cvs" "update"))))
      (_
        (call-process (string-join `("cvs" ,@args))))))))




)

