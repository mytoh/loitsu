
(library (lehti cli)
    (export runner)
  (import
    (rnrs)
    (match)
    (lehti base)
    (lehti commands))

  (begin

    (define (runner args)
      (match-short-command (cadr args)
        ("setup"
         (setup args))
        ("install"
         (install args))
        ("deinstall"
         (deinstall args))
        ("remove"
         (deinstall args))
        ("rm"
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
        ("environment"
         (environment))
        ("list"
         (list-packages))
        ("completion"
         (completion args))
        ("spec"
         (specification args))))

    ))
