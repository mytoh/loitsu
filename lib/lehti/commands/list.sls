
(library (lehti commands list)
  (export
    list-packages)
  (import
    (rnrs)
    (srfi :48)
    (loitsu file)
    (lehti lehspec)
    (lehti env))

  (begin
    (define (list-packages)
      (for-each
        (lambda (p)
          (format #t "~a\n" p))
        (map
          (lambda (path)
            (path-sans-extension path))
          (directory-list2 (build-path (*lehti-directory* ) "dist" )))))

    ))

