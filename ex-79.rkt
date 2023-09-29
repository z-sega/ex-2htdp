#lang htdp/bsl

; A Color is one of:
; - "white"
; - "yellow"
; - "orange"
; - "green"
; - "red"
; - "blue"
; - "black"
(define NEUTRAL "white")
(define ERROR "red")

; H is a Number between 0 and 100.
; *interpretation* represents a happiness value
(define DEPRESSED 0)
(define MEH 50)
(define OVERJOYED 100)

(define-struct person [fstname lstname male?])
; A Person is a structure:
;   (make-person String String Boolean)
(define FIRSTNAME 'Turing)
(define LASTNAME 'Alan)
(define ISMALE #t)
(define ISFEMALE #f)
(define NEWGUY (make-person FIRSTNAME LASTNAME ISMALE))
(define NEWGAL (make-person LASTNAME FIRSTNAME ISMALE))

(define-struct dog [owner name age happiness])
; A Dog is a structure
;   (make-dog Person String PositiveInteger H)
; *interpretation*
; represents a dog where:
; - owner: dog has an owner which is a Person
; - name: dog has a name which is a String
; - age: dog has age, a Positiveinteger
; - happiness: measure of dog's happiness which is an H
(define NAME "Jojo")
(define AGE 5)
(define NEWDOG (make-dog
                NEWGUY
                NAME
                AGE
                MEH))

; A Weapon is one of:
; - #false
; - Posn
; *interpretation*
; #false means the missile hasn't been fired yet;
; a Posn means it is in flight
(define NUCLEAR #false)

(define p1 (make-posn 30 50))
(define p2 (make-posn 5 3))
(define NAPALM p1)
(define MISSILE p2)
