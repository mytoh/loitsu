
(library (loitsu file)
  (export
    file->string-list
    file-dirname)
  (import
    (scheme base)
    (scheme file)
    (only (srfi :13 strings)
      string-join
      string-take-right)
    (only (srfi :1 lists)
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

  ))
