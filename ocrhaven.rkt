#lang racket

;Author: C Lam
;Created On: 4/13/16
;File: ocrhaven.rkt

;This file implements functions that allow the user to send a specified file to haven on demand OCR api
;using my api key and the curl system command 

(require racket/string)
(require racket/system)

;(define (ocr-haven-file file-path)
;"curl -X POST --form \"file=@grocerytest.jpg\" --form \"apikey=82833b89-515e-4727-97ff-d8af21d53be3\" https://api.havenondemand.com/1/api/sync/ocrdocument/v1"
;"curl -X POST --form \"file=@grocerytest.jpg\" --form \"apikey=82833b89-515e-4727-97ff-d8af21d53be3\" https://api.havenondemand.com/1/api/sync/ocrdocument/v1"

;(define casa "/Users/Cullin/Desktop/casa.jpg")

;This function takes as an argument a string path to an image file and
;constructs a curl command for haven ocr api  
(define (make-cmd path)
  (string-join (list "curl -X POST --form \"file=@" path "\" --form \"apikey=82833b89-515e-4727-97ff-d8af21d53be3\" https://api.havenondemand.com/1/api/sync/ocrdocument/v1") ""))

;;This function takes a string path to an image file and calls Curl on the haven ocr api url with the given file
;;returns a string with response, empty string is returned if failed or error 
(define (ocr-file path)
  (with-output-to-string (lambda () (system (make-cmd path)))))