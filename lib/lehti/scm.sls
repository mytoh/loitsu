
(library (lehti scm)
  (export
    url-is-git?)
  (import
    (rnrs)
    (loitsu file)
    (irregex))

  (begin

    (define (url-is-git? url)
      (let* ((matched (irregex-match "^(git)://.*" url))
             (url-scheme (if matched (irregex-match-substring matched 1)
                           #f))
             (url-path-match (irregex-match "^[a-z]+://[^/]+/([^/]+.*)" url))
             (url-path (if url-path-match (irregex-match-substring url-path-match 1)
                         #f)))
        (cond
          (url-scheme
            #t)
          (url-path
            (if (path-extension url-path)
              (equal? "git" (path-extension url-path))
              #f))
          (else #f))))
    ))
;
