
(library (loitsu file)
  (export
    build-path
    make-directory*
    remove-directory*
    remove-file
    copy-file
    path-extension
    path-sans-extension
    path-swap-extension
    path-dirname
    path-basename
    path-absolute?
    directory-list2
    directory-list/path
    directory-empty?
    file->string-list
    file->sexp-list
    home-directory

    file-exists?
    create-symbolic-link
    directory-list
    file-directory?
    set-current-directory!
    current-directory
    create-directory
    delete-directory
    )
  (import
    (scheme base)
    (scheme file)
    (scheme case-lambda)
    (scheme read)
    (scheme write)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-take
          string-take-right)
    (only (srfi :1 lists)
          remove
          last
          take-right
          drop-right)
    (srfi :98)
    (except (mosh)
            read-line)
    (loitsu port)
    (kirjain)
    (only (mosh file)
          create-symbolic-link
          file-symbolic-link?
          file-regular?
          delete-directory
          directory-list
          file-directory?
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



    ;; function from gauche file.util
    (define (make-directory* dir)
      (letrec ((rec (lambda (p)
                      (if (file-exists? p)
                        (unless (file-directory? p)
                          (error "non-directory ~s is found while creating a directory ~s"))
                        (let ((d (path-dirname p)))
                          (rec d)
                          (unless (equal? (path-basename p) ".") ; omit the last component in "/a/b/c/."
                            (%make-directory p)))))))
        (rec (string-trim-right dir #\/))))

    (define (%make-directory dir)
      (unless (or (equal? "." dir)
                  (equal? "" dir))
        (create-directory dir)))

    ;; rm -rf
    (define (remove-directory* path)
      (cond
        ((file-regular? path)
         (remove-file path))
        ((file-directory? path)
         (cond
           ((directory-empty? path)
            (delete-directory path))
           (else
             (for-each
               (lambda (f)
                 (remove-directory* f))
               (directory-list/path path))
             (remove-directory* path))))))

    (define (directory-empty? dir)
      (cond
        ((file-directory? dir)
         (if (null? (directory-list2 dir))
           #t #f))
        (else
          (error "not a directory"))))

    (define (directory-list2 path)
      (remove
        (lambda (s) (or (equal? "." s)
                        (equal? ".." s)))
        (directory-list path)))

    (define (directory-list/path path)
      (map
        (lambda (p) (build-path path p))
        (directory-list2 path)))

    (define (remove-file path)
      (cond
        ((or (file-regular? path)
             (file-symbolic-link? path))
         (delete-directory path))))

    (define (copy-file src dest)
      (let ((pin (open-input-file src))
            (pout (open-output-file dest)))
        (let loop  ((in pin))
          (let ((l (read-char in)))
            (unless (eof-object? l)
              (write-char l pout)
              (flush-output-port pout)
              (loop in))))
        (close-input-port pin)
        (close-output-port pout)))


    (define (path-extension path)
      (let ((p (string-split path #\.)))
        (cond
          ((< 1 (length p))
           (last p))
          (else
            #f))))

    (define (path-absolute? path)
      (if (equal? "/" (string-take path 1))
        #t #f))

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

    (define (path-basename path)
      (cond
        ((equal? "/" path) "")
        ((equal? "" path) "")
        (else
          (let ((p (string-trim-right path #\/)))
            (car (take-right (string-split p #\/) 1))))))

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

    (define (home-directory)
      (get-environment-variable "HOME"))

    ))
