(library (pikkukivi cli)
    (export
      runner)
  (import
    (silta base)
    (loitsu cli)
    (pikkukivi commands))

  (begin

    (define (runner args)
      (match-short-command (cadr args)
        ("ascii-taide"
         (ascii-taide args))
        ("mount-nfs"
         (mount-nfs args))
        ("print-path"
         (print-path args))
        ("futaba"
         (futaba args))
        ("yotsuba"
         (yotsuba args))
        ("pahvi"
         (pahvi args))
        ("tosixel"
         (tosixel args))
        ("kuva"
         (kuva args))
        ("uname"
         (uname args))
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
        ("gsp"
         (gsp args))))

    ))
