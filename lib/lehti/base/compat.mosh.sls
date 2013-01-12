
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

    string-split

    spawn
    call-process
    waitpid
    )
  (import
    (rnrs)
    (only (mosh)
          set-current-directory!
          string-split)
    (only (mosh process)
          call-process
          waitpid
          spawn)
    (only (mosh file)
          delete-directory
          create-directory
          directory-list
          create-symbolic-link
          file-symbolic-link?
          file-regular?
          file-directory?))
)
