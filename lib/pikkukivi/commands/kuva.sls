
(library (pikkukivi commands kuva)
  (export
    kuva)
  (import
    (rnrs)
    (match)
    (loitsu process)
    (loitsu file)
    (loitsu archive)
    )

  (begin

    (define (open-archive file)
      (let ((tmp-dir (build-path (temporary-directory)
                                 "kuva" (path-basename
                                          (path-sans-extension file)))))
        (cond
          ((file-exists? tmp-dir)
           (run-command `(feh -r -Z -F ,tmp-dir)))
          (else
            (make-directory* tmp-dir)
            (extract-archive file tmp-dir)
            (run-command `(feh -F -Z -r -q ,tmp-dir))
            (remove-directory* tmp-dir)))))

    (define (open-directory dir)
      (run-command `(feh -Z -r -F ,dir)))

    (define (kuva args)
      (match (caddr args)
        ((? file-directory? dir)
         (open-directory dir))
        ((? file-archive? file)
         (open-archive file))
        ((? file-regular? file)
         (run-command `(feh -Z -F  -q --start-at
                            ,file
                            ,(path-dirname file))))))

    ))
