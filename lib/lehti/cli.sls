(library (lehti cli)
    (export runner)
  (import
    (rnrs)
    (match)
    (lehti base)
    (lehti commands))

  (begin

    (define (help)
      (display
          "lehti <command> <args>

commands:
   install
   deinstall remove rm
   reinstall
   clean
   update
   clone
   contents
   environment
   list
   spec
")
      (newline))

    (define (runner args)
      (cond ((< (length args) 2)
             (help))
        (else
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
              ("commands"
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
               (specification args))
              ("search"
               (search args))
              ("projects"
               (projects))))))

    ))
