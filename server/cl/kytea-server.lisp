(defpackage :kytea-server
  (:use :cl)
  (::export :start))
(in-package :kytea-server)

(defvar *handler* nil)

(defvar *kytea* (cl-kytea:load-kytea))

(defun tokenize (kytea string)
  (if string
      (cl-kytea:calculate-ws kytea string)
      nil))

(defun start (&key (port 5000)
                   (kytea *kytea*))
  (when *handler*
    (clack:stop *handler*))
  (let ((app (make-instance 'ningle:<app>)))
    (setf (ningle:route app "/api/v1/tokenize" :method :post)
          (lambda (params)
            (handler-case
                `(200 (:content-type "application/json")
                      (,(let ((string (cdr (assoc "string" params :test #'string=))))
                          (let ((words (tokenize kytea string)))
                            (jojo:to-json words)))))
              (error (e)
                `(200 (:content-type "application/json")
                      (,(jojo:to-json (list :|error| (format nil "~A" e)))))))))
    (setq *handler* (clack:clackup app :post port))))
