
(library (lehti commands clean)
  (export
    clean)
  (import
    (rnrs)
    (lehti base)
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
