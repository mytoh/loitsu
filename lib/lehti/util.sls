
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
      (if (file-directory? (build-path (*lehti-dist-directory* ) package))
        #t #f))

    (define (package-available? package)
      (if (file-exists? (build-path (*lehti-leh-file-directory* )
                                    (path-swap-extension package
                                                         "leh")))
        #t #f))

    (define (call-with-packages package-list proc)
      (for-each
        (lambda (p)
          (proc p))
        package-list))



    ))
