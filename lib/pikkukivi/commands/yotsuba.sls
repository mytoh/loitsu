(library (pikkukivi commands yotsuba)
    (export
      yotsuba)
  (import
    (silta base)
    (silta file)
    (silta write)
    (loitsu irregex)
    (only (srfi :1)
          every
          filter
          delete-duplicates
          last)
    (srfi :8 receive)
    (only (srfi :13 strings)
          string-join
          string-every)
    (srfi :14 char-sets)
    (srfi :26 cut)
    (srfi :39 parameters)
    (srfi :37 args-fold)
    (only (mosh concurrent)
          sleep)
    (loitsu match)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (maali)
    (loitsu util)
    (surl))

  (begin

    (define (yotsuba-url . rest)
      (string-append "http://boards.4chan.org/"
        (string-join rest "/")))

    (define (make-thread-url board thread)
      (yotsuba-url  board "res" thread))

    (define (get-html board thread)
      (let ((html (surl->utf8 (make-thread-url board thread))))
        html))

    (define (save-html thread str)
      (let ((file (build-path thread (path-swap-extension thread "html"))))
        (if (file-exists? file)
          (remove-file file))
        (call-with-output-file file
          (lambda (out)
            (display str out)))))

    (define (parse-image-url html)
      (let ((image-regexp '(: "//images.4chan.org/"
                              (+ alphabetic)
                              "/src/"
                              (+ numeric)
                              "."
                              (or "jpeg" "bmp" "jpg" "gif" "png")))
            (match->url (lambda (m)
                          (string-append "http:"
                            (irregex-match-substring m)))))
        (delete-duplicates
            (map match->url
              (irregex-fold image-regexp
                            (lambda (i m s)
                              (cons m s))
                            '()
                            html)))))

    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let* ((file (extract-file-name uri))
             (tmp (temp-name file)))
        (unless (file-exists? file)
          (when (file-exists? tmp)
            (remove-file tmp))
          (surl uri tmp)
          (rename-file tmp file))))

    (define (temp-name orig)
      (let ((ext "!tmp"))
        (path-add-extension orig ext)))

    (define (setup-path number)
      (unless (file-exists? number)
        (make-directory* number)))

    (define (thread-exists? body)
      (not (equal? "" body)))

    (define (yotsuba-get-one-thread board thread)
      (let ((res (get-html board thread)))
        (cond
          ((thread-exists? res)
           (setup-path thread)
           (display thread)
           (save-html thread res)
           (let ((urls (parse-image-url res)))
             (with-cwd thread
                       (map fetch
                         urls)))
           (newline)
           #t)
          (else
              (display (string-append thread "'s gone"))
            (newline)
            #f))))

    (define (string-number? s)
      (string-every char-set:digit s))

    (define (yotsuba-get-all-thread board)
      (map (lambda (t) (yotsuba-get-one-thread board t))
        (filter (lambda (d) (string-number? d)) (directory-list2 (current-directory)))))


    (define (repeat f . args)
      (let loop ()
           (let ((wait (* (* 60 (* 6 1000)) 5)))
             (let ((results (apply f args)))
               (unless (all-false? results)
                 (sleep 10000)
                 (loop))))))

    (define (all-false? x)
      (if (list? x)
        (every (lambda (e) (eq? e #f)) x)
        (eq? x #f)))

    (define option-repeat
      (option
          '(#\r "repeat") #f #t
          (lambda (option name arg repeat all)
            (values #t all))))

    (define option-all
      (option
          '(#\a "all") #f #t
          (lambda (option name arg repeat all)
            (values repeat #t))))

    (define (yotsuba args)
      (let ((args (cddr args)))
        (receive (repeat? all?)
                 (args-fold args
                   (list option-repeat option-all)
                   (lambda (option name arg . seeds) ; unrecognized
                     (error "Unrecognized option:" name))
                   (lambda (operand repeat all)        ; operand
                     (values repeat all))
                   #f                              ; default value of repeat?
                   #f                             ; default value of all?
                   )
                 (cond (repeat?
                        (match (cdr args)
                          ((board)
                           (repeat yotsuba-get-all-thread board))
                          ((board thread)
                           (repeat yotsuba-get-one-thread board thread))))
                       (else
                           (match args
                             ((board)
                              (yotsuba-get-all-thread board))
                             ((board thread)
                              (yotsuba-get-one-thread board thread))))))))

    ))
