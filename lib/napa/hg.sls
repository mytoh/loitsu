
(library (napa hg)
  (export hg)
  (import
    (scheme base)
    (match)
    (only (srfi :13 strings)
          string-join)
    (mosh process))

  (begin
    (define (hg args)
      (cond
        ((null? args)
         (call-process "hg"))
        (else
          (match (car args)
            ("st"
             (call-process (string-join '("hg" "status"))))
            (_
              (call-process (string-join `("hg" ,@args))))))))) 




  )

