#lang htdp/isl+

;; ex-308
;; Design the function replace, which substitutes the
;; area code 713 with 281 in a list of phone records

(require 2htdp/abstraction)

(define-struct phone [area switch four])
; A Phone is a structure:
;   (make-phone N N N)
; *interpretation*
(define phone1 (make-phone 713 664 9993))
; describes a phone with area-code 713,
; switch-code 664, and a four digit number
; 9993.

; [List-of Phone]
(define input (list phone1
                    (make-phone 123 456 7890)
                    (make-phone 713 555 4321)
                    (make-phone 555 123 4567)))
(define result (list (make-phone 281 664 9993)
                     (make-phone 123 456 7890)
                     (make-phone 281 555 4321)
                     (make-phone 555 123 4567)))

; [List-of Phone] -> [List-of Phone]
; subsitutes the area-code 713 for 281 in ph-l
(check-expect (replace '()) '())
(check-expect (replace input) result)

(define (replace ph-l)
  (for/list ([ph ph-l])
    (match ph
      [(phone area switch four)
       (make-phone (if (equal? area 713)
                       281
                       area) switch four)])))

