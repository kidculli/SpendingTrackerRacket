#lang racket
(require db/mongodb/basic/main)
(require db/mongodb/orm/dict)
(require net/bson
         net/bson/read)
(require racket/date)

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

(define date-obj (seconds->date (caar result)))
(date->string date-obj)

;(define (mongo-obj)
;  (let ((conn (create-mongo #:host "159.203.164.155" #:port 27017)))
;    (let ((db (make-mongo-db conn "OplSpendingTracker")))
;      (let ((purchases (mongo-collection d "purchases")))
;        (lambda (message)
;          (cond((eq? message 'find)
;                
;        ))))
        
