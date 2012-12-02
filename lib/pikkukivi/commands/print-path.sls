
(library (pikkukivi commands print-path)
  (export
    print-path)
  (import
    (scheme base)
    (scheme write)
    (srfi :48)
    (srfi :98)
    (match)
    (loitsu string)
    (loitsu file))

  (begin

    (define (print-path args)
      (match (cadr args)
        ((env)
         (display env)
         (newline)
         (cond
           ((get-environment-variable env)
            (for-each (lambda (s) (format #t "~a\n" s))
                      (split-env (get-environment-variable env))))
           (else env)))
        (_
          (for-each (lambda (s) (format #t "~a\n" s))
                    (split-env (get-environment-variable "PATH"))))))

    (define (split-env env)
      (string-split env #\:))

    ))

