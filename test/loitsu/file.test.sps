
(import
  (scheme base)
  (srfi :78)
  (loitsu file))

;; build-path
(check (build-path "test" "file") => "test/file")
(check (build-path "test" "file/") => "test/file")
(check (build-path "/test" "file") => "/test/file")
(check (build-path "/test" "file/") => "/test/file")

;; path-extension
(check (path-extension "test.sls") => "sls")
(check (path-extension "test.test.sls") => "sls")
(check (path-extension "test") => #f)

;; path-sans-extension
(check (path-sans-extension "test.sps") => "test")
(check (path-sans-extension "test.test.spm") => "test.test")
(check (path-sans-extension "test") => "test")

;; path-swap-extension
(check (path-swap-extension "test.test" "sps") => "test.sps")
(check (path-swap-extension "test" "sps") => "test.sps")
(check (path-swap-extension "test" ".sps") => "test..sps")

;; path-dirname
(check (path-dirname "test/file") => "test")
(check (path-dirname "test/file/") => "test")
(check (path-dirname "test/dir/file") => "test/dir")
(check (path-dirname "/test/dir/file") => "/test/dir")

;;path-basename
(check (path-basename "test/file") => "file")
(check (path-basename "test/file/") => "file")

;; path-absolute?
(check (path-absolute? "test") => #f)
(check (path-absolute? "test/file") => #f)
(check (path-absolute? "/test") => #t)

(check-report)



; make-directory*
; remove-directory*
; remove-file
; copy-file
; directory-list2
; directory-list/path
; directory-list-rec
; directory-empty?
; file->string-list
; file->sexp-list
; home-directory
; find-file-in-paths

