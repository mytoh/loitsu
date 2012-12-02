
(library (loitsu archive)
  (export
    file-archive?)
  (import
    (scheme base)
    (only (srfi :1 lists)
          any)
    (srfi :39 parameters)
    (loitsu file))

  (begin

    (define supporting-extensions
      (make-parameter
        '("tar" "xz" "gz" "bz2"
          "cbz" "cbr" "cbx"
          "rar"
          "zip")))

    (define (file-archive? file)
      (let ((extension (path-extension file)))
        (any
          (lambda (s)
            (string=? extension s))
          (supporting-extensions))))


    ))

