
(library (lehti commands deinstall)
  (export
    deinstall)
  (import
    (scheme base)
    (scheme write)
    (loitsu file)
    (lehti util)
    (lehti env))

  (begin

    (define (deinstall args)
      (cond
        ((package-installed? (caddr args))
         (let ((p (caddr args)))
           (if (file-exists? (build-path (*lehti-bin-directory*) p))
             (remove-directory* (build-path (*lehti-bin-directory*) p)))
           (remove-directory* (build-path (*lehti-dist-directory*) p))))))

    ))
