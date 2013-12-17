(library (loitsu file directory)
    (export
      make-directory*
      remove-directory*
      directory-list2
      directory-list/path
      directory-list-rec
      directory-empty?
      temporary-directory
      directory-list
      set-current-directory!
      current-directory
      create-directory
      delete-directory
      file-directory?
      )
  (import
    (except (rnrs)
            remove)
    (srfi :8 receive)
    (only (srfi :13 strings)
          string-trim-right)
    (only (srfi :1 lists)
          fold
          remove)
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
    (http))

  (begin


    (define (%make-directory dir)
      (unless (or (equal? "." dir)
                (equal? ".." dir)
                (equal? "" dir))
        (create-directory dir)))

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

    (define (%remove-file path)
      (cond
        ((or (file-regular? path)
           (file-symbolic-link? path))
         (delete-directory path)
         path)))

    (define (remove-directory* path)
      (cond
        ((file-regular? path)
         (%remove-file path))
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

    (define temporary-directory
      (make-parameter "/tmp"))

    ))
