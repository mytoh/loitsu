
(import
  (rnrs)
  (pieni check)
  (loitsu archive))


(check (file-archive? "test.zip") => #t)

(check-report)
