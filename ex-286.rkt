#lang htdp/isl+

;; ex-286
;; An inventory record specifies the name of an inventory item,
;; a description, the acquisition price, and the recommended sales
;; price.
;;
;; Define a function that sorts a list of inventory records by the
;; difference between the two prices.
 
(define-struct IR [name desc acq-price rec-price])
; An IR is a structure:
;   (make-IR String String Number Number)
; *interpretation*
; (make-IR "blueberry" "smartphone" 480.00 500.00)
; describes an inventory item that is blueberry
; described as a smartphone acquired for 480.00
; to be sold at 500
(define blueberry
  (make-IR "blueberry" "smartphone" 480.00 500.00))
(define iphone
  (make-IR "iphone" "smartphone" 640.00 700.00))
(define soccer-ball
  (make-IR "soccer-ball" "fifa approved ball" 5.00 50.00))
(define toyota-corolla
  (make-IR "corolla" "small sedan" 2340.00 2700.00))

; [List-of IR]
(define target-inventory
  (list blueberry
        iphone
        soccer-ball
        toyota-corolla))

; [List-of IR] -> [List-of IR]
; sorts a loir in descending order of price-diff
; between recommended-price and acquisition-price
(check-expect (sort-inventory target-inventory)
              (list toyota-corolla
                    iphone
                    soccer-ball
                    blueberry))
(define (sort-inventory loir)
  (local (; IR -> Number
          ; compute the price-diff between the
          ; recommended price and the acquisition
          ; price
          (define (price-diff ir)
            (- (IR-rec-price ir) (IR-acq-price ir))))
    (sort loir (lambda (a b)
                 (> (price-diff a) (price-diff b))))))
