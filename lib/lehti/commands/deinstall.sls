
(library (lehti commands deinstall)
  (export
    deinstall-package
    deinstall)
  (import
    (rnrs)
    (lehti base)
    (lehti util)
    (lehti env))

  (begin

    (define (deinstall args)
      (call-with-packages
        (cddr args)
        (lambda (p)
          (ohei "deinstall " p)
          (deinstall-package p))))

    (define (deinstall-package package)
      (cond
        ((package-installed? package)
         (if (file-exists? (build-path (*lehti-bin-directory*) package))
           (remove-directory* (build-path (*lehti-bin-directory*) package)))
         (if (file-symbolic-link? (build-path (*lehti-dist-directory*) package))
           (remove-file (build-path (*lehti-dist-directory*) package))
           (remove-directory* (build-path (*lehti-dist-directory*) package)))
         )))

    ))
