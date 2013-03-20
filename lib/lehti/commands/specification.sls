(library (lehti commands specification)
    (export
      specification)
  (import
    (rnrs)
    (srfi :48)
    (only (srfi :13)
          string-join)
    (lehti base)
    (lehti lehspec)
    (lehti env))

  (begin

    (define (specification args)
      (let* ((package (caddr args))
             (lehspec (package->lehspec package)))
        (format #t "~a ~a\n~a ~a\n~a\n~a\n"
                (paint "name:" 39)
                (spec-name lehspec)
                (paint "description:" 29)
                (spec-description lehspec)
                (paint "files:" 66)
                (string-join
                    (map (lambda (s)
                           (string-append "  - " s))
                      (spec-files lehspec))
                  "\n"))))

    ))
