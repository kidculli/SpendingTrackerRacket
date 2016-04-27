#lang racket

;Author: C Lam, J Kucynzki 
;Created On: 4/13/16
;File: ocrhaven.rkt

;****************************************************************************************************************
;This file implements functions that allow the user to send a specified file to haven on demand OCR api
;using my api key and the curl system command 

;; for OCR and Curl 
(require racket/string)
(require racket/system)
;;for mongo database 
(require db/mongodb/basic/main)
(require db/mongodb/orm/dict)
(require net/bson
         net/bson/read)
;; for parsing response 
(require racket/date)
(require plot)
(require data/ring-buffer)
;;  user functions *************************************
(define (ocr-insert path)
  ;; calls haven api, parse respsonse to list of $ values, gets last $ value, removes dollar sign, converts to number , inserts into db  
  (insert-purchase (current-milliseconds) (str-to-num (trimmer (last (rs (ocr-file path)))))))

(define (graph-week)
  (let ((week-purchases (query-purchases)))
    (begin
      (define s (storeDays))
      (s 'load-and-get-graph week-purchases))))
  

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

;****************************************************************************************************************

;; connect to my digital ocean mongo server 
(define conn (create-mongo #:host "159.203.164.155" #:port 27017))
;; connect to OplSpendingTracker database 
(define d (make-mongo-db conn "OplSpendingTracker"))
;; set collection as purchases collection 
(define purchases (mongo-collection d "purchases"))

;; make a dict object for collection insert 
;(define doc2 (make-hasheq  (list (cons 'date_created 21212121212) (cons 'value 21))))
;(mongo-collection-insert-one! purchases doc2)

;; This function inserts a record into purchases collection.
;; Args:
;;    date_created: number (date in ms)
;;    value: number total purchase cost 
(define (insert-purchase date_created value)
  (let((record (make-hasheq (list (cons 'date_created date_created) (cons 'value value)))))
    (mongo-collection-insert-one! purchases record)))

(define week-ms 604800000)
(define month-ms (* week-ms 4.42857143))


(date->string (seconds->date (/ (current-milliseconds) 1000)))
;; find all records in collection

(define (query-purchases)
  (let ((res (mongo-collection-find purchases (make-hasheq '()))))
    (for/list ([e res]) (cons (hash-ref e 'date_created) (hash-ref e 'value)))))

(define query (mongo-collection-find purchases (make-hasheq '())))
(define (find-week records)
  (filter (lambda (record)
            (if(<= (- (current-milliseconds) (car record)) week-ms)
               #t
               #f)) records))

(define (find-month records)
  (filter (lambda (record)
            (if(<= (- (current-milliseconds) (car record)) month-ms)
               #t
               #f)) records))

;; iterate through cursor and return a list of cons pairs (date_created, value)
;(define raw (for/list ([e query]) e))
;(define ids (for/list ([e raw]) (hash-ref e '_id)))
(define result (for/list ([e query]) (cons (hash-ref e 'date_created) (hash-ref e 'value))))

;; get datetime from object id in mongo ! 
;;(define result (for/list ([e query]) (cons (bson-objectid-timestamp (hash-ref e '_id)) (hash-ref e 'value))))

;;(define date-obj (seconds->date (caar result)))
;;(date->string date-obj)

;****************************************************************************************************************

;(plot (discrete-histogram (list #(A 1) #(B 2) #(B 3) (vector 'C (ivl .5 1.5)) #(Day 5))))
(define WeekNum 604800000)
(define DayNum 86400000)
(define A (- 1461323897173.5686 (+ (* 2 604800000) (* 2 86400000))))



;This will get all of the stuff in the past week. Next, store them in the appropriate containers, and remember; the current day
; could be done twice. If today is Sunday, could get results from this Sunday, and last Sunday, so figure out the day this is,
; and for that day, run another filter which uses DayNum to ensure that last Sunday isn't included.
(define (WeekList lst)
  (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) WeekNum))) lst)
)


(define (storeDays)
  (begin
    (define Sunday '())
    (define Monday '())
    (define Tuesday '())
    (define Wednesday '())
    (define Thursday '())
    (define Friday '())
    (define Saturday '())
    (define rb (empty-ring-buffer 7))
    (define Flag -1)
    (define graphList '())
    (lambda (command lst)
      (cond
        [(equal? command 'load-and-get-graph)
         (set! Sunday (get-Sunday lst))
         (set! Monday (get-Monday lst))
         (set! Tuesday (get-Tuesday lst))
         (set! Wednesday (get-Wednesday lst))
         (set! Thursday (get-Thursday lst))
         (set! Friday (get-Friday lst))
         (set! Saturday (get-Saturday lst))
         (ring-buffer-set! rb 0 (cons 'Sun (sum Sunday)))
         (ring-buffer-set! rb 1 (cons 'Mon (sum Monday)))
         (ring-buffer-set! rb 2 (cons 'Tues (sum Tuesday)))
         (ring-buffer-set! rb 3 (cons 'Wed (sum Wednesday)))
         (ring-buffer-set! rb 4 (cons 'Thurs (sum Thursday)))
         (ring-buffer-set! rb 5 (cons 'Fri (sum Friday)))
         (ring-buffer-set! rb 6 (cons 'Sat (sum Saturday)))
         (set! Flag (day))
;At this point use or call modulus
         (set! graphList (list 
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 1) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 1) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 2) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 2) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 3) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 3) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 4) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 4) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 5) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 5) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 6) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 6) 7))))
              (vector (car (ring-buffer-ref rb (modulo (+ Flag 7) 7))) (cdr (ring-buffer-ref rb (modulo (+ Flag 7) 7))))
                          )
           )
         (let ((today (current-milliseconds)))
          (plot (discrete-histogram graphList)
                 #:title (string-join (list "Total Spending for Week" (date->string (seconds->date(/ (+ (- today week-ms) DayNum) 1000))) "to" (date->string (seconds->date (/ today 1000)))) " ")
                 #:x-label "Day of the Week"
                 #:y-label "Amount Spent $"
                 ))

         ]
       )
      )
    )
  )


(define (get-Sunday lst)
  (if (regexp-match #rx"Sunday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Sunday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Sunday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)

(define (get-Monday lst)
  (if (regexp-match #rx"Monday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Monday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Monday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)

(define (get-Tuesday lst)
  (if (regexp-match #rx"Tuesday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Tuesday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Tuesday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)

(define (get-Wednesday lst)
  (if (regexp-match #rx"Wednesday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Wednesday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Wednesday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)


(define (get-Thursday lst)
  (if (regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)


(define (get-Friday lst)
  (if (regexp-match #rx"Friday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Friday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Friday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)

(define (get-Saturday lst)
  (if (regexp-match #rx"Saturday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 
    (filter (lambda (n) (regexp-match #rx"Saturday" (date->string (seconds->date (* .001 (car n)))))) (filter (lambda (n) (> (car n) ( - (current-inexact-milliseconds) DayNum))) lst))
    (filter (lambda (n) (regexp-match #rx"Saturday" (date->string (seconds->date (* .001 (car n)))))) (WeekList lst))
  )  
)


(define (sum lst)
  (cond
    [(equal? lst '()) 0]
    [else (+ (cdr (car lst)) (sum (cdr lst)))]
  )
)



(define (day)
  (cond
    [(regexp-match #rx"Sunday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 0]
    [(regexp-match #rx"Monday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 1]
    [(regexp-match #rx"Tueday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 2]
    [(regexp-match #rx"Wednesday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 3]
    [(regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 4]
    [(regexp-match #rx"Friday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 5]
    [(regexp-match #rx"Saturday" (date->string (seconds->date (* .001 (current-inexact-milliseconds))))) 6]
  )
)


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
    (set! string (string-trim string))
    (set! string (noSpace string))
    string
  )
)

(define (noSpace string)
  (mytrim string (regexp-match-positions* #rx"[0-9\\.]" string)))


(define (mytrim string list)
  (cond
    [(null? list) ""]
    [(string-append (substring string (car (car list)) (cdr (car list))) (mytrim string (cdr list)))]
  )
)

(define (str-to-num string)
  (string->number string)
)


;> (define r (last (rs json-str)))
;> (define s (str-to-num (trimmer r)))
;>
;>

;>(date->string (seconds->date (current-seconds)))
;>(date->string (current-date)
;https://docs.racket-lang.org/reference/time.html#%28mod-path._racket%2Fdate%29


;EXAMPLE OF GETTING A GRAPH
;> (define s(storeDays))
;> (s 'load-and-get-graph '( (1461323897173.5686 . 49) (1461323897100.5686 . 50) (1459941500000 . 30)))
;A Correct graph
;>


;> (equal? "Thursday" (car (regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (current-inexact-milliseconds)))))))
;#t
;WORKS FOR TODAY
;; ************************ END OF FILE *********************************

