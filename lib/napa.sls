
(library (napa)
  (export
    git
    directory-git?
    svn
    hg
    cvs
    darcs
    )
  (import
    (scheme base)
    (napa git)
    (napa svn)
    (napa hg)
    (napa cvs)
    (napa darcs))
)

