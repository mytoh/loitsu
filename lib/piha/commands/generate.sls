
(library (piha commands generate)
    (export
      generate)
  (import
    (silta base)
    (silta write)
    (srfi :48 intermediate-format-strings)
    (loitsu file)
    (loitsu maali))

  (begin

    ;; utility
    (define (spit-file path content)
      (format #t "\t created ~a" (paint path 39))
      (newline)
      (spit path content))

    (define (generate-library root)
      (let ((lib-root (build-path root "lib")))
        (make-directory* lib-root)
        (generate-library-files root)))

    (define (generate-library-files root)
      (spit-file (build-path root "lib" "cli.sls")
                 (content-lib-cli root)))

    (define (content-lib-cli root)
      (string-append
          "(library (" root " cli)\n"
          "(export runner)\n"
          "(import (silta base))\n"
          "(begin\n"
          "(define (runner args)\n"
          "(cadr args))\n"
          "))\n"))

    (define (generate-main-directory root)
      (cond
          ((file-exists? root)
           (display "directory exists!")
           (newline))
        (else
            (make-directory* root))))

    (define (generate-all root)
      (generate-main-directory root)
      (generate-library root))

    (define (generate args)
      (let ((root (car args)))
        (generate-all root)))

    ))
