;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-103) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-103.rkt
;; Develop a data representation for the following four
;; kinds of zoo animals:
;; 
;; spiders, whose relevant attributes are the number of
;; remaining legs (we assume that spiders can lose legs
;; in accidents) and the space they need in case of
;; transport.
;; 
;; elephants, whose only attributes are the space they
;; need in case of transport
;;
;; boa constrictors, whose attributes include length and
;; girth; and
;;
;; armadillos, for which you must determine appropriate
;; attributes, including one that determines the space
;; needed for transport

; Number -> Boolean
; Returns #t if n is a positive integer

(check-expect (positive-integer? 3) #t)
(check-expect (positive-integer? -4) #f)
(check-expect (positive-integer? 0.4) #f)

(define (positive-integer? n)
  (and (integer? n) (positive? n)))

; An AnimalAttr is one of:
; - Real Number
; - Natural Number
; #true
; #false
; *interp.* Real Number is used to represent dimensional
; quantities like length, girth, width or volume.
; Natural Number is used to represent quantities that
; can be counted like the number of legs.
; #true is used to represent applicability for a Boolean
; AnimalAttr
; #false is used to represent the absence of an
; AnimalAttr
(define length-of-snake 44) ; -- 44 units of length
(define num-of-legs 3)  ; -- 3 legs
(define num-of-legs2 #f) ; -- no legs


(define-struct ZooAnimal [legs space length girth covering?])
; A ZooAnimal is a structure:
;   (make-ZooAnimal
;     AnimalAttr AnimalAttr AnimalAttr AnimalAttr AnimalAttr)
; *interp.*
; (make-ZooAnimal lgs s len g c) describes a zoo animal
; that has lgs legs,
; requires s space in case of transport,
; is len long, with g girth,
; and requires c covering?
(define spider (make-ZooAnimal 7 20 #f #f #f))
(define elephant (make-ZooAnimal #f 1000 #f #f #f))
(define boa (make-ZooAnimal #f #f 70 23 #f))

(define armadillos (make-ZooAnimal #f 100 #f #f #t))
; armadillos need to be covered during transportation.


; -- template for consuming ZooAnimal
(define (consume-animal z)
  (... (ZooAnimal-legs z)
       (ZooAnimal-space z)
       (ZooAnimal-length z)
       (ZooAnimal-girth z)
       (ZooAnimal-covering? z)))


(define-struct cage [length width height])
; A Cage is a structure:
;  (make-cage Number Number Number)
; *interp.*(make-cage l w h) describes a cage of
; length l, width w, and height h.
(define cage1 (make-cage 4 5 5))

; -- fits?
; ZooAnimal Cage -> Boolean
; Returns #t if the given ZooAnimal z can
; be contained in the Cage c

(check-expect (fit? spider cage1) #t)
(check-expect (fit? elephant cage1) #f)

(define (fit? z c)
  (> (calc-volume c) (ZooAnimal-space z)))
         
; Cage -> Number
; Returns the volume of the given Cage c

(check-expect (calc-volume cage1)
              (* (cage-length cage1)
                 (cage-width cage1)
                 (cage-height cage1)))

(define (calc-volume c)
  (* (cage-length cage1)
     (cage-width cage1)
     (cage-height cage1)))
  
