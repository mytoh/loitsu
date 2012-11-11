
(library (lehti env)
  (export
    *lehti-cache-directory*
    *lehti-directory*
    *lehti-dist-directory*
    *lehti-bin-directory*
    *lehti-leh-file-directory*
    )
  (import
    (scheme base)
    (srfi :98)
    (srfi :39)
    (loitsu file))

  (begin
    (define *lehti-directory*
      (make-parameter
        (get-environment-variable "LEHTI_DIR")))

    (define *lehti-dist-directory*
      (make-parameter
        (build-path  (*lehti-directory* ) "dist")))

    (define *lehti-cache-directory*
      (make-parameter
        (build-path (*lehti-directory* )
                    "cache")))

    (define *lehti-leh-file-directory*
      (make-parameter
        (build-path (*lehti-directory* ) "leh")))

    (define *lehti-bin-directory*
      (make-parameter
        (build-path  (*lehti-directory* ) "bin")))

    ))
