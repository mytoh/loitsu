
(library (loitsu lista)
    (export
      list-file
      list-file-long)
  (import
    (srfi :19)
    (only (srfi :13)
          string-pad
          string-pad-right
          string-drop-right
          string-take)
    (only (srfi :1)
          fold)
    (srfi :48)
    (silta base)
    (silta write)
    (silta cxr)
    (loitsu process)
    (loitsu list)
    (loitsu maali)
    (loitsu file))

  (begin

    (define (print-files files)
      (for-each
       (lambda (f)
         (display f)
         (newline))
       files))

    (define (make-file-name-long directory files)
      (map
       (lambda (f)
         (let ((path (build-path directory f)))
           (cond
            ((file-directory? path)
             (compose-file-infos
              path
              (make-file-name-directory f)))
            ((file-executable? path)
             (compose-file-infos
              path
              (make-file-name-executable f)))
            ((file-symbolic-link? path)
             (compose-file-infos
              path
              (make-file-name-symlink f)))
            (else
             (compose-file-infos
              path
              f)))))
       files))

    (define (make-file-name directory file)
      (let ((path (build-path directory file)))
        (cond
         ((file-directory? path)
          (make-file-name-directory file))
         ((file-executable? path)
          (make-file-name-executable file))
         ((file-symbolic-link? path)
          (make-file-name-symlink file))
         (else
          file))))

    (define (make-file-name-mark colour mark)
      (lambda (f)
        (string-append (paint f colour) (paint mark 242))))

    (define make-file-name-executable
      (make-file-name-mark 4 "*"))

    (define make-file-name-directory
      (make-file-name-mark 1 "/"))

    (define make-file-name-symlink
      (make-file-name-mark 5 "@"))

    (define (compose-file-infos path name)
      (let ((sep (paint "│" 239))
            (sep2 (paint "├" 239 ))
            (sep3 (paint "┤" 239)))
        (string-append
            sep2
          (file-info-perm path) sep3
          (file-info-time path) sep
          (file-info-size path) sep name)))


    (define (file-info-perm file)
      (let* ((no (paint "-" 0))
             (perm-or (lambda (proc name perm)
                        (if (proc name)
                            perm no)))
             (w (perm-or file-writable? file
                         (paint "w" 7)))
             (r (perm-or file-readable? file
                         (paint "r" 6)))
             (x (perm-or file-executable? file
                         (paint "x" 5))))
        (string-append r w x)))

    (define (file-info-size file)
      (let ((size (file-size-in-bytes file)))
        (cond
         ((> size 1073741824)
          (string-append (string-pad (number->string (truncate (/ (/ (/ size 1024) 1024) 1024))) 4) "G"))
         ((> size 1048576)
          (string-append (string-pad (number->string (truncate (/ (/ size 1024) 1024))) 4) "M"))
         ((> size 1024)
          (string-append (string-pad  (number->string (truncate (/ size 1024))) 4) "K"))
         (else
          (string-append (string-pad  (number->string size) 4) "B")))))


    (define (file-info-time file)
      (let* ((ctime (string->number (string-take (number->string (file-stat-ctime file)) 10)))
             (currtime (time-second (current-time)))
             (delta (- currtime ctime))
             (sec 60)
             (min (* 45 60))
             (hour (* 36 60 60))
             (day (* 30 24 60 60))
             (month (* 12 30 24 60 60)))
        (cond
         ((< delta sec)
          (format-time 'sec 3 delta))
         ((< delta min)
          (format-time 'min 15 delta))
         ((< delta hour)
          (format-time 'hour 9 delta))
         ((< delta day)
          (format-time 'day 4 delta))
         ((< delta month)
          (format-time 'month 14 delta))
         (else
          (format-time 'year 0 delta)))))

    (define (format-time unit colour time)
      (case unit
        ('sec (format #f "~a ~a" (paint (number->string time) colour) (string-pad-right "sec" 5)))
        ('min (format #f "~a ~a" (paint (time->min time) colour) (string-pad-right "min" 5)))
        ('hour (format #f "~a ~a" (paint (time->min time) colour) (string-pad-right "hour" 5)))
        ('day (format #f "~a ~a" (paint (time->day time) colour) (string-pad-right "day" 5)))
        ('month (format #f "~a month" (paint (time->month time) colour)))
        ('year (format #f "~a ~a" (paint (time->year time) colour) (string-pad-right "year" 5)))))

    (define (adjust-string s )
      (if (> 10 (string->number s))
          (string-pad s 2)
          s))

    (define (/. a b)
      (inexact (/ a b)))

    (define (round->exact n)
      (exact (round n)))

    (define (time->min time)
      (adjust-string (number->string (round->exact (/. time 60)))))

    (define (time->hour time)
      (adjust-string
       (number->string (round->exact  (/. (/. time 60) 60)))))

    (define (time->day time)
      (adjust-string
       (number->string (round->exact  (/. (/.  (/. time 60) 60) 24)))))

    (define (time->month time)
      (adjust-string
       (number->string (round->exact (/. (/. (/. (/. time 60) 60) 24) 30)))))

    (define (time->year time)
      (adjust-string
       (number->string (round->exact (/. (/. (/. (/. (/. time 60) 60) 24) 30) 12)))))

    (define (list-file args)
      (let* ((directory (if (null? (cddr args))
                            (current-directory)
                            (caddr args)))
             (files (directory-list2 directory)))
        (puts-columns make-file-name directory files)))

    (define (list-file-long args)
      (let* ((directory (if (null? (cddr args)) (current-directory) (caddr args)))
             (files (directory-list2 directory)))
        (print-files (make-file-name-long directory files))))

    (define (string-longest string-list)
      (fold (lambda (s r)
              (if (< r (string-length s))
                  (string-length s)
                  r))
        0 string-list))

    (define (remove-newline s)
      (string-drop-right s 1))

    (define (puts-columns colour-func directory items)
      (let* ((console-width (if (< 80 (string->number (remove-newline (process-output->string "tput cols" ))))
                                80 (string->number (remove-newline (process-output->string "tput cols")))))
             (longest (string-longest items))
             (optimal-col-width (exact (floor (inexact (/ console-width (+ longest 2))))))
             (cols (if (< 1 optimal-col-width ) optimal-col-width 1)))
        (let loop ((items items))
          (cond
           ((< (length items) cols)
            (for-each
             (lambda (s)
               (display
                   (string-pad-right (colour-func directory  s) (+ longest 2))))
             (take* items cols)))
           (else
            (for-each
             (lambda (s)
               (display
                   (string-pad-right (colour-func directory s) (+ longest 2))))
             (take* items cols))
            (newline)
            (loop (drop* items cols))))))
      (newline))

    ))
