(library (pikkukivi commands booru pahvi)
    (export pahvi)
  (import
    (silta base)
    (silta write)
    (only (srfi :1 lists)
          last)
    (only (srfi :13)
          string-take
          string-index)
    (srfi :39 parameters)
    (srfi :26 cut)
    (loitsu match)
    (loitsu file)
    (loitsu irregex)
    (surl))
  (begin

    (define *danbooru-base-url*
      "http://danbooru.donmai.us")

    (define supporting-image-types
      (make-parameter
          '("jpg" "jpeg" "png" "gif" "bmp" "swf")))

    (define (extract-file-name uri num)
      (path-swap-extension num
                           (path-extension (last (irregex-split "/" uri)))))

    (define (fetch tag uri num)
      (let ((file (build-path tag (extract-file-name uri num))))
        (unless (file-exists? file)
          (surl uri file))))


    (define (get-posts-page tag page)
      (surl->utf8 (string-append *danbooru-base-url* "/posts?" "page=" (number->string page) "&" "tags=" tag)))

    (define (get-post-urls html)
      ;; href="/posts/1284558?tags=piercing"
      (let ((image-regexp `(:  "/posts/" (+ num) "?tags=" (+ (~ #\")))))
        (map (lambda (m) (string-append "http://danbooru.donmai.us" (irregex-match-substring m 0)))
          (irregex-fold image-regexp
                        (lambda (i m s) (cons m s))
                        '()
                        html))))

    (define (get-post-image-urls urls)
      (map
          (lambda (url)
            (let ((html (surl->utf8 url))
                  (image-regexp `(: "Size: <a href=\""
                                    ($ "/data/"
                                       (+ (or num alpha))
                                       "."
                                       (or ,@(supporting-image-types)))
                                    "\">" )))
              (list url
                (string-append  *danbooru-base-url*
                  (irregex-match-substring
                   (irregex-search image-regexp html)
                   1)))))
        urls))

    (define (page-is-chicken? html)
      (if (irregex-search  "Nobody here but us chickens!"
                           html)
        #t #f))

    (define (url->post-number url)
      (let ((base (path-basename url)))
        (string-take base (string-index base #\?))))

    (define (pahvi-get-tag tag)
      (make-directory* tag)
      (let loop ((page 1))
           (let ((page-posts (get-posts-page tag page)))
             (cond
               ((not (page-is-chicken? page-posts))
                (display (string-append "getting page " (number->string page)))
                (map (lambda (post)
                       (fetch tag (cadr post) (url->post-number (car post))))
                  (get-post-image-urls (get-post-urls page-posts)))
                (newline)
                (loop (+ page 1)))))))


    (define (pahvi args)
      (match (cddr args)
        (("get" "tag" tag)
         (pahvi-get-tag tag))))

    ))
