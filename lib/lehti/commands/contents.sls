
(library (lehti commands contents)
  (export
    contents)
  (import
    (scheme base)
    (scheme write)
    (srfi :48)
    (loitsu file)
    (lehti lehspec)
    (lehti env))

  (begin

    (define (contents args)
      (let* ((package (caddr args))
             (lehspec (package->lehspec package)))
        (for-each
          (lambda (p)
            (format #t "~a\n" p))
          (spec-files lehspec)) ))

    ))
