
(library (lehti base compat)
  (export
    create-directory
    file-directory?
    set-current-directory!
    delete-directory
    file-regular?
    file-symbolic-link?
    create-symbolic-link
    directory-list
    file->list
    current-directory

    string-split

    spawn
    call-process
    waitpid
    )
  (import
    (rnrs)
    ))
