(uiop:define-package :my-scripts/main
    (:use #:cl
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:fare-utils
          #:cl-launch/dispatch)
  (:export #:getuid
           #:symlink
           #:help
           #:main))

(in-package #:my-scripts/main)

(exporting-definitions
  (defun getuid ()
    #+sbcl (sb-posix:getuid)
    #+cmu (unix:unix-getuid)
    #+clisp (posix:uid)
    #+ecl (ext:getuid)
    #+ccl (ccl::getuid)
    #+allegro (excl.osi:getuid)
    #-(or sbcl cmu clisp ecl ccl allegro) (error "no getuid"))

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
