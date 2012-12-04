
(library (surl)
  (export surl)
  (import
    (rnrs)
    (irregex)
    (http))

  (begin

    (define (string-is-url? str)
      (irregex-search
        "^https?://" str)))

  )
