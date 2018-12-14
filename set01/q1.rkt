;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; q1.rkt : A Program to determine the volume and surface area of an equilateral cube 

;; Goal: Compute the volume and surface area of an equilateral cube 

(require rackunit)
(require "extras.rkt")

(provide cvolume)
(provide csurface)

;; DATA DEFINATIONS: none

;;cvolume: PosReal -> PosReal
;;GIVEN: length of an equilateral cube,
;;RETURNS: the volume of the equilateral cube.
;;EXAMPLES:
;;(cvolume 10) = 1000
;;(cvolume 2) = 8
;;DESIGN STRATEGY: Combine simpler functions

(define (cvolume length)
  (* length (* length length)))

;;TESTS
(begin-for-test
  (check-equal? (cvolume 10) 1000
                " The volume of the equilateral cube of length 10 is 1000")
  (check-equal? (cvolume 2) 8
                " The volume of the equilateral cube of length 2 is 8"))

;;csurface: PosReal -> PosReal
;;GIVEN: length of an equilateral cube,
;;RETURNS: the surface area of the equilateral cube.
;;EXAMPLES:
;;(csurface 2) = 24
;;(csurface 10) = 600
;;DESIGN STRATERGY: Combine simpler functions

(define (csurface length)
  (* 6 (sqr length)))

;;TESTS
  (begin-for-test
    (check-equal? (csurface 2) 24
                  " The surface area of the cube of length 2 is 24")
    (check-equal? (csurface 10) 600
                  " The surface area of the cube of length 10 is 600"))