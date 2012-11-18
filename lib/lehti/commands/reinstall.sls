

(library (lehti commands reinstall)
  (export
    reinstall)
  (import
    (scheme base)
    (scheme write)
    (loitsu file)
    (lehti util)
    (lehti commands install)
    (lehti commands deinstall)
    )

  (begin

    (define (reinstall args)
      (cond
        ((package-installed? (cadr args))
         (let ((p (cadr args)))
           (deinstall p)
           (install p)))))

    ))
