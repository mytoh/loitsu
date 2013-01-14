
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
    (only (mosh)
          set-current-directory!
          current-directory
          string-split)
    (only (mosh process)
          call-process
          waitpid
          spawn)
    (only (mosh file)
          delete-directory
          create-directory
          file->list
          create-symbolic-link
          file-symbolic-link?
          file-regular?
          directory-list
          file-directory?))
)
