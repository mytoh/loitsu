;;; ylilauta.sls --- ylilauta image get script

;;; Code:

;;; library declare
(library (pikkukivi commands ylilauta)
    (export
      ylilauta)
  (import
    (silta base)
    (silta write)
    (silta file)
    (only (srfi :1 lists)
          delete-duplicates
          last)
    (srfi :26 cut)
    ;;(srfi :39 parameters)
    (only (mosh concurrent)
          sleep)
    (loitsu irregex)
    (loitsu match)
    (loitsu lamb)
    (loitsu file)
    (loitsu process)
    (loitsu control)
    (loitsu cli)
    (maali)
    (loitsu util)
    (surl))

  (begin

    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let ((file (extract-file-name uri)))
        (unless (file-exists? file)
          (surl uri file))))

    (define (save-html body thread)
      (let ((ofile (string-append thread ".html")))
        (if (and (not (string=? "" body))
              (file-exists? ofile))
          (remove-file ofile))
        (call-with-output-file ofile
          (lambda (out)
            (display body out)))))


    (define (thread-exists? board thread)
      (not (string=? ""
             (get-thread-html board thread))))

    (define (make-url board thread)
      (string-append "http://ylilauta.org/" board "/" thread))

    (define (get-image-url/thread  board thread)
      (let ((image-regexp `(: "http://static.ylilauta.org/files/"
                              (+ alphanumeric) "/orig/" (+ numeric) "."
                              (or "jpg"
                                "png"
                                "gif"
                                "bmp"
                                "swf"
                                "mp4"
                                "flv"
                                "mkv")
                              "/"  (+ (~ #\")))))
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

    (define (repeat f)
      (lambda args
        (let ((wait (* (* 60 (* 6 1000)) 1)))
          (let loop ()
               (apply f args)
               ;; (sleep wait)
               (loop)))))

    (define (force-loop body)
      (guard (e (else
                    (display "error, go back loop")
                  (newline)
                  (force-loop body)))
        (body)))

    (define *deleted-thread*
      (make-parameter '()))

    (define (update-deleted-thread thread)
      (if (not (memq thread (*deleted-thread*)))
        (*deleted-thread* (cons thread (*deleted-thread*)))))

    (define (thread-deleted? html)
      (string=? "" html))

    ;;; get functions
    ;; get one thread
    (define (ylilauta-get-one-thread board thread)
      (cond
        ((and (not (member thread (*deleted-thread*)))
           (valid-thread-number? thread))
         (setup-path thread)
         (cond
           ((thread-exists? board thread)
            (puts (paint thread 173))
            (let ((res (get-thread-html board thread)))
              (unless (string=? "" res)
                (with-cwd
                 thread
                 (map fetch
                   (get-image-url/thread board thread)))
                (with-cwd
                 thread
                 (save-html res thread)))))
           (else
               (update-deleted-thread thread))))))

    ;;; all thread
    (define (ylilauta-get-all-thread board)
      (let ((threads (directory-list2 (current-directory))))
        (for-each
            (cut ylilauta-get-one-thread board <>)
          threads)
        (puts (paint "-----------------------------" 29))))

    (define-case ylilauta-get
      ((board) (force-loop ((repeat ylilauta-get-all-thread) board)))
      ((board thread) (ylilauta-get-one-thread board thread)))


    ;;; main
    (define (ylilauta args)
      (let ((args (cddr args)))
        (match args
          ((board)
           (ylilauta-get board))
          ((board thread)
           (ylilauta-get board thread)))))
    ))
