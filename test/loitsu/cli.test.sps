
(import
  (rnrs)
  (irregex)
  (pieni check)
  (loitsu cli))

;; find-short-command
(check (irregex-match-substring (find-short-command "ins" "install")) => "install")

;; match-short-command
(check (match-short-command "ins" ("install" #t)) => #t)

(check-report)
