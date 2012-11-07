
(library (talikko commands update)
  (export update
    update-source-tree)
  (import
    (scheme base)
    (scheme file)
    (only (srfi :13 strings)
      string-join)
    (mosh process)
    (mosh file)
    (except (mosh)
      read-line)
    (loitsu process)
    (maali))

  (begin
  (define(update)
    (cond
      ((file-exists? "/usr/ports/.git")
       (set-current-directory! "/usr/ports")
       (format #t "~a\n" (paint "updating ports tree" 109))
       (call-process "sudo git pull"))
      ((file-exists? "/usr/ports/.svn")
       (set-current-directory! "/usr/ports")
       (format #t "~a\n" (paint "updating ports tree" 109))
       (call-process "sudo svn up /usr/ports"))
      (else
        (format #t "~a\n" (paint "Get ports tree" ))
        (call-process (string-join '("svn" "checkout" "-q" "http://svn.freebsd.org/ports/head" "/usr/ports")))))) 

  (define (update-source-tree)
    (cond
      ((file-exists? "/usr/src")
       (format #t "~a\n" (paint "update source tree" 129))
       (set-current-directory! "/usr/src")
       (cond
         ((file-exists? "/usr/src/.git")
          (call-process "sudo git pull"))
         ((file-exists? "/usr/src/.svn")
          (let ((out (process-output->string "sudo svn up /usr/src")))
            (format #t "~a\n" out)))))
      (else
        (format #t "~a\n" (paint "cloning source tree from svn" 93))
        (call-process "svn co -q http://svn.freebsd.org/base/head /usr/src")))
    )) 

  ; }}}




  )
