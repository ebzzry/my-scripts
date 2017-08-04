(uiop:define-package
    :scripts/apps
    (:use
     :cl
     :fare-utils
     :uiop
     :inferior-shell
     :cl-scripting
     :cl-launch/dispatch)
  (:export #:chrome
           #:kill-chrome
           #:stop-chrome
           #:continue-chrome))

(in-package :scripts/apps)

(exporting-definitions
 (defun chrome (&rest args)
   (run/i `(google-chrome-beta ,@args)))

 (defun kill-chrome (&rest args)
   (run `(killall ,@args chromium-browser chromium google-chrome chrome)
        :output :interactive :input :interactive :error-output nil :on-error nil)
   (success))

 (defun stop-chrome ()
   (kill-chrome "-STOP"))

 (defun continue-chrome ()
   (kill-chrome "-CONT")))

(register-commands :scripts/apps)
