
(library (lehti util)
  (export
    call-with-packages
    package-installed?
    package-available?)
  (import
    (rnrs)
    (loitsu file)
    (lehti env))

  (begin


    (define (package-installed? package)
      (or (file-directory? (build-path (*lehti-dist-directory* ) package))))

    (define (package-available? package)
      (or (file-exists? (build-path (*lehti-leh-file-directory* )
                                    (path-swap-extension package
                                                         "leh")))))

    (define (call-with-packages package-list proc)
      (for-each
        (lambda (p)
          (proc p))
        package-list))

    ))
