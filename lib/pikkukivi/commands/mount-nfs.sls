
(library (pikkukivi commands mount-nfs)
  (export mount-nfs)
  (import
    (rnrs)
    (only (srfi :13 strings)
          string-join)
    (match)
    (mosh process))

  (begin

    (define (mount-nfs args)
      (let ((disk (caddr args))
            (user (cadddr args)))
      (match disk
        ; commands
        ("mypassport"
         (mount-mypassport))
        ("deskstar"
         (mount-deskstar))
        ("quatre"
         (mount-quatre user))
        ("all"
         (mount-mypassport)
         (mount-deskstar)
         (mount-quatre user)))))

    (define mount
      (lambda (src dest)
        (display (string-append "mounting " src))
        (newline)
        (call-process (string-join
                        `("sudo" "mount" "-v" ,src ,dest)))))

    (define (mount-mypassport)
      (mount "quatrevingtdix:/Volumes/MyPassport"
             "/nfs/mypassport"))

    (define (mount-deskstar)
      (mount "quatrevingtdix:/Volumes/Deskstar"
             "/nfs/deskstar"))

    (define (mount-quatre user)
      (mount (string-append "quatrevingtdix:/Users/" user)
             "/nfs/quatre"))

    ) )

;; vim:filetype=scheme
