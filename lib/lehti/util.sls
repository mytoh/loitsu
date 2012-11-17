
(library (lehti util)
  (export
    package-installed?
    package-available?)
  (import
    (scheme base)
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



    ))
