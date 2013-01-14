
(library (lehti util)
  (export
    call-with-packages
    package-installed?
    )
  (import
    (rnrs)
    (lehti base)
    (lehti env))

  (begin


    (define (package-installed? package)
      (or (file-directory? (build-path (*lehti-dist-directory* ) package))))


    (define (call-with-packages package-list proc)
      (for-each
        (lambda (p)
          (proc p))
        package-list))
    ))
