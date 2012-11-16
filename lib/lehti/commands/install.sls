
(library (lehti commands install)
  (export install)
  (import
    (scheme base)
    (scheme write)
    (scheme eval)
    (scheme repl)
    (loitsu file)
    (loitsu process)
    (lehti env)
    (lehti lehspec)
    (lehti commands fetch)
    (kirjain)
    )

  (begin

    (define (install args)
      (let ((package (caddr args)))
        (fetch (string-append "git://github.com/mytoh/" package) package)
        (set-current-directory! (build-path (*lehti-cache-directory*)
                                            package))
        (let* ((cache-directory (build-path (*lehti-cache-directory*)
                                            package))
               (lehspec (spec (cdar (file->sexp-list (build-path cache-directory
                                                                 (path-swap-extension package "lehspec")))))))
          (install-leh-package-files  lehspec)
          (make-executables package)
          (remove-directory* cache-directory)
          )))

    (define (install-leh-package-files spec)
      (let ((files (spec-files spec))
            (package-name (spec-name spec)))
        (create-directory (build-path (*lehti-dist-directory*) package-name))
        (for-each
          (lambda (file)
            (cond
              ((file-directory? file)
               (make-directory* (build-path (*lehti-dist-directory*) package-name file)))
              (else
                (make-directory* (build-path (*lehti-dist-directory*) package-name (path-dirname file)))
                (copy-file file
                           (build-path (*lehti-dist-directory*) package-name file)))))
          files)))

    (define (make-executables name)
      (if (file-exists? (build-path (*lehti-dist-directory*)
                                    name "bin"))
        (for-each
          (lambda (f)
            (run-command `("chmod" "+x" ,(build-path (*lehti-dist-directory*) name "bin" f)))
            (create-symbolic-link (build-path (*lehti-dist-directory*) name "bin" f)
                                  (build-path (*lehti-bin-directory*) f)))
          (directory-list2 (build-path (*lehti-dist-directory*)
                                       name "bin")))))

    ))

