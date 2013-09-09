(library (pikkukivi commands kolmio)
    (export kolmio)
  (import
    (silta base)
    (silta write)
    (silta read)
    (silta file)


    (only (srfi :1 lists)
          zip
          last)
    (only (srfi :13)
          string-take
          string-index)
    (srfi :39 parameters)
    (srfi :26 cut)
    (only (mosh concurrent)
          sleep)
    (loitsu match)
    (loitsu string)
    (loitsu file)
    (loitsu irregex)
    (loitsu message)
    (loitsu plist)
    (maali)
    (surl))

  (begin

    (define *kolmio-chan-base-url*
      "http://chan.sankakucomplex.com/")


    (define (parse-file-url page)
      (let* ((url-rx '(: "Original: <a href=\"" ($ "http://cs.sankakucomplex.com/data/"  (+ (~ "\"\n")))))
             (not-image-rx '(: "<p><a href=\"" ($ "http://cs.sankakucomplex.com/data/"  (+ (~ "\"\n"))) "\" >Save this flash (right click and save)</a></p>"))
             (image-res (parse-file-url/rx (list url-rx not-image-rx) page)))
        (if image-res
          (irregex-match-substring image-res 1)
          #f)))

    (define (parse-file-url/rx regexps html)
      (if (null? regexps)
        #f
        (let ((res (irregex-search (car regexps) html)))
          (if res
            res
            (parse-file-url/rx (cdr regexps) html)))))

    (define (get-post-ids tag pid)
      (let ((post-id-rx '(: "a href=\"/post/show/" ($ (+ (~ #\")))))
            (html (surl->utf8 (string-append *kolmio-chan-base-url*
                                "post/index?"
                                "tags=" tag
                                "&" "page=" (x->string pid)))))
        (irregex-fold post-id-rx
                      (lambda (i m s)
                        (cons (irregex-match-substring m 1)
                          s))
                      '()
                      html)))

    (define (get-page id)
      (surl->utf8 (string-append "http://chan.sankakucomplex.com/post/show/"
                    (x->string id))))

    (define (extract-file-name uri num)
      (path-swap-extension (x->string num)
                           (path-extension (last (irregex-split "/" uri)))))

    (define (fetch tag uri num)
      (let ((file (build-path tag (extract-file-name uri num))))
        (cond ((file-exists? file)
               (loki "file already exists")
               (if (= 12922 (file-size-in-bytes file))
                 (begin
                   (remove-file file)
                   (fetch tag uri num))))
              (else
                  (surl uri file)
                (if (= 12922 (file-size-in-bytes file))
                  (begin
                    (loki "retrying")
                    (remove-file file)
                    (sleep (* 60 (* 6 1000)))
                    (fetch tag uri num)))))))


    (define (page-is-empty? html)
      (if (irregex-search '(: "<posts count=\"" (+ num)
                              "\" offset=\"" (+ num)
                              "\"></posts>")
                          html)
        #t #f))

    (define (read-file file)
      (call-with-input-file
          file
        (lambda (in)
          (read in))))

    (define (write-file file content)
      (when (file-exists? file)
        (remove-file file))
      (call-with-output-file
          file
        (lambda (out)
          (write content out))))

    ;; (write-file "test.fuck" (list(plist ':tag "gokou_ruri" ':id 1939)))
    ;; (display (pref (read-file "test.fuck") ':tag))


    (define (data-find-post posts pid)
      (cond ((null? posts)
             #f)
            ((string=? pid (pval (car posts) ':pid))
             (car posts))
            (else
                (data-find-post (cdr posts) pid))))

    (define (data-get-url tag pid)
      (let ((file (build-path tag (string-append tag ".dat"))))
        (if (file-exists? file)
          (let* ((posts (read-file file))
                 (post (data-find-post posts pid)))
            (if post
              (pval post ':url)
              (let ((url (parse-file-url (get-page pid))))
                (cond (url
                       (write-file file (append posts
                                          (list (plist ':pid pid ':url url))))
                       url)
                      (else
                          (get-image tag pid))))))
          (let ((url (parse-file-url (get-page pid))))
            (cond (url
                   (write-file file (list (plist ':pid pid ':url url)))
                   url)
                  (else
                      (get-image tag pid)))))))

    (define (get-image tag pid)
      (ohei "getting " (x->string pid))
      (let ((res (data-get-url tag pid)))
        (if res
          (let ((url res))
            (fetch tag url pid))
          (let ((url (parse-file-url (get-page pid))))
            (if url
              (fetch tag url pid)
              (get-image tag pid))))))

    (define (loki msg)
      (display msg)
      (newline))


    (define (kolmio-get-tag-loop tag pid)
      (loki (string-append "page " (x->string pid)))
      (let ((post-ids (get-post-ids tag pid)))
        (for-each
            (lambda (id)
              (get-image tag id))
          post-ids))
      (kolmio-get-tag-loop tag (+ pid 1)))

    (define (setup-directory tag)
      (unless (file-exists? tag)
        (loki (string-append "create " (paint tag 39) " directory"))
        (make-directory* tag)))

    (define (kolmio-get-tag tag pid)
      (loki (string-append (paint "Tag: " 3) (paint tag 39)))
      (setup-directory tag)
      (kolmio-get-tag-loop tag pid)
      (loki (string-append "finished getting " tag)))


    (define (kolmio args)
      (match (cddr args)
        (("get" "tag" tag)
         (kolmio-get-tag tag 0))
        (("get" "tag" tag pid)
         (kolmio-get-tag tag (string->number pid)))))

    ))
