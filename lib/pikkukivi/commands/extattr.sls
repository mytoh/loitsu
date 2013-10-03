(library (pikkukivi commands extattr)
    (export
      extattr)
  (import
    (silta base)
    (silta write)
    (only (srfi :13 strings)
          string-tokenize)
    (srfi :48)
    (loitsu match)
    (loitsu process))

  (begin

    (define (get-extattr-command name file)
      (run-command `(getextattr -q user ,name ,file)))

    (define (get-extattr name file)
      (let ((value (get-extattr-command name file)))
        (if (not (string=? "" value))
          (format #t "~a -> ~a" name value))))


    (define (ls-extattr-command file)
      (run-command `(lsextattr -q user ,file)))

    (define (ls-extattr file)
      (let ((attrs (ls-extattr-command file)))
        (for-each
            (lambda (s)
              (get-extattr s file))
          (string-tokenize attrs))))

    (define (rm-extattr-command name file)
      (run-command `(rmextattr -q user ,name ,file)))

    (define (rm-extattr name file)
      (rm-extattr-command name file))

    (define (set-extattr-command name value file)
      (run-command `(setextattr -q user ,name ,value ,file)))

    (define (set-extattr name value file)
      (set-extattr-command name value file))

    (define (extattr args)
      (match (cddr args)
        (("get" name file)
         (get-extattr name file))
        (("ls" file)
         (ls-extattr file))
        (("rm" name file)
         (rm-extattr name file))
        (("set" name value file)
         (set-extattr name value file))
        ))
    ))
