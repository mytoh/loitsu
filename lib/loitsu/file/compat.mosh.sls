(library (loitsu file compat)
    (export
      create-symbolic-link
      file-symbolic-link?
      file-regular?
      delete-directory
      directory-list
      file-directory?
      file-executable?
      file-writable?
      file-readable?
      file->string
      file-stat-mtime
      file-stat-ctime
      file-size-in-bytes
      create-directory
      set-current-directory!
      current-directory
      rename-file
      read-line)

  (import
    (except (rnrs)
            remove
            find)
    (only (mosh file)
          create-symbolic-link
          file-symbolic-link?
          file-regular?
          delete-directory
          directory-list
          file-directory?
          file-executable?
          file-writable?
          file-readable?
          file->string
          file-stat-mtime
          file-stat-ctime
          file-size-in-bytes
          rename-file
          create-directory)
    (only (mosh)
          set-current-directory!
          current-directory
          read-line)))
