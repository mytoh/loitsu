
(library (lehti base)
  (export
    set-current-directory!
    paint
    ohei
    run-command
    with-cwd

    remove-directory*
    remove-file
    create-directory
    make-directory*
    file->sexp-list
    file->list
    file-directory?
    copy-file
    create-symbolic-link
    directory-list2
    directory-list/path
    file-symbolic-link?

    match-short-command

    partial

    path-swap-extension
    path-sans-extension
    path-extension
    path-dirname
    build-path)
  (import
    (except (rnrs)
            find
            remove)
    (irregex)
    (only (srfi :1 lists)
          take-right
          drop-right
          remove
          find
          fold
          last)
    (only (srfi :13)
          string-join
          string-take
          string-trim-right
          string-take-right)
    (srfi :48 intermediate-format-strings)
    (lehti base compat)
    )

  (begin


    ;; path

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

    (define (remove-trailing-slash path)
      (string-trim-right path #\/))

    (define (path-swap-extension path ext)
      (let ((pt (path-sans-extension path)))
        (string-append pt "." ext)))

    (define (path-sans-extension path)
      (let ((pt (split-dot path)))
        (cond
          ((< 1 (length pt))
           (string-join (drop-right pt 1) "."))
          ((eq? 1 (length pt))
           (car pt))
          (else
            #f))))

    (define (path-extension path)
      (let ((p (split-dot path)))
        (cond
          ((< 1 (length p))
           (last p))
          (else
            #f))))

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


    (define (split-dot path)
      (string-split path #\.))

    (define (split-slash path)
      (string-split path #\/))

    ;; file

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

    (define (file->sexp-list file)
      (call-with-input-file
        file
        (lambda (in)
          (port->sexp-list in))))

    (define (port->sexp-list port)
      (port->list read port))

    (define (port->list reader port)
      (let loop ((res '()))
        (let ((l (reader port)))
          (if (eof-object? l)
            res
            (cons l (loop res))))))

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

    (define (remove-file path)
      (cond
        ((or (file-regular? path)
             (file-symbolic-link? path))
         (delete-directory path))))

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



    ;; process

    (define (run-command lst)
      (let ((command (string-join (map x->string lst))))
        (call-process command)))


    (define-syntax with-cwd
      (syntax-rules ()
        ((_ dir body ...)
         (let ((cur (current-directory))
               (dest dir))
           (set-current-directory! dest)
           body
           ...
           (set-current-directory! cur)))))

    ;; string

    (define (x->string obj)
      (cond
        ((string? obj) obj)
        ((number? obj) (number->string obj))
        ((symbol? obj) (symbol->string obj))
        ((char?   obj) (string obj))
        (else          (format "~a" obj))))

    ;; message

    (define-syntax ohei
      (syntax-rules ()
        ((_ msg)
         (begin
           (message (string-append
                      (paint ">" 181)
                      (paint ">" 179)
                      (paint ">" 178))
                    msg 0)
           (newline)))
        ((_ msg ...)
         (begin
           (message ">>>" (string-append msg ...)  42)
           (newline)))))

    (define (message symbol text colour)
      (display (string-append (paint symbol colour) " " text)))


    ;; maali
    (define (paint s num)
      (string-append "[38;5;" (number->string num)
                     "m" s "[0m"))

    ;; cli

    (define (find-short-command short cmd)
      (let ((command-re `(: ,short (* ascii))))
        (irregex-match command-re cmd)))

    (define-syntax match-short-command
      (syntax-rules ()
        ((_ short (command expr))
         (cond
           ((find-short-command short command)
            expr)
           (else
             (error "match-short-command" (string-append "no matching pattern for " short)))))
        ((_ short (command expr) (c2 e2)  ...)
         (cond
           ((find-short-command short command)
            expr)
           (else
             (match-short-command short (c2 e2) ...))))))


    ;; util

    (define-syntax partial
      (syntax-rules ()
        ((_ f arg)
         (lambda args (apply f arg args)))
        ((_ f arg ...)
         (lambda args (apply f arg ... args)))))

    ))
