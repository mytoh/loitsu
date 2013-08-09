(library (pikkukivi commands geeli)
    (export geeli)
  (import
    (silta base)
    (silta write)
    (only (srfi :1 lists)
          zip
          last)
    (only (srfi :13)
          string-take
          string-index)
    (srfi :39 parameters)
    (srfi :26 cut)
    (loitsu match)
    (loitsu string)
    (loitsu file)
    (loitsu irregex)
    (maali)
    (surl))

  (begin

    (define *gelbooru-base-url*
      "http://gelbooru.com")

    (define (parse-file-url page)
      (let ((url-rx '(: "file_url=\"" ($ (+ (~ #\"))))))
        (irregex-fold url-rx
                      (lambda (i m s)
                        (cons (irregex-match-substring m 1)
                          s))
                      '()
                      page)))

    (define (parse-id page)
      (let ((id-rx '(: " id=\"" ($ (+ (~ #\"))))))
        (irregex-fold id-rx
                      (lambda (i m s)
                        (cons (irregex-match-substring m 1)
                          s))
                      '()
                      page)))

    (define (parse-id/file-url page)
      (zip (parse-id page)
        (parse-file-url page)))

    (define (get-posts tag pid)
      (let ((limit "50"))
        (surl->utf8 (string-append *gelbooru-base-url* "/index.php?page=dapi&s=post&q=index"
                                   "&limit=" limit
                                   "&tags="  tag
                                   "&pid=" (x->string pid)))))

    (define (extract-file-name uri num)
      (path-swap-extension num
                           (path-extension (last (irregex-split "/" uri)))))

    (define (fetch tag uri num)
      (let ((file (build-path tag (extract-file-name uri num))))
        (unless (file-exists? file)
          (surl uri file))))

    (define (log msg)
      (display (paint msg 114))
      (newline))

    (define (post-is-empty? html)
      (if (irregex-match '(: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><posts count=\""
                             (+ num) "\" offset=\"0\"></posts>")
                         html)
        #t #f))

    (define (geeli-get-tag-loop tag count)
      (let ((html (get-posts tag count)))
        (when (not (post-is-empty? html))
          (log (string-append "page " (x->string count)))
          (for-each
              (lambda (i)
                (log (string-append "getting " (x->string (car i))))
                (fetch tag (cadr i) (car i)))
            (parse-id/file-url html))
          (geeli-get-tag-loop tag (+ count 1)))))

    (define (geeli-get-tag tag)
      (make-directory* tag)
      (log (string-append "created " tag " directory"))
      (geeli-get-tag-loop tag 0)
      (log (string-append "finished getting " tag)))

    (define (geeli args)
      (match (cddr args)
        (("get" "tag" tag)
         (geeli-get-tag tag))))

    ))
