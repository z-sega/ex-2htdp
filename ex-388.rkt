;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-388) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-388
;; In the real word, wages*.v2 consumes lists of employee
;; structures and lists of work records. An employee
;; structure contains an employee's name, social security
;; number, and pay rate. A work record also contains an
;; employee's name and the number of hours worked in a
;; week. The result is a list of structures that contain
;; the name of the employee and the weekly wage.
;;
;; Modify the program in this section so that it works on
;; these realistic versions of data. Provide the necessary
;; structure type definitions and data definitions. Use
;; the design recipe to guide the modification process.

(define-struct employee [name ssn pay])
; An Employee is a structure:
;   (make-employee String String Number)
; *interpretation*
; (make-employee "Derek" "938-938-389" 5.65) describes
; an employee named "Derek", with a social security
; number "938-938-389" getting payed at a rate of
; 5.65 units/h.
(define derek (make-employee "Derek" "938-938-389" 5.65))
(define trish (make-employee "Trish" "837-935-639" 8.75))

(define-struct work-record [name hours])
; A WorkRecord is a structure:
;  (make-work-record String Number)
; *interpretation*
; (make-work-record "Derek" 40.0) describes an
; employee named "Derek" who has worked 40.0 hours
; this week.
(define derek-wr (make-work-record "Derek" 40.0))
(define trish-wr (make-work-record "Trish" 30.0))

(define-struct weekly-wage [name wage])
; A WeeklyWage is a structure:
;   (make-weekly-wage String Number)
; *interpretation*
; (make-weekly-wage "Derek" 226.0) describes an
; employee named "Derek" who will be payed a weekly
; wage of 226.0
(define derek-ww (make-weekly-wage "Derek" 226.0))
(define trish-ww (make-weekly-wage "Trish" 262.5))

; [List-of Employee]
(define e* `(,derek ,trish))

; [List-of WorkRecord]
(define wr* `(,derek-wr ,trish-wr))

; [List-of WeeklyWage]
(define ww* `(,derek-ww ,trish-ww))

; [List-of Employee] [List-of WorkRecord]
; -> [List-of WeeklyWage]
; computes the weekly-wages* from employees and
; work-records
; *assume* the two lists are of equal length and
; they are organized symmetrically by employee's name
(check-expect (wages*.v2 '() '()) '())
(check-expect (wages*.v2 e* wr*) ww*)

(define (wages*.v2 employees work-records)
  (local (; Employee WorkRecord -> WeeklyWage
          ; computes the weekly wage from e and wr
          (define (weekly-wage e wr)
            (make-weekly-wage
             (employee-name e)
             (* (employee-pay e)
                (work-record-hours wr)))))

    (map weekly-wage employees work-records)))

