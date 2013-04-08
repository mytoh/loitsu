(library (loitsu file)
    (export
      make-directory*
      remove-directory*
      remove-file
      copy-file
      directory-list2
      directory-list/path
      directory-list-rec
      directory-empty?
      file->string-list
      file->sexp-list
      file->string
      find-file-in-paths
      temporary-directory

      ;; path
      build-path
      path-extension
      path-sans-extension
      path-swap-extension
      path-dirname
      path-basename
      path-absolute?
      home-directory
      slurp
      spit

      file-exists?
      create-symbolic-link
      directory-list
      file-directory?
      file-regular?
      file-symbolic-link?
      file-executable?
      file-readable?
      file-writable?
      file-stat-mtime
      file-stat-ctime
      set-current-directory!
      current-directory
      create-directory
      delete-directory
      file-size-in-bytes)
  (import
    (except (rnrs)
            remove
            find)
    (srfi :8 receive)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-take
          string-take-right)
    (only (srfi :1 lists)
          any
          fold
          find
          remove
          last
          take-right
          drop-right)
    (srfi :39 parameters)
    (srfi :48 intermediate-format-strings)
    (srfi :98 os-environment-variables)
    (loitsu port)
    (loitsu file path)
    (loitsu control)
    (loitsu string)
    (loitsu irregex)
    (loitsu lamb)
    (loitsu file compat)
    (http))

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
                (equal? ".." dir)
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

    (define (directory-list-rec path)
      (let ((files (directory-list/path path)))
        (cond
            ((null? files) '())
          (else
              (fold
                  (lambda (e res)
                    (cond
                        ((not (file-directory? e))
                         (cons e res))
                      ((file-directory? e)
                       (append (directory-list-rec e)
                         res))))
                '() files)))))

    (define (remove-file path)
      (cond
          ((or (file-regular? path)
             (file-symbolic-link? path))
           (delete-directory path))))

    (define (copy-file src dest)
      (let ((pin (open-input-file src))
            (pout (open-output-file dest)))
        (let loop ((in pin))
             (let ((l (read-char in)))
               (unless (eof-object? l)
                 (write-char l pout)
                 (flush-output-port pout)
                 (loop in))))
        (close-input-port pin)
        (close-output-port pout)))


    (define find-file-in-paths
      (let ((find-helper (lambda (file paths proc)
                           (any (lambda (f)
                                  (find (lambda (s) (and (equal? (path-basename s) file)
                                                      (proc s)))
                                    (if (file-exists? f)
                                      (directory-list-rec f)
                                      '())))
                             paths)))
            (default-paths (string-split (get-environment-variable "PATH") #\:))
            (default-proc file-regular?))
        (^:
         ((file)
          (find-helper file default-paths default-proc))
         ((file paths)
          (find-helper file paths default-proc))
         ((file paths proc)
          (find-helper file paths proc)))))


    (define (string-is-url? s)
      (irregex-search "^https?://" s))

    (define-syntax slurp
      (syntax-rules ()
        ((_ file)
         (cond
             ((file-exists? file)
              (file->string file))
           ((string-is-url? file)
            (slurp-get file))
           (else
               (error (quote file) "file not exists\n"))))))


    (define (slurp-get url . file)
      (let ((ofile (if (null? file)
                     #f (car file))))
        (receive (body . rest)
                 (http-get->utf8 url)
                 (if ofile
                   (call-with-port
                       (open-file-output-port ofile)
                     (lambda (out)
                       (put-bytevector out body)))
                   body))))

    (define (spit file s)
      (if (not (file-exists? file))
        (call-with-output-file
            file
          (lambda (out)
            (display s out)))))

    (define temporary-directory
      (make-parameter "/tmp"))

    ))
