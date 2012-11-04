
(library (napa)
  (export
    git
    directory-git?)
  (import
    (rnrs)
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
    (mosh pp))

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
              (call-process (string-join `("git" "clone" ,(string-append "git@github.com:" (cadr args)))))
              (call-process (string-join `("git" "clone"
                                           ,(string-append "git@github.com:"
                                                           (string-trim-right (process-output->string "git config user.name"))
                                                           "/" (cadr args)))))))
          (else
            (cond
              ((irregex-match (irregex "^http://.*|^git://.*") (car args))
               (call-process (string-join `("git" "clone" "--depth" "1" ,(car args)))))
              (else
                (display "fetching repository from github")
                (newline)
                (call-process (string-join `("git" "clone" "--depth" "1"  ,(string-append "git://github.com/" (car args))))))))))))

  (define (git-commit-push args)
    (call-process (string-join `("git" "commit" "-avm" ,(car args))))
    (call-process (string-join `("git" "push"))))


  (define (github-create-new-repository args)
    (let ((name (car args))
          (user (string-trim-right (process-output->string "git config user.name"))))
      (call-process (p (string-join `("curl" "-u" ,user "https://api.github.com/user/repos"
                                      "-d" ,(string-append
                                              "'{"
                                              "\"name\": " "\"" name "\""
                                              "}'")))))))

  (define (process-output->string cmd)
    (let-values (((cout status x) (call-process cmd)))
      cout))

  (define (git args)
    (match (car args)
      ("st"
       (call-process (string-join `("git" "status" ,@(cdr args)))))
      ("clone"
       (git-clone (cdr args)))
      ("cp"
       (git-commit-push (cdr args)))
      ("create"
       (github-create-new-repository (cdr args)))
      ("a"
       (call-process (string-join `("git" "add" "-p" ,@(cdr args)))))
      ("st"
       (call-process (string-join `("git" "status"))))
      ("ps"
       (call-process (string-join `("git" "push" ,@(cdr args)))))
      ((or "up" "pl")
       (call-process (string-join `("git" "pull" ,@(cdr args)))))
      ("df"
       (call-process (string-join `("git" "diff" ,@(cdr args)))))
      ("remote"
       ; default verobose
       (call-process (string-join `("git" "remote" "-v" ,@(cdr args)))))
      ("co"
       (call-process (string-join `("git" "checkout" ,@(cdr args)))))
      ;; github.com/zaiste/dotfiles
      ("changes"
       (spawn "git" '("log" "--pretty=format:%Cred%h %Cgreen(%cr) %C(bold blue)<%cn>%Creset %s --name-status")))
      ("short"
       (spawn "git" '("log" "--pretty=format:%Cred%h %Cgreen(%cr)\t %C(bold blue):%cn:%Creset %s")))
      ("lg"
       (spawn "git" '("log" "--graph" "--pretty=format:%Cred%h -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue):%an:%Creset" "--abbrev-commit" "--date=relative")))
      ("br"
       (call-process (string-join `("git" "branch" ,@(cdr args)))))
      (else
        (call-process (string-join `("git" ,@args))))))

  (define (directory-git?)
    (let-values (((out status x) (call-process "git rev-parse --git-dir")))
      (and (= status 0))))


  )

;; vim:filetype=scheme
