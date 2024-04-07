;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname composing-with-abstractions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; fig.97 - creating a program with abstractions

(define-struct address [first-name last-name street])
; An Addr is a structure:
;   (make-address String String String)
; *interpretation* associates an address with a person's name
(define addr1 (make-address "Robert" "Findler" "South"))
(define addr2 (make-address "Matthew" "Flatt" "Canyon"))
(define addr3 (make-address "Shriram" "Krishna" "Yellow"))

; [List-of Addr]
(define laddr `(,addr1 ,addr2 ,addr3))

; [List-of Addr] -> String
; creates a string from first names,
; sorted in alphabetical order,
; separated and surrounded by blank spaces
(check-expect (listing laddr)
              " Matthew Robert Shriram ")
(define (listing l)
  (string-append
   " "
   (foldr string-append-with-space ""
          (sort (map address-first-name l) string<?))))

; String String -> String
; joins two strings, separates them with " "
(check-expect (string-append-with-space "Robert" "Matthew")
              "Robert Matthew")
(define (string-append-with-space s t)
  (string-append s " " t))
