
(library (loitsu file path)
  (export
    build-path
    path-extension
    path-sans-extension
    path-swap-extension
    path-dirname
    path-basename
    path-absolute?
    home-directory
    )
  (import
    (scheme base)
    (scheme case-lambda)
    (only (srfi :1 lists)
          any
          find
          fold
          fold-right
          remove
          last
          take-right
          drop-right)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-take
          string-take-right)
    (srfi :98)
    (loitsu string)
    )

  (begin

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

    (define (path-extension path)
      (let ((p (string-split path #\.)))
        (cond
          ((< 1 (length p))
           (last p))
          (else
            #f))))

    (define (path-sans-extension path)
      (let ((pt (string-split path #\.)))
        (cond
          ((< 1 (length pt))
           (string-join (drop-right pt 1) "."))
          ((eq? 1 (length pt))
           (car pt))
          (else
            #f))))

    (define (path-swap-extension path ext)
      (let ((pt (path-sans-extension path)))
        (string-append pt "." ext)))

    (define (path-dirname path)
      (cond
        ((equal? "" path) ".")
        ((equal? "/" path) "/")
        ((path-absolute? path)
         (let* ((p (string-trim-right path #\/)))
           (if (equal? 2 (length (string-split p #\/)))
             "/"
             (apply build-path (drop-right (string-split p #\/) 1)))))
        (else
          (let ((p (string-trim-right path #\/)))
            (apply build-path (drop-right (string-split p #\/)
                                          1))))))

    (define (home-directory)
      (get-environment-variable "HOME"))


    (define (path-absolute? path)
      (if (equal? "/" (string-take path 1))
        #t #f))

    (define (path-basename path)
      (cond
        ((equal? "/" path) "")
        ((equal? "" path) "")
        (else
          (let ((p (string-trim-right path #\/)))
            (car (take-right (string-split p #\/) 1))))))

    ))
