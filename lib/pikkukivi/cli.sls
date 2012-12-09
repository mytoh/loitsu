
(library (pikkukivi cli)
  (export
    runner)
  (import
    (rnrs)
    (match)
    (pikkukivi commands)
    )

  (begin

    (define (runner args)
      (match (cadr args)
        ("ascii"
         (ascii-taide args))
        ("mount-nfs"
         (mount-nfs args))
        ("print-path"
         (print-path args))
        ("futaba"
         (futaba args))
        ("tosixel"
         (tosixel args))
        ("mkd"
         (mkd args))
        ("starwars"
         (starwars args))
        ("jblive"
         (jblive))
        ("sumo"
         (sumo))
        ("sumo2"
         (sumo2))
        ("sumo3"
         (sumo3))
        ))

    ))
