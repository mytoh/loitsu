
(library (lehti commands clone)
  (export
    clone)
  (import
    (scheme base)
    (srfi :48)
    (lehti env)
    (lehti util)
    (lehti scm)
    (loitsu file)
    (loitsu process))

  (begin

    (define (clone args)
      (let ((name (caddr args)))
        (cond
          ((package-available? name)
           (let* ((lehfile (file->sexp-list (build-path (*lehti-leh-file-directory*)
                                                             (path-swap-extension name "leh"))))
                  (url (cadr (assoc 'url lehfile))))
             (cond
               ((url-is-git? url)
                (run-command `(git clone -q ,url ,name)))))))))

    ))


