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
    (match)
    (lehti env)
    (lehti base))

  (begin

    (define (all-packages)
      (let ((package-list (remove-dot-directory
                           (directory-list2 (*lehti-projects-repository-directory*)))))
        (for-each
            (lambda (p) (display p)
                    (newline))
          package-list)))

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
              (format #t "~a not found!" package)
            (newline)))))

    (define (search args)
      (match (cddr args)
        (()
         (all-packages))
        (else
            (if (file-exists? (*lehti-projects-repository-directory*))
              (search-package (caddr args))
              (display "please install lehti")))))

    ))
