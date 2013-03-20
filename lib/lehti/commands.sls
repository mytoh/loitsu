(library (lehti commands)
    (export
      environment
      completion
      specification
      clean
      contents
      clone
      print-commands
      list-packages
      setup
      update
      deinstall
      reinstall
      install
      search
      projects)
  (import
    (lehti commands commands)
    (lehti commands clone)
    (lehti commands setup)
    (lehti commands update)
    (lehti commands reinstall)
    (lehti commands clean)
    (lehti commands contents)
    (lehti commands deinstall)
    (lehti commands list)
    (lehti commands environment)
    (lehti commands specification)
    (lehti commands completion)
    (lehti commands install)
    (lehti commands search)
    (lehti commands projects)
    ))
