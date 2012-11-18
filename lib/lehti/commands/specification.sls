
(library (lehti commands specification)
  (export
    specification)
  (import
    (scheme base)
    (scheme write)
    (srfi :48)
    (only (srfi :13)
          string-join)
    (loitsu file)
    (lehti lehspec)
    (lehti env))

  (begin

    (define (specification args)
      (let* ((package (caddr args))
             (lehspec (package->lehspec package)))
        (format #t "name: ~a\ndescription: ~a\nfiles:\n~a\n"
                (spec-name lehspec)
                (spec-description lehspec)
                (string-join
                  (map (lambda (s)
                         (string-append "  - " s))
                       (spec-files lehspec))
                  "\n"))))

    ))
