
(library (talikko commands update)
  (export update
          update-source-tree)
  (import
    (scheme base)
    (scheme file)
    (scheme write)
    (only (srfi :13 strings)
          string-join)
    (mosh process)
    (mosh file)
    (except (mosh)
            read-line)
    (loitsu process))

  (begin

    (define(update)
      (cond
        ((file-exists? "/usr/ports/.git")
         (set-current-directory! "/usr/ports")
         (format #t "~a\n" (display "updating ports tree" ))
         (call-process "sudo git pull"))
        ((file-exists? "/usr/ports/.svn")
         (set-current-directory! "/usr/ports")
         (format #t "~a\n" (display "updating ports tree" ))
         (call-process "sudo svn up /usr/ports"))
        (else
          (format #t "~a\n" (display "Get ports tree" ))
          (call-process (string-join '("svn" "checkout" "-q" "http://svn.freebsd.org/ports/head" "/usr/ports"))))))

    (define (update-source-tree)
      (cond
        ((file-exists? "/usr/src")
         (format #t "~a\n" (display "update source tree" ))
         (set-current-directory! "/usr/src")
         (cond
           ((file-exists? "/usr/src/.git")
            (call-process "sudo git pull"))
           ((file-exists? "/usr/src/.svn")
            (let ((out (process-output->string "sudo svn up /usr/src")))
              (format #t "~a\n" out)))))
        (else
          (format #t "~a\n" (display "cloning source tree from svn" ))
          (call-process "svn co -q http://svn.freebsd.org/base/head /usr/src")))))

  ; }}}




  )
