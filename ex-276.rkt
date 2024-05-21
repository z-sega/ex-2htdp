#lang htdp/isl+
(require 2htdp/itunes)

;; ex-276
;; Real-World Data: iTunes explains how to analyze the information
;; in an iTunes XML library.

;(define-struct date [year month day hour minute second])
; A Date is a structure:
;   (make-date N N N N N N)
; *intepretation* An instance records six pieces of information:
; the date's year, month (between 1 and 12 inclusive),
; day (between 1 and 31), hour (between 0 and 23), minute
; (between 0 and 59), and second (also between 0 and 59).
(define d1 (create-date 2002 7 17 3 55 14))
(define d2 (create-date 2011 5 17 17 35 13))
(define d3 (create-date 2007 5 3 13 30 0))
(define d4 (create-date 2023 12 6 11 35 13))

;; (define-struct track
;;   [name artist album time track# added play# played])
; A Track is a structure:
;   (make-track String String String N N Date N Date)
; *intepretation* An instance records in order: the track's
; title, its producing artist, to which album it belongs,
; its playing time in milliseconds, its position within the
; album, the date it was added, how often it has been
; played, and the date when it was last played
(define t1 (create-track "Wild Child" "Enya" "A Day Without Rain"
                       227996 2 d1 20 d2))
(define t2 (create-track "Modern Drummer" "Ungdomskulen" "Cry-Baby"
                       326000 4 d3 60 d4))
(define t3 (create-track "Only Time" "Enya" "A Day Without Rain"
                       227996 3
                       (create-date 2002 7 17 3 55 42)
                       18
                       (create-date 2015 7 17 17 38 47)))

(define t4 (create-track "Bad Habits" "Ed Sheeran" "="
                         223000 8
                         (create-date 2022 10 1 9 30 0)
                         75
                         (create-date 2023 3 15 22 45 17)))
(define t5 (create-track "As It Was" "Harry Styles" "Harry's House"
                         167000 1
                         (create-date 2022 5 20 14 22 30)
                         120
                         (create-date 2023 1 10 11 47 53)))

(define t6 (create-track "Pleasure" "Ungdomskulen" "Cry-Baby"
                         262000 5
                         (create-date 2021 8 15 20 10 0)
                         42
                         (create-date 2023 4 30 17 22 15)))
(define t7 (create-track "Some" "Ungdomskulen" "Cry-Baby"
                         295000 6
                         (create-date 2021 9 1 12 45 0)
                         55
                         (create-date 2023 2 28 9 18 27)))

; [List-of Track]
(define lt (list t1 t2 t3 t4 t5 t6 t7))

;; - Design select-album-date.
;; The function consumes the title of an album, a date, and
;; an LTracks. It extracts from the latter the list of tracks from
;; the given album that have been played after the date.

; String Date [List-of Track] -> [List-of Track]
; extracts tracks from lt0 given a that have been played after d
(check-expect (select-album-date "8 Mile"
                                 (create-date 2015 6 17 17 38 47)
                                 lt)
              '())
(check-expect (select-album-date "A Day Without Rain"
                                 (create-date 2017 6 17 17 38 47)
                                 lt)
              '())
(check-expect (select-album-date "A Day Without Rain"
                                 (create-date 2015 6 17 17 38 47)
                                 lt)
              (list t3))

(define (select-album-date a d lt0)
  (local (; Track [List-of Track] -> [List-of Track]
          ; accumulates tracks from album a
          ; played after date d
          (define (select-tracks t acc)
            (if (and (eq? a (track-album t))
                     (date< d (track-played t)))
                (cons t acc)
                acc)))
    (foldr select-tracks '() lt0)))


; Date Date -> Boolean
; determines whether date a occurs before date b
(check-expect (date< d2 d1) #f)
(check-expect (date< d1 d2) #t)
(check-expect (date< d3 d4) #t)
(check-expect (date< (create-date 2000 1 1 1 1 0)
                     (create-date 2000 1 1 1 1 0))
              #f)
(check-expect (date< (create-date 2000 1 1 1 1 0)
                     (create-date 2000 1 1 1 1 1))
              #t)
(check-expect (date< (create-date 2000 1 1 1 1 1)
                     (create-date 2000 1 1 1 1 0))
              #f)

(define (date< a b)
  (cond
    [(< (date-year a) (date-year b))
     #t]
    [(and (eq? (date-year a) (date-year b))
          (< (date-month a) (date-month b)))
     #t]
    [(and (eq? (date-year a) (date-year b))
          (eq? (date-month a) (date-month b))
          (< (date-day a) (date-day b)))
     #t]
    [(and (eq? (date-year a) (date-year b))
          (eq? (date-month a) (date-month b))
          (eq? (date-day a) (date-day b))
          (< (date-hour a) (date-hour b)))
     #t]
    [(and (eq? (date-year a) (date-year b))
          (eq? (date-month a) (date-month b))
          (eq? (date-day a) (date-day b))
          (eq? (date-hour a) (date-hour b))
          (< (date-minute a) (date-minute b)))
     #t]
    [(and (eq? (date-year a) (date-year b))
          (eq? (date-month a) (date-month b))
          (eq? (date-day a) (date-day b))
          (eq? (date-hour a) (date-hour b))
          (eq? (date-minute a) (date-minute b))
          (< (date-second a) (date-second b)))
     #t]
    [else #f]))

;; - Design select-albums.
;; The function consumes an LTracks. It produces a list of
;; LTracks, one per album. Each album is uniquely identified 
;; by its title and shows up in the result only once.

; [List-of Track] -> [List-of [List-of Track]]
; produces a list of tracks for each album in the given lt
(check-expect (select-albums lt)
              (list (list t1 t3)
                    (list t4)
                    (list t5)
                    (list t2 t6 t7)))
(define (select-albums lt0)
  (local (; fetch all albums in lt0
          (define ALBUMS
            (local (; String [List-of String] -> [List-of String]
                    ; accumulate a with albums only if a is unique
                    (define (acc-unique-album a acc)
                      (if (member? a acc) acc
                          (cons a acc))))
              (foldr acc-unique-album '() (map track-album lt0))))
          
          ; group tracks by ALBUMS
          (define (acc-by-album a acc)
            (local (; Track -> Boolean
                    ; #t if the track is in album a
                    (define (in-album? t)
                      (eq? (track-album t) a)))
              (cons (filter in-album? lt0) acc))))
    (foldr acc-by-album '() ALBUMS)))
