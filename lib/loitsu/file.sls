
(library (loitsu file)
  (export
    build-path
    make-directory*
    path-extension
    path-sans-extension
    file->string-list
    file->sexp-list
    path-dirname

    set-current-directory!
    current-directory
    )
  (import
    (scheme base)
    (scheme file)
    (scheme case-lambda)
    (scheme read)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-take-right)
    (only (srfi :1 lists)
          last
          drop-right)
    (except (mosh)
            read-line)
    (loitsu port)
    (kirjain)
    (only (mosh file)
          create-directory))

  (begin


    (define (file->string-list file)
      (call-with-input-file
        file
        (lambda (in)
          (port->string-list in))))

    (define (file->sexp-list file)
      (call-with-input-file
        file
        (lambda (in)
          (port->sexp-list in))))



    (define (make-directory* path)
      (if (not (file-exists? path))
        (create-directory path)))



    (define (path-extension path)
      (let ((p (string-split path #\.)))
        (cond
          ((< 1 (length p))
           (last p))
          (else
            #f))))

    (define build-path
      (case-lambda
        ((path) path)
        (paths (string-join
                 (map (lambda (s)
                        (if (equal? "" s)
                          ""
                          (if (equal? "/" (string-take-right s 1))
                            (string-trim-right s #\/)
                            s)))
                      paths)
                 "/"))))

    (define (path-dirname path)
      (cond
        ((equal? "/" (string-take-right path 1))
         path)
        (else
          (apply build-path (drop-right (string-split path #\/)
                                        1)))))

    (define (path-sans-extension path)
      (let ((pt (string-split path #\.)))
        (cond
          ((< 1 (length pt))
           (string-join (drop-right pt 1) "."))
          ((eq? 1 (length pt))
           pt)
          (else
            #f))
        ))


    ))
