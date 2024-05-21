;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-307) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-307
;; Define find-name. The function consumes a name and
;; a list of names. It retrieves the first name on the
;; latter that is equal to, or an extension of, the former.

(require 2htdp/abstraction)

; A [Maybe X] is one of:
; - #false
; - X
; [Maybe String]
; *interpretation* a string or the absence of some
; desired string as #false

; String [List-of String] -> [Maybe String]
; retrieves the first name on los that is equal to
; n or an extension of n

(check-expect (find-name "elis" '()) #false)
(check-expect (find-name "elis" (list "elsa"
                                      "backanon"
                                      "elisium"))
              "elisium")
(check-expect (find-name "essa" (list "elsa"
                                      "backanon"
                                      "elisium"))
              #false)

(define (find-name s los)
  (for/or ([sl los]) (if (string-contains? s sl)
                         sl
                         #false)))

;; Define a function the ensures that no name on some list
;; of names exceeds some given width. Compare with ex-271.


; Number [List-of String] -> Boolea
; #true if no name on los exceeds n
(check-expect (within-width? 2 '("so" "I" "have")) #false)
(check-expect (within-width? 2 '("so" "I" "c")) #true) 
              
(define (within-width? n los)
  (for/and ([sl los]) (<= (string-length sl) n)))
