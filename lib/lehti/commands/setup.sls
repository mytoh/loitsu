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
    (lehti base)
    (lehti env))

  (begin

    (define (clean-list lst)
      (remove null? lst))

    (define (make-load-path)
      (append
          (clean-list
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

    (define (list->path/fish lst)
      (cond
          ((= (length lst) 1)
           (car lst))
        (else
            (string-join lst ":"))))

    (define (setup args)
      (match (cddr args)
        (("load-path")
         (display (list->path (make-load-path))))
        (("load-path" "fish")
         (display (list->path/fish (make-load-path))))))

    ))
