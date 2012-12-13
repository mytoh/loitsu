
(library (pikkukivi commands print-path)
  (export
    print-path)
  (import
    (rnrs)
    (srfi :48)
    (srfi :98)
    (match)
    (irregex)
    (loitsu maali)
    (loitsu string)
    (loitsu file))

  (begin

    (define (print-path args)
      (match (cddr args)
        ((env)
         (display env)
         (newline)
         (cond
           ((get-environment-variable env)
            (for-each (lambda (s) (format #t "~a\n" (colour-paths s)))
                      (split-env (get-environment-variable env))))
           (else env)))
        (_
          (for-each (lambda (s) (format #t "~a\n" (colour-paths s)))
                    (split-env (get-environment-variable "PATH"))))))

    (define (colour-paths path)
      (apply build-path
             (map
               (lambda (p)
                 (colour-path p))
               (string-split path #\/))))

    (define (colour-path path)
      (match path
        ("usr" (paint path 2))
        ("bin" (paint path 4))
        ("opt" (paint path 6))
        ("sbin" (paint path 3))
        ("local" (paint path 9))
        ("lib" (paint path 7))
        ("var" (paint path 8))
        ("home" (paint path 5))
        (_ path)))

    (define (split-env env)
      (string-split env #\:))

    ))

