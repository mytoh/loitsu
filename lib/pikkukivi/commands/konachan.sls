(library (pikkukivi commands konachan)
    (export konachan)
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

    (define *konachan-base-url*
      "http://konachan.com")

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
      (let ((limit "100"))
        (surl->utf8 (string-append *konachan-base-url* "/post.xml?"
                                   "limit=" limit
                                   "&" "tags="  tag
                                   "&" "page=" (x->string pid)))))

    (define (extract-file-name uri num)
      (path-swap-extension num
                           (path-extension (last (irregex-split "/" uri)))))

    (define (fetch tag uri num)
      (let ((file (build-path tag (extract-file-name uri num))))
        (unless (file-exists? file)
          (surl uri file))))

    (define (log msg)
      (display msg)
      (newline))

    (define (page-is-empty? html)
      (if (irregex-search '(: "<posts count=\"" (+ num)
                              "\" offset=\"" (+ num)
                              "\"></posts>")
                          html)
        #t #f))

    (define (konachan-get-tag-loop tag count)
      (let ((html (get-posts tag count)))
        (unless (page-is-empty? html)
          (log (string-append "page " (x->string count)))
          (for-each
              (lambda (i)
                (log (string-append "getting " (x->string (car i))))
                (log (cadr i))
                (fetch tag (cadr i) (car i)))
            (parse-id/file-url html))
          (konachan-get-tag-loop tag (+ count 1)))))

    (define (konachan-get-tag tag)
      (make-directory* tag)
      (log (string-append "Tag: " (paint tag 39)))
      (log (string-append "created " tag " directory"))
      (konachan-get-tag-loop tag 0)
      (log (string-append "finished getting " tag)))

    (define (konachan args)
      (match (cddr args)
        (("get" "tag" tag)
         (konachan-get-tag tag))))

    ))
