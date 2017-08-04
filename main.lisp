(uiop:define-package :my-scripts/main
    (:use :cl
          :uiop
          :cl-scripting
          :inferior-shell
          :fare-utils
          :cl-launch/dispatch)
  (:export #:symlink
           #:help
           #:main))

(in-package :my-scripts/main)

(exporting-definitions
 (defun symlink (src)
   (let ((binarch (resolve-absolute-location `(,(subpathname (user-homedir-pathname) "bin/")) :ensure-directory t)))
     (with-current-directory (binarch)
       (dolist (i (cl-launch/dispatch:all-entry-names))
         (run `(ln -sf ,src ,i)))))
   (success))

 (defun help ()
   (format! t "~A commands: ~{~A~^ ~}~%" (get-name) (all-entry-names))
   (success))

 (defun main (&rest args)
    (format t "main~%")))

(register-commands :my-scripts/main)
