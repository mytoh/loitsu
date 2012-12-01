
(library (pikkukivi cli)
  (export
    runner)
  (import
    (scheme base)
    (match)
    (pikkukivi commands)
    )

  (begin

    (define (runner args)
      (match (cadr args)
        ("ascii"
         (ascii-taide args))
        ))

    ))
