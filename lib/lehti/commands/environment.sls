

(library (lehti commands environment)
  (export
    environment)
  (import
    (except (rnrs)
            remove)
    (srfi :48)
    (only (srfi :1)
          remove)
    (only (srfi :13)
          string-join)
    (loitsu maali)
    (loitsu file)
    (loitsu util)
    (lehti lehspec)
    (lehti env))

  (begin

    (define (environment)
      (display
        (string-join
          `("Lehti Environment:"
            ,(subject (paint "INSTALLATION DIRECTORY" 109 ) ": "  (*lehti-directory*))
            ,(subject (paint "LEHTI BIN PATHS" 28) ": " (*lehti-bin-directory*))
            ,(subject (paint "LEHTI LOAD PATHS" 128) ":" )
            ,@(map
                (lambda (path)
                  (string-append
                    "     - " path))
                (make-load-path)))
          "\n"
          'suffix)))

    (define subject
      (partial string-append " - "))


    (define (make-load-path)
      (append
        (remove null?
                (map
                  (lambda (e)
                    (cond
                      ((file-exists? (build-path e "lib"))
                       (build-path e "lib"))
                      (else
                        '())))
                  (directory-list/path (*lehti-dist-directory* ))))))

    ))
