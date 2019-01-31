(uiop:define-package #:scripts/general
    (:use #:cl
          #:fare-utils
          #:uiop
          #:cl-scripting
          #:inferior-shell
          #:cl-launch/dispatch
          #:optima
          #:optima.ppcre
          #:local-time)
  (:export #:battery
           #:screenshot))

(in-package #:scripts/general)

(defvar *screenshots-dir*
  (subpathname (user-homedir-pathname) "Desktop/"))

(defun battery-status ()
  (let ((base-dir "/sys/class/power_supply/*")
        (exclude-string "/AC/"))
    (with-output (s nil)
      (loop :for dir :in (remove-if #'(lambda (path)
                                        (search exclude-string (native-namestring path)))
                                    (directory* base-dir))
            :for battery = (first (last (pathname-directory dir)))
            :for capacity = (read-file-line (subpathname dir "capacity"))
            :for status = (read-file-line (subpathname dir "status"))
            :do (format s "~A: ~A% (~A)~%" battery capacity status)))))

(exporting-definitions
 (defun battery ()
   (format t "~A" (battery-status))
   (values))

 (defun screenshot (mode)
   (let* ((dir *screenshots-dir*)
          (file (format nil "~A.png" (format-timestring nil (now))))
          (dest (format nil "mv $f ~A" dir))
          (image (format nil "~A/~A" dir file)))
     (flet ((scrot (file dest &rest args)
              (run/i `(scrot ,@args ,file -e ,dest))))
       (match mode
              ((ppcre "(full|f)") (scrot file dest))
              ((ppcre "(region|r)") (scrot file dest '-s))
              (_ (err (format nil "invalid mode ~A~%" mode))))
       (run `("xclip" "-selection" "clipboard" "-t" "image/png" ,image))
       (success)))))

(register-commands :scripts/general)
