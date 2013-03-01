(library (pikkukivi commands pahvi)
    (export pahvi)
  (import
    (silta base)
    (silta write)
    (only (srfi :1 lists)
          last)
    (srfi :26 cut)
    (loitsu match)
    (loitsu file)
    (loitsu irregex)
    (surl))
  (begin


    (define (extract-file-name uri)
      (last (irregex-split "/" uri)))

    (define (fetch uri)
      (let ((file (extract-file-name uri)))
        (unless (file-exists? file)
          (surl uri file))))


    (define *danbooru-base-url*
      "http://danbooru.donmai.us")

    (define (get-posts-page tag page)
      (surl->utf8 (string-append *danbooru-base-url* "/posts?" "page=" (number->string page) "&" "tags=" tag)))

    (define (get-post-urls html)
      ;; href="/posts/1284558?tags=piercing"
      (let ((image-regexp `(:  "/posts/" (+ num) "?tags=" (+ (~ #\")))))
        (map
            (lambda (m)
              (string-append "http://danbooru.donmai.us" (irregex-match-substring m 0)))
          (irregex-fold image-regexp
                        (lambda (i m s) (cons m s))
                        '()
                        html))))

    (define (get-post-image-urls urls)
      ;;     Size: <a href="/data/08c47da5bb38339428726de82894e5d6.jpg">2.39 MB</a>
      ;; (2000x3500)
      (map
          (lambda (url)
            (let ((html (surl->utf8 url))
                  (image-regexp `(:  "Size: <a href=\"" ($ "/data/" (+ (or num alpha)) "." (or "jpg" "jpeg" "png" "gif")) "\">" )))
              (string-append  *danbooru-base-url*
                (irregex-match-substring
                 (irregex-search image-regexp html)
                 1))))
        urls))

    (define (page-is-chicken? html)
      (if (irregex-search  "Nobody here but us chickens!"
                           html)
        #t #f))


    (define (pahvi-get-tag tag)
      (let loop ((page 1))
           (let ((page-posts (get-posts-page tag page)))
             (cond
                 ((not (page-is-chicken? page-posts))
                  (display (string-append "getting page " (number->string page)))
                  (map
                      fetch
                    (get-post-image-urls (get-post-urls page-posts)))
                  (newline)
                  (loop (+ page 1)))))))


    (define (pahvi args)
      (match (cddr args)
        (("get" "tag" tag)
         (pahvi-get-tag tag))))

    ))
