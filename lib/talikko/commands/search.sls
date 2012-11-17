

(library (talikko commands search)
  (export
    search)
  (import
    (scheme base)
    (scheme file)
    (scheme write)
    (only (srfi :1 lists)
          last
          filter
          )
    (only (srfi :13 strings)
          string-contains-ci
          string-join)
    (except (mosh)
            read-line)
    (talikko colour)
    (loitsu file)
    (loitsu process)
    )

  (begin

    (define index-file
      (let  ((version (car (string-split (process-output->string "uname -r")
                                         #\.))))
        (string-append "/usr/ports/INDEX-" version)))

    (define (search args)
      (let ((package (caddr args)))
        (print
          (string-append
            "=> "
            "Searching "
            package))
        (let ((found-list (find-package package)))
          (for-each
            (lambda (x)
              (let ((name (car (string-split (car x) #\-)))
                    (version (cadr (string-split (car x) #\-)))
                    (category (last (string-split (path-dirname (cadr x))
                                                  #\/)))
                    (desc (cadddr x)))
                (display
                  (string-append
                    " "
                    category
                    "/"
                    name))
                (print
                  (string-append " [" version "]"))
                (print
                  (string-append "    " desc))
                ))
            found-list))))

    (define (find-package package)
      (let ((index-list (map (lambda (s) (string-split s #\|))
                             (file->string-list index-file))))
        (filter (lambda (x)
                  (or (string-contains-ci (car x) package)
                      (string-contains-ci (cadr x) package)
                      (string-contains-ci (cadddr x) package)))
                index-list)))

    ))
