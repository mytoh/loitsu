(library (lehti commands search)
    (export
      search)
  (import
    (except (rnrs)
            remove)
    (only (srfi :1)
          remove)
    (only (srfi :13)
          string-ref)
    (srfi :48)
    (lehti env)
    (lehti base)
    )

  (begin

    (define (help)
      (display "lehti search <package>")
      (newline))

    (define (remove-dot-directory lst)
      (remove
          (lambda (x)
            (equal? (string-ref x 0) #\.))
        lst))

    (define (search-package package)
      (let ((package-list (remove-dot-directory
                           (directory-list2 (*lehti-projects-repository-directory*)))))
        (cond
            ((member package package-list)
             (display package)
             (newline))
          (else
              (format "~a not found!" package)))))

    (define (search args)
      (cond
          ((< (length args) 3)
           (help))
        ((file-exists? (*lehti-projects-repository-directory*))
         (search-package (caddr args)))
        (else "test")))

    ))
