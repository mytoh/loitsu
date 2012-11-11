
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
        ("install"
         (install args))
        ))

    ))
