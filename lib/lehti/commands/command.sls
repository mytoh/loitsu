
(library (lehti commands command)
  (export
    print-commands)
  (import
    (rnrs)
    (lehti env)
    (srfi :48)
    (lehti base)
    )

  (begin

    (define (print-commands)
      (for-each
        (lambda (c)
          (format #t "~a\n" c))
        (map (lambda (path) (path-sans-extension path))
             (directory-list2 (build-path (*lehti-directory* ) "lib/lehti/commands" )))))

    ))





