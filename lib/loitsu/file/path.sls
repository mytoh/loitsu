
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
    (rnrs)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-take
          string-take-right)
    (only (srfi :1 lists)
          take-right
          drop-right
          last)
    (srfi :98 os-environment-variables)
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
                            (remove-trailing-slash s)
                            s)))
                      paths)
                 "/"))))

    (define (path-extension path)
      (let ((p (split-dot path)))
        (cond
          ((< 1 (length p))
           (last p))
          (else
            #f))))

    (define (path-sans-extension path)
      (let ((pt (split-dot path)))
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
         (let* ((p (remove-trailing-slash path)))
           (if (equal? 2 (length (split-slash p)))
             "/"
             (apply build-path (drop-right (split-slash p ) 1)))))
        (else
          (let ((p (remove-trailing-slash path)))
            (apply build-path (drop-right (split-slash p)
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
          (let ((p (remove-trailing-slash path)))
            (car (take-right (split-slash p ) 1))))))

    ;; internal functions

    (define (split-dot path)
      (string-split path #\.))

    (define (split-slash path)
      (string-split path #\/))

    (define (remove-trailing-slash path)
      (string-trim-right path #\/))

    ))
