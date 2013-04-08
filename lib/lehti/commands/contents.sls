(library (lehti commands contents)
    (export
      contents)
  (import
    (rnrs)
    (srfi :48)
    (lehti base)
    (lehti lehspec)
    (lehti env))

  (begin

    (define (contents args)
      (let* ((package (caddr args))
             (lehspec (package->lehspec package)))
        (for-each
            (lambda (p)
              (format #t "~a\n" p))
          (spec.files lehspec))))

    ))
