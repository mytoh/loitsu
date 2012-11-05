
(library (surl)
  (export surl)
  (import
    (scheme base)
    (irregex)
    (http))

  (define (string-is-url? str)
    (irregex-search
      "^https?://" str))

  )
