
(library (pikkukivi commands futaba)
  (export
    futaba)
  (import
    (silta base)
    (silta write)
    (silta file)
    (irregex)
    (match)
    (only  (rnrs)
           latin-1-codec
           make-transcoder
           bytevector->string)
    (only (srfi :1 lists)
          delete-duplicates
          last)
    (srfi :26 cut)
    (srfi :39 parameters)
    (only (mosh concurrent)
          sleep)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (loitsu maali)
    (loitsu util)
    (surl))

  (begin

    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let ((file (extract-file-name uri)))
        (unless (file-exists? file)
          (surl uri file))))

    (define (find-server board thread)
      (let ((get (lambda (s)
                   (let ((res (bytevector-length (surl (string-append "http://" s ".2chan.net/"
                                                                      board "/res/"
                                                                      thread ".htm")))))
                     (cond
                       ((not (number? res)) #f)
                       ((and (number? res)
                             (zero? res))
                        #f)
                       (else s))))))
        (match board
          ("b"
           (or (get "jun")
               (get "may")
               (get "dec")))
          ("l" ;二次元壁紙
           (get  "dat" ))
          ("k" ;壁紙
           (get "cgi"))
          ("7" ;ゆり
           (get "zip"))
          ("40" ;東方
           (get "may"))
          ("id"
           (get "may")))))

    (define (thread-exists? board thread)
      (find-server board thread))

    (define (make-url board thread)
      (string-append "http://"  (find-server board thread) ".2chan.net/" board "/res/"
                     thread ".htm"))

    (define (get-image-url/thread  board thread)
      (let ((image-regexp `(: "http://" (+ alphabetic) ".2chan.net/" (+ alphabetic) "/"
                              ,board "/src/" (+ (~ #\")))))
        (delete-duplicates
          (map (cut irregex-match-substring <> 0)
               (irregex-fold image-regexp
                             (lambda (i m s) (cons m s))
                             '()
                             (get-thread-html board thread))))))

    (define (get-thread-html board thread)
      (surl->utf8 (make-url board thread)))

    (define (setup-path thread)
      (unless (file-exists? thread)
        (make-directory* thread)))

    (define (valid-thread-number? num)
      (number? (string->number num)))

    (define (futaba-get-one-thread board thread)
      (cond
        ((and (not (member thread (deleted-thread)))
              (valid-thread-number? thread))
         (setup-path thread)
         (cond
           ((thread-exists? board thread)
            (puts thread)
            (let ((res (get-thread-html board thread)))
              (unless (string=? "" res)
                (with-cwd
                  thread
                  (map  fetch
                        (get-image-url/thread board thread))))))
           (else
             (update-deleted-thread thread))))))

    (define (futaba-get-all-thread board)
      (let ((threads (directory-list2 (current-directory))))
        (for-each
          (cut futaba-get-one-thread board <>)
          threads)
        (puts (paint "-----------------------------" 29))))

    (define futaba-get
      (case-lambda
        ((board) (force-loop ((repeat futaba-get-all-thread) board)))
        ((board thread) (futaba-get-one-thread board thread))))

    (define (repeat f)
      (lambda args
        (let ((wait (* (* 60 (* 6 1000)) 5)))
          (let loop ()
            (apply f args)
            (sleep wait)
            (loop)))))

    (define (force-loop body)
      (guard (e (else
                   (display "error, go back loop")
                   (newline)
                   (force-loop body)))
        (body)))


    (define deleted-thread
      (make-parameter '()))

    (define (update-deleted-thread thread)
      (if (not (memq thread (deleted-thread)))
        (deleted-thread (cons thread (deleted-thread)))))

    (define (futaba args)
      (let ((args (cddr args)))
        (match args
          ((board)
           (futaba-get board))
          ((board thread)
           (futaba-get board thread)))))


    ))
