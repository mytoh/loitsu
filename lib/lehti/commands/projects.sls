(library (lehti commands projects)
    (export
      projects)
  (import
    (except (rnrs)
            remove)
    (only (srfi :1)
          remove)
    (lehti env)
    (lehti base)
    (lehti util)
    )

  (begin

    (define (remove-dot-directory lst)
      (remove
          (lambda (x)
            (equal? (string-ref x 0) #\.))
        lst))

    (define (projects-list)
      (cond
          ((file-exists? (*lehti-projects-repository-directory*))
           (let ((lst (remove-dot-directory
                       (directory-list2 (*lehti-projects-repository-directory*)))))
             (print (paint "lehti projects" 44))
             (for-each print lst)))))

    (define (projects)
      (projects-list))

    ))
