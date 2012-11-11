
(library (napa git)
  (export
    git
    directory-git?)
  (import
    (scheme base)
    (scheme write)
    (only (rnrs)
          transcoded-port make-transcoder
          utf-8-codec)
    (srfi :8 receive)
    (only (srfi :13 strings)
          string-trim-right
          string-join
          string-index)
    (srfi :37 args-fold)
    (srfi :48 intermediate-format-strings)
    (mosh process)
    (irregex)
    (match)
    (loitsu process)
    )

  (begin
    (define (git-clone args)
      (let ((options (list (option '(#\p "private") #f #f
                                   (lambda (opt name arg private)
                                     (values #t))))))
        (receive (private)
          (args-fold args
                     options
                     (lambda (option name args . seeds)
                       (error "unrecognized option:" name))
                     (lambda (operand private)
                       (values private))
                     #f)
          (cond
            (private
              (display "fetching repository from github")
              (newline)
              (if (string-index (cadr args) #\/)
                (run-command `(git clone ,(string-append "git@github.com:" (cadr args))))
                (run-command `(git clone ,(string-append "git@github.com:"
                                                         (string-trim-right (process-output->string "git config user.name"))
                                                         "/" (cadr args))))))
            (else
              (cond
                ((irregex-match (irregex "^http://.*|^git://.*") (car args))
                 (run-command `(git clone --depth 1 ,(car args))))
                (else
                  (display "fetching repository from github")
                  (newline)
                  (run-command `(git clone --depth 1  ,(string-append "git://github.com/" (car args)))))))))))

    (define (git-commit-push args)
      (run-command `(git commit -avm "'" ,(car args) "'"))
      (run-command `(git push)))


    (define (github-create-new-repository args)
      (let ((name (car args))
            (user (string-trim-right (process-output->string "git config user.name"))))
        (call-process (string-join `("curl" "-u" ,user "https://api.github.com/user/repos"
                                     "-d" ,(string-append
                                             "'{"
                                             "\"name\": " "\"" name "\""
                                             "}'"))))))
    (define (git-command args)
      (run-command (append '(git ) args)))

    (define (git args)
      (match (car args)
        ("st"
         (git-command `(status ,@(cdr args))))
        ("clone"
         (git-clone (cdr args)))
        ("cp"
         (git-commit-push (cdr args)))
        ("create"
         (github-create-new-repository (cdr args)))
        ("a"
         (git-command `("add" "-p" ,@(cdr args))))
        ("st"
         (git-command `("status")))
        ("ps"
         (git-command `("push" ,@(cdr args))))
        ((or "up" "pl")
         (git-command `("pull" ,@(cdr args))))
        ("df"
         (git-command `("diff" ,@(cdr args))))
        ("remote"
         ; default verobose
         (git-command `("remote" "-v" ,@(cdr args))))
        ("co"
         (git-command `("checkout" ,@(cdr args))))
        ;; github.com/zaiste/dotfiles
        ("changes"
         (spawn "git" '("log" "--pretty=format:%Cred%h %Cgreen(%cr) %C(bold blue)<%cn>%Creset %s " "--name-status")))
        ("short"
         (spawn "git" '("log" "--pretty=format:%Cred%h %Cgreen(%cr)\t %C(bold blue):%cn:%Creset %s")))
        ("lg"
         (spawn "git" '("log" "--graph" "--pretty=format:%Cred%h -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue):%an:%Creset" "--abbrev-commit" "--date=relative")))
        ("br"
         (git-command `("branch" ,@(cdr args))))
        (else
          (git-command `(,@args)))))

    (define (directory-git?)
      ;; get output as string
      (let-values ([(in out) (pipe)])
        (define (port->string p)
          (let loop ([ret '()][c (read-char p)])
            (if (eof-object? c)
              (list->string (reverse ret))
              (loop (cons c ret) (read-char p)))))
        (let-values ([(pid cin cout cerr) (spawn "git" '("rev-parse" "--is-inside-work-tree") (list #f out out))])
          (close-port out)
          (if (string=? "true\n" (port->string (transcoded-port in (make-transcoder (utf-8-codec)))))
            #t #f)
          (close-port in)
          (waitpid pid))))

    ))

;; vim:filetype=scheme
