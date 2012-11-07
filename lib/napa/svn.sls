
(library (napa svn)
  (export svn)
  (import
    (scheme base)
    (match)
    (only (srfi :13 strings)
          string-join)
    (mosh process))

  (begin

    (define (svn args)
      (cond
        ((null? args)
         (call-process "svn"))
        (else
          (match  (car args)
            ("st"
             (call-process (string-join '("svn" "status"))))
            (_
              (call-process (string-join `("svn" ,@args)))))))))

  )

