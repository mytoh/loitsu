(library (lehti commands reinstall)
    (export
      reinstall)
  (import
    (rnrs)
    (only (srfi :13)
          string-join)
    (lehti base)
    (lehti util)
    (lehti commands install)
    (lehti commands deinstall))

  (begin

    (define (reinstall args)
      (let ((packages (cddr args)))
        (ohei "reinstall packages...")
        (display (string-join packages))
        (newline)
        (for-each
            (lambda (p)
              (cond
                  ((package-installed? p)
                   (deinstall-package p)
                   (install-package p))
                (else
                    (install-package p))))
          packages))
      (ohei "finished"))

    ))
