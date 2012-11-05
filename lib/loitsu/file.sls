
(library (loitsu file)
  (export
    file-dirname)
  (import
    (scheme base)
    (only (srfi :13 strings)
      string-join
      string-take-right)
    (only (srfi :1 lists)
      drop-right)
    (except (mosh)
      read-line)  
    (mosh file))

  (define (file-dirname path)
    (cond
      ((equal? "/" (string-take-right path 1))
       path)
      (else
        (string-join (drop-right (string-split path #\/)
                                 1)
        "/"))))
  )
