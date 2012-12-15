
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
    install)
  (import
    (lehti commands command)
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
    (lehti commands install)))
