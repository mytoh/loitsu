
(library (loitsu file)
  (export
    build-path
    make-directory*
    path-extension
    file->string-list
    file-dirname)
  (import
    (scheme base)
    (scheme file)
    (scheme case-lambda)
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
    (mosh file))

  (begin

    (define (file-dirname path)
      (cond
        ((equal? "/" (string-take-right path 1))
         path)
        (else
          (string-join (drop-right (string-split path #\/)
                                   1)
                       "/"))))


    (define (file->string-list file)
      (call-with-input-file
        file
        (lambda (in)
          (port->string-list in))))

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
        (rest (string-join
                (map (lambda (s)
                       (if (equal? "/" (string-take-right s 1))
                         (string-trim-right s #\/)
                         s))
                     rest)
                "/"))))

    ))
