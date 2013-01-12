
(library (loitsu archive)
  (export
    extract-archive
    file-archive?)
  (import
    (rnrs)
    (only (srfi :1 lists)
          any)
    (srfi :39 parameters)
    (loitsu process)
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


    ;;; methods from
    ;;; cv2tar.scm by
    ;;;  Walter C. Pelissero

    (define (zip-unpacker file . directory)
      (if (null? (car directory))
        (run-command `(unzip -q ,file))
        (run-command `(unzip -q ,file -d ,(caar directory)))))


    (define (rar-unpacker file . directory)
      (cond ((null? (car directory))
             (run-command `(unrar x -ad -inul ,file)))
        (else
          (run-command `(unrar x -ad -inul ,file ,(caar directory))))))

    (define (lha-unpacker file . diretory)
      (run-command `(lha xq ,file)))

    (define (tar-unpacker file . directory)
      (cond ((null? (car directory))
             (run-command `(tar xf ,file)))
        (else
          (make-directory* (caar directory))
          (run-command `(tar xf ,file -C ,(caar directory))))))

    (define (sevenzip-unpacker file . directory)
      (if (null? (car directory))
        (run-command `("7z" x ,file))
        (run-command `("7z" x ,file -o ,(caar directory)))))

    (define *unpacker-alist*
      `(
        ("zip" ,zip-unpacker)
        ("cbz" ,zip-unpacker)

        ("7z" ,sevenzip-unpacker)

        ("rar" ,rar-unpacker)
        ("cbr" ,rar-unpacker)

        ("lha" ,lha-unpacker)

        ("gz"  ,tar-unpacker)
        ("tgz" ,tar-unpacker)
        ("bz2" ,tar-unpacker)
        ("xz"  ,tar-unpacker)
        ("txz" ,tar-unpacker)
        ("cbx" ,tar-unpacker)
        ("tar" ,tar-unpacker)))

    (define (extract-archive file . directory)
      (let ((unpacker (cadr (assoc (path-extension file)
                                   *unpacker-alist*))))
        (if unpacker
          (if directory
            (unpacker file directory)
            (unpacker file))
          (error "unknown file type" file))))

    ))

