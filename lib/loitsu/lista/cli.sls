(library (loitsu lista cli)
    (export
      runner)
  (import
    (silta base)
    (silta file)
    (loitsu match)
    (loitsu file)
    (loitsu lista))

  (begin

    (define (runner args)
      (match (cadr args)
        ("long"
         (list-file-long args))
        ("list"
         (list-file args))
        (else
            (list-file args))))

    ))
