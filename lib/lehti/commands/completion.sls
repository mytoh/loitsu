
(library (lehti commands completion)
  (export
    completion)
  (import
    (rnrs)
    (only (srfi :13)
          string-join)
    )

  (begin

    (define commands
      '("environment"
        "completion"
        "specification"
        "clean"
        "contents"
        "clone"
        "print-commands"
        "list-packages"
        "setup"
        "update"
        "deinstall"
        "reinstall"
        "install"
        ))

    (define (completion args)
      (let ((shell (cddr args)))
        (cond
          ((null? shell)
           "bash")
          ((string=? "tcsh" (car shell))
           (display (string-append "complete lehti \"p/1/("
                                   (string-join commands)
                                   ")/\""))))))

    ))
