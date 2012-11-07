
(library (surl)
  (export surl)
  (import
    (scheme base)
    (irregex)
    (http))

  (begin
    (define (string-is-url? str)
      (irregex-search
        "^https?://" str)))

  )
