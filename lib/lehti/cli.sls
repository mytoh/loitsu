(library (lehti cli)
    (export runner)
  (import
    (rnrs)
    (match)
    (lehti base)
    (prefix
      (lehti commands)
      commands.))

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
                   (commands.setup args))
                  ("install"
                   (commands.install args))
                  ("deinstall"
                   (commands.deinstall args))
                  ("rm"
                   (commands.deinstall args))
                  ("clean"
                   (commands.clean args))
                  ("reinstall"
                   (commands.reinstall args))
                  ("update"
                   (commands.update))
                  ("commands"
                   (commands.print-commands))
                  ("clone"
                   (commands.clone args))
                  ("contents"
                   (commands.contents args))
                  ("environment"
                   (commands.environment))
                  ("list"
                   (commands.list-packages))
                  ("completion"
                   (commands.completion args))
                  ("spec"
                   (commands.specification args))
                  ("search"
                   (commands.search args))
                  ("projects"
                   (commands.projects))))))

    ))
