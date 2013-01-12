
(library (lehti commands update)
  (export
    update)
  (import
    (rnrs)
    (lehti env)
    (lehti base)
    )

  (begin

    (define (update)
      (set-current-directory! (*lehti-directory*))
      (run-command '(git pull)))
    ))


