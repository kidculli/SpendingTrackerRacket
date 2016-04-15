#lang racket

(require (prefix-in h: html)
           (prefix-in x: xml))
(require json)
 

;(define hello (read-json open-input-file "testing.json"))

(define file (open-input-file "testing.json"))
(define json-str (read-string 30000000 file))

(define hello2 "{ 
text_block: [ 
{ 
text: \" This is text.
$.49. Text $  35.64, Phone number (978) 670-2838, Total of $36.13\" 
} 
] 
} ")
;(define (rs string)
;  (regexp-match #rx"\\$[0-9]*\\..." string)
;)

(define (rs string)
  (regexp-match* #rx"\\$[0-9 \\s \\t \\n \\r \\f \\v]*\\..." string)
)

(define (last lst)
  (cond
    [(equal? lst '()) '()]
    [(equal? (cdr lst) '()) (car lst)]
    [else (last (cdr lst))]
  )
)

;Fix this trimmer so it will return string with only numbers and decimal point.
(define (trimmer string)
  (begin
    (define start 0)
    (set! start (car (car (regexp-match-positions #rx"[0-9 \\.]" string))))
    (substring string start (string-length string))
  )
)

(define (str-to-num string)
  (string->number string)
)

    
;; ************************ END OF FILE *********************************