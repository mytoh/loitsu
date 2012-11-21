

(library (lehti commands reinstall)
  (export
    reinstall)
  (import
    (scheme base)
    (scheme write)
    (only (srfi :13)
          string-join)
    (loitsu file)
    (loitsu message)
    (loitsu maali)
    (lehti util)
    (lehti commands install)
    (lehti commands deinstall)
    )

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
             (display (paint ":: deinstall "))
             (display p)
             (newline)
               (deinstall-package p)
             (display (paint ":: install "))
             (display p)
             (newline)
               (install-package p))))
            packages)))

    ))
