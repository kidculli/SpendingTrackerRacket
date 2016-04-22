#lang racket

(require (prefix-in h: html)
           (prefix-in x: xml))
(require json)
(require plot)
(require racket/date)
(require data/ring-buffer)


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
          (plot (discrete-histogram graphList))

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


;> (define r (last (rs json-str)))
;> (define s (str-to-num (trimmer r)))
;>
;>

;>(date->string (seconds->date (current-seconds)))
;>(date->string (current-date)
;https://docs.racket-lang.org/reference/time.html#%28mod-path._racket%2Fdate%29


;> (date->string (seconds->date (* .001 (- (current-inexact-milliseconds) WeekNum))))
;"Thursday, April 14th, 2016"


;EXAMPLE OF GETTING A GRAPH
;> (define s(storeDays))
;> (s 'load-and-get-graph '( (1461323897173.5686 . 49) (1461323897100.5686 . 50) (1459941500000 . 30)))
;A Correct graph
;>


;> (equal? "Thursday" (car (regexp-match #rx"Thursday" (date->string (seconds->date (* .001 (current-inexact-milliseconds)))))))
;#t
;WORKS FOR TODAY
;; ************************ END OF FILE *********************************
