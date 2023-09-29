;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-104) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; -- ex-104.rkt
;; Your home town manages a fleet of vehicles: automobiles,
;; vans, buses, and SUVs. Develop a data representation of
;; vehicles. The representation of each vehicle must describe
;; the number of passengers that it can carry, its license
;; plate number, and its fuel consumption (miles per gallon).
;; Develop a template for functions that consume vehicles.

(define-struct vehicle [passengers license fuelConsumption])
; A Vehicle is a structure:
;   (make-vehicle Number String Number)
; *interp.*(make-vehicle p l f) describes a vehicle that can
; carry p passengers, has a license plate number l, and has
; a fuel consumption of miles per gallon
(define automobile (make-vehicle 5 "AUT022" 7.2))
(define van (make-vehicle 12 "VAN930" 6.3))
(define bus (make-vehicle 25 "BUS390" 5.0))
(define suv (make-vehicle 8 "SUV230" 6.8))

; -- template:
; Vehicle -> ...
; template for consuming Vehicle v
(define (consume-vehicle v)
  (... (vehicle-passengers v)
       (vehicle-license v)
       (vehicle-fuelConsumption v)))
  