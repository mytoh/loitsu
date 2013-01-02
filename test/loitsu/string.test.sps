
(import
  (rnrs)
  (pieni check)
  (loitsu string))


;; pluralize
(check (pluralize 10 "dog") => "10 dogs")
(check (pluralize 1 "cat") => "1 cat")
(check (pluralize 0 "octopus" "octopodes") => "0 octopodes")

;; dasherize
(check (dasherize "setSize") => "set-size")
(check (dasherize "theURL") => "the-url")
(check (dasherize "ClassName") => "class-name")
(check (dasherize "LOUD_CONSTANT") => "loud-constant")
(check (dasherize "the_CRAZY_train") => "the-crazy-train")
(check (dasherize "with-dashes") => "with-dashes")
(check (dasherize "with_underscores") => "with-underscores")

;; underscore
(check (underscore "setSize") => "set_size")
(check (underscore "theURL") => "the_url")
(check (underscore "ClassName") => "class_name")
(check (underscore "LOUD_CONSTANT") => "loud_constant")
(check (underscore "the_CRAZY_train") => "the_crazy_train")
(check (underscore "with-dashes") => "with_dashes")
(check (underscore "with_underscores") => "with_underscores")

;; x->string
(check (x->string 'a) => "a")
(check (x->string 1) => "1")
(check (x->string '(1 2)) => "(1 2)")

(check-report)
