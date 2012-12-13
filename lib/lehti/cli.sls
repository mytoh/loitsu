
(library (lehti cli)
  (export runner)
  (import
    (rnrs)
    (match)
    (loitsu cli)
    (lehti commands)
    )

  (begin

    (define (runner args)
      (match-short-command (cadr args)
        ("setup"
         (setup args))
        ("install"
         (install args))
        ("deinstall"
         (deinstall args))
        ("clean"
         (clean args))
        ("reinstall"
         (reinstall args))
        ("update"
         (update))
        ("command"
         (print-commands))
        ("clone"
         (clone args))
        ("contents"
         (contents args))
        ("env"
         (env))
        ("list"
         (list-packages))
        ("spec"
         (specification args))))

    ))
