
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
        ((or "install" "i")
         (install args))
        ((or "deinstall" "rm")
         (deinstall args))
        ("clean"
         (clean args))
        ((or "reinstall" "re")
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
