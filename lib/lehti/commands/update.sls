
(library (lehti commands update)
  (export
    update)
  (import
    (rnrs)
    (lehti env)
    (loitsu file)
    (loitsu process))

  (begin

    (define (update)
      (set-current-directory! (*lehti-directory*))
      (run-command '(git pull)))
    ))


