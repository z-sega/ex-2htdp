;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname comparing-local-definitions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
(define (listing l)
   (foldr string-append-with-space " "
          (sort (map address-first-name l) string<?)))

; String String -> String
; joins two strings, separates them with " "
(define (string-append-with-space s t)
  (string-append " " s t))

; -- local-definitions:
; [List-of Addr] -> String
; creates a tring of first names,
; sorted in alphabetical order,
; separated and surrounded by blank spaces
(check-expect (listing laddr)
              (listing.v2 laddr))
(define (listing.v2 l)
  (local (; 1. extract names
          (define names (map address-first-name l))
          ; 2. sort the names
          (define sorted (sort names string<?))
          ; 3. append them, add spaces
          (define concat+space
            (local (; String String -> String
                    (define (helper s t)
                      (string-append " " s t)))
              ; - IN -
              (foldr helper " " sorted))))
    ; - IN -
    concat+space))