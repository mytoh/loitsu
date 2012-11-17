
(library (lehti commands clean)
  (export
    clean)
  (import
    (scheme base)
    (scheme write)
    (loitsu file)
    (lehti env))

  (begin

    (define (clean args)
      (cond
        ((null? (cddr args))
         (for-each
           remove-directory*
           (directory-list/path (*lehti-cache-directory*))))
        ))

    ))
