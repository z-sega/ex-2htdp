#lang htdp/bsl

(define-struct movie [title producer year])
; constructor: (make-movie title producer year)
; selectors:
; - (movie-title m)
; - (movie-producer m)
; - (movie-year m)
; predicate: (movie? m)

(define-struct person [name hair eyes phone])
; constructor: (make-person name hair eyes phone)
; selectors:
; - (person-name p)
; - (person-hair p)
; - (person-eyes p)
; - (person-phone p)
; predicate: (person? p)

(define-struct pet [name number])
; constructor: (make-pet name number)
; selectors:
; - (pet-name p)
; - (pet-number p)
; predicate: (pet? p)

(define-struct CD [artist title price])
; constructor: (make-CD artist title price)
; selectors:
; - (CD-artist cd)
; - (CD-title cd)
; - (CD-price cd)
; predicate: (CD? cd)

(define-struct sweater [material size producer])
; constructor: (make-sweater material size producer)
; selectors:
; - (sweater-material s)
; - (sweater-size s)
; - (sweater-producer s)
; predicate: (sweater?)
