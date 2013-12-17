(library (loitsu file)
    (export
      make-directory*
      remove-directory*
      remove-file
      copy-file
      rename-file
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
      path-add-extension
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
    (loitsu control)
    (loitsu string)
    (loitsu irregex)
    (loitsu lamb)
    (loitsu file path)
    (loitsu file compat)
    (loitsu file directory)
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



    (define (remove-file path)
      (cond
        ((or (file-regular? path)
           (file-symbolic-link? path))
         (delete-directory path)
         path)))

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



    ))
