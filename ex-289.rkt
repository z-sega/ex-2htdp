#lang htdp/isl+

;; ex-289
;; Use ormap to define find-name. The function consumes a name
;; and a list of names. It determines whether any of the names on
;; the latter are equal to or an extension of the former.

; [List-of String]
(define names (list "Jake" "Tinna" "Shiela" "Aaron" "Alex" "Zendaya"))

; String [List-of String] -> Boolean
; #t if any of the names on ln are equal to or contain n
(check-expect (find-name "Tin" names) #t)
(check-expect (find-name "Tyla" names) #f)
(check-expect (find-name "Aaron" names) #t)

(define (find-name n ln)
  (ormap (lambda (x)
           (string-contains? n x))
         ln))

;; With andmap you can define a function that checks all names on
;; a list of names that start with the letter "a".

; [List-of String] -> Boolean
; #t if all names on ln start with the letter "a"
(check-expect (all-start-with-a? names) #f)
(check-expect (all-start-with-a? (list "aaron" "alex"))
              #t)
(define (all-start-with-a? ln)
  (andmap (lambda (x) (equal? "a"
                              (string-downcase (first (explode x)))))
          ln))

;; Should you use ormap or andmap to define a function that ensures
;; that no name on some list exceeds some given width?

;; ->
;; You should use andmap to define such a function because that
;; abstraction can be used without obscuring the function's intention
;; ormap can be used also but the predicate will need to be inverted:
;; 'exceeds-some-given-width?' which will be true if any item
;; on the list exceeds that width; this way not every item on the list
;; will need to be checked all the time.

