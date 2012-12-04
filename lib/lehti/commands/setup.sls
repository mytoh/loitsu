

(library (lehti commands setup)
  (export setup)
  (import
    (except (rnrs)
            remove)  
    (only (srfi :1)
          remove)
    (only (srfi :13)
          string-join)
    (match)
    (loitsu file)
    (lehti env)
    )

  (begin
    (define (make-load-path)
      (append
        (remove null?
                (map (lambda (e)
                       (cond
                         ((file-exists? (build-path e "lib"))
                          (build-path e "lib"))
                         (else
                           '())))
                     (directory-list/path (*lehti-dist-directory*))))))


    (define (list->path lst)
      (cond
        ((= (length lst) 1)
         (car lst))
        (else
          (string-join lst ":"))))

    (define (setup args)
      (match (caddr args)
        ("load-path"
         (display (list->path (make-load-path))))))

    ))



