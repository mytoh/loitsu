
(library (lehti cli)
  (export runnur)
  (import
    (scheme base)
    (match)
    (lehti commands)
    )

  (begin

    (define (runnur args)
      (match (cadr args)
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
         (specification args))
        ))

    ))
