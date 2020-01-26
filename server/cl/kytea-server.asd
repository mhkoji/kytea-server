(asdf:defsystem :kytea-server
  :serial t
  :components
  ((:file "kytea-server"))
  :depends-on (:clack
               :ningle
               :jonathan

               :cl-kytea))
