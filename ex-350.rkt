;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-350) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-350
;; What is unusual about the definition of this program with respect
;; to the design recipe?
;; ->
;; There were no functional tests for the functions initially, tests
;; were added in ex-347.
;;
;; No local definitions were used; functions like parse-sl and parse-atom
;; are only useful in the context of parse. It is good practice to
;; make them local definitions of parse to clearly signal this to
;; future readers.
;;
;; **Also parse-sl's body is strange because of the nested cond clause.
;; The body has two main cond-clauses, but they are not based on the
;; definition of SL. The first clause checks if input-sl consists of
;; 3 s-expressions and if the first s-expression is a symbol, rather
;; than the usual pattern: check if empty (base), else process list.
;;
;; Finally, the functions signal ERRORs. This isn't something
;; that has happened since the 6th chapter.