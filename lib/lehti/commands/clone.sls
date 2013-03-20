(library (lehti commands clone)
    (export
      clone)
  (import
    (rnrs)
    (srfi :48)
    (lehti env)
    (lehti util)
    (lehti scm)
    (lehti base)
    )

  (begin



    (define (remove-dot-directory lst)
      (remove
          (lambda (x)
            (equal? (string-ref x 0) #\.))
        lst))


    (define (find-package package)
      (let ((package-list (remove-dot-directory
                           (directory-list2 (*lehti-projects-repository-directory*)))))
        (if (member package package-list)
          #t #f)))

    (define (help)
      (display "lehti clone"))

    (define (clone-from-cvs package)
      (let* ((def (car (file->sexp-list (build-path (*lehti-projects-repository-directory*)
                                                    package "source.sps"))))
             (type (car def))
             (url (cadr def)))

        (cond
            ((url-is-git? url)
             (format #t "clone repository ~a from ~a\n" package url)
             (run-command `(git clone -q ,url ,package)))
          (else
              (format #t "~a is not supported" url)))))

    (define (clone-package package)
      (cond
          ((find-package package)
           (clone-from-cvs package))
        (else
            (format #t "package ~a not found\n" package))))

    (define (clone args)
      (let ((package (cddr args)))
        (if (not (null? package))
          (clone-package (car package))
          (help))))
    ))
