
(library (piha cli)
    (export
      runner)
  (import
    (silta base)
    (silta write)
    (loitsu cli)
    (prefix (piha commands)
            command:))

  (begin

    (define (runner args)
      (match-short-command (cadr args)
        ("generate"
         (command:generate (cddr args)))))

    ))
