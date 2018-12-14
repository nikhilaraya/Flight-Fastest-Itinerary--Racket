;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q1.rkt : A list of doodads are generated on "t" or "q" key press and the
;;          oldest doodads are deleted from the list on "." key press

;; GOAL: A list of star doodads are added to the canvas on press of "t" key and
;;       a list of square doodads are added to the world on press of "q" key.
;;       The newly added doodads have their initial velocities vector rotated
;;       90 degrees clockwise from the initial velocity of the previously
;;       created star or square like doodads.On press of "." key the oldest
;;       star-like doodads are deleted from the list and oldest square-like
;;       doodads are deleted from the list.On pressing the "c" key the selected
;;       doodads change their color to the next color.If the doodads are not
;;       selected then pressing the "c" key will not have any effect.Any doodad
;;       can be selected or dragged. On selecting a doodad, a black circle is
;;       displayed at the mouse position.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require rackunit)
(require 2htdp/universe)
(require 2htdp/image)
(require "extras.rkt")


(check-location "04" "q1.rkt")

(provide animation
         initial-world
         world-after-tick
         world-after-key-event
         world-after-mouse-event
         world-paused?
         world-doodads-star
         world-doodads-square
         doodad-x
         doodad-y
         doodad-vx
         doodad-vy
         doodad-color
         doodad-selected?
         doodad-age)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINATIONS

;; a Color is one of
;; --"gold"
;; --"green"
;; --"blue"
;; --"gray"
;; --"olivedrab"
;; --"khaki"
;; --"orange"
;; --"crimson"

;; INTERPRETATION:
;; gold,green and blue are the colors of the star which change in the same
;; order one after the other after a core bounce on the star doodad
;; gray,olivedrab,khaki,orange,crimson are the colors of the square which
;; change in the same order one after the other after a core bounce on the
;; square doodad

;; EXAMPLES
(define green "green")
(define blue "blue")
(define gold "gold")
(define gray "gray")
(define olivedrab "olivedrab")
(define khaki "khaki")
(define orange "orange")
(define crimson "crimson")

;; TEMPLATE
;; color-fn: Color -> ??
;; (define (colour-fn colour)
;;   (cond
;;     [(string=? colour "gold") ...]
;;     [(string=? colour "green") ...]
;;     [(string=? colour "blue") ...]
;;     [(string=? colour "gray") ...]
;;     [(string=? colour "olivedrab") ...]
;;     [(string=? colour "khaki") ...]
;;     [(string=? colour "orange") ...]
;;     [(string=? colour "crimson") ...]))


(define-struct doodad(colour
                      shape
                      location
                      velocity
                      mouse-position
                      age select?))

;; A Doodad is a
;;    (make-doodad Color
;;                 Image
;;                 Location
;;                 Velocity
;;                 Mouse-Position
;;                 NonNegInteger
;;                 Boolean)
;; INTERPRETATION:
;; colour is of type Color which has the present color of the doodad
;; shape is either the star with 8 points and an inner radius of 10 pixels
;;       and outer radius of 50 pixels or it is a square with radius 71 pixels
;; location is of type Location which specifies the x and y co-ordinates of the
;;       center of the doodad
;; velocity is of type Velocity which specifies the velocity in the x direction
;;       and y direction
;; mouse-position is of type Mouse-position which is set when the particular
;;       doodad is selected
;; age is a NonNegInteger which specifies the age.Initially the age on creation
;;     of the doodad the age is zero and keeps increasing after every tick.
;; select? is Boolean value describes whether or not the doodad is selected

;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn d)
;;  (...
;;      (doodad-colour d)
;;      (doodad-shape d)
;;      (doodad-location d)
;;      (doodad-velocity d)
;;      (doodad-mouse-position d)
;;      (doodad-age d)
;;      (doodad-select? d)))

(define-struct location (x y))

;; A Location is a
;;    (make-location Integer Integer)
;; INTERPRETATION:
;; x specifies the x co-ordinate of the center of the doodad
;; y specifies the y co-ordinate of the center of the doodad

;; TEMPLATE:
;; location-fn : Location -> ??
;; (define (location-fn l)
;;   (...
;;        (location-x l)
;;        (location-y l)))

(define-struct velocity (vx vy))

;; A Velocity is a
;;    (make-velocity Integer Integer)
;; INTERPRETATION:
;; vx specifies the number of pixels the doodad should move on each tick in the
;;    x direction
;; vy specifies the number of pixels the doodad should move on each tick in the
;;    y direction

;; TEMPLATE:
;; velocity-fn : Velocity -> ??
;; (define (velocity-fn v)
;;    (...
;;         (velocity-vx v)
;;         (velocity-vy v)))

(define-struct mouse-position (mx my))

;; A Mouse-Position is a
;;    (make-mouse-position Integer Integer)
;; INTERPRETATION:
;; mx specifies the x co-ordinate of the mouse-pointer on the selected doodad
;; my specifies the y co-ordinate of the mouse-pointer on the selected doodad

;; TEMPLATE:
;; mouse-position-fn : Mouse-Position -> ??
;; (define (mouse-position-fn m)
;;   (...
;;        (mouse-position-mx m)
;;        (mouse-position-my m)))

;; A List of Doodads (LOD) is either:
;; -- empty
;; --(cons Doodad LOD)

;; TEMPLATE:
;; lod-fn : LOD -> ??
;; HALTING MEASURE:(length lst)
;; (define (lod-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (doodad-fn(first lst))
;;                (lod-fn (rest lst)))]))

(define-struct world (doodads-star doodads-square count-t count-q paused?))
;; A World is a
;;    (make-world LOD-star LOD-square NonNegInteger NonNegInteger Boolean)
;; INTERPRETATION:
;; LOD-star is the list of star Doodads
;; LOD-square is the list of square Doodads
;; count-t keeps track of the number of "t" key presses
;; count-p keeps track of the number of "q" key presses 
;; paused? describes whether or not the world is paused

;; TEMPLATE:
;; world-fn : World -> ??
;; (define (world-fn w)
;;    (... (world-doodads-star w)
;;         (world-doodads-square w)
;;         (world-count-t w)
;;         (world-count-q w)
;;         (world-paused? w)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS

;; dimensions of the canvas
(define CANVAS-WIDTH 601)
(define CANVAS-HEIGHT 449)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))

;; initial x and y coordinates of the star
(define X-COORD-OF-STAR 125)
(define Y-COORD-OF-STAR 120)

;; initial velocities in x and y directions of the star
(define VEL-X-OF-STAR 10)
(define VEL-Y-OF-STAR 12)

;; initial x and y coordinates of the square
(define X-COORD-OF-SQUARE 460)
(define Y-COORD-OF-SQUARE 350)

;; initial velocities in x and y directions of the square
(define VEL-X-OF-SQUARE -13)
(define VEL-Y-OF-SQUARE -9)

;; shapes of the star and square
(define DOODAD1-SHAPE (radial-star 8 10 50 "solid" "gold"))
(define DOODAD2-SHAPE (square 71 "solid" "gray"))

;; defining a circle to point out the position of the image while dragging
(define cir (circle 3 "solid" "black"))

(define SQUARE-SIDE 71)
(define STAR-RADIUS 50)

;; defining any for initial world
(define any 10)

(define STAR-OUTER-RADIUS 50)
(define SQUARE-SIDE-IN-DOODAD 71)

;; initial list of Doodads
(define DOODAD1
    (make-doodad "gold" DOODAD1-SHAPE
                 (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                 (make-velocity -12 10)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD2
    (make-doodad "gold" DOODAD1-SHAPE
                 (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                 (make-velocity -10 -12)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD3
    (make-doodad "gold" DOODAD1-SHAPE
                 (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                 (make-velocity 12 -10)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD4
    (make-doodad "gold" DOODAD1-SHAPE
                 (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                 (make-velocity 10 12)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD5
    (make-doodad "gray" DOODAD2-SHAPE
                 (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                 (make-velocity 9 -13)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD6
    (make-doodad "gray" DOODAD2-SHAPE
                 (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                 (make-velocity 13 9)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD7
    (make-doodad "gray" DOODAD2-SHAPE
                 (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                 (make-velocity -9 13)
                 (make-mouse-position 0 0) 0 #false))

(define DOODAD8
    (make-doodad "gray" DOODAD2-SHAPE
                 (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                 (make-velocity -13 -9)
                 (make-mouse-position 0 0) 0 #false))
                 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; defining worlds for testing

(define INITIAL-STAR-DOODAD
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 false))

(define INITIAL-STAR-DOODAD-BUTTON-DOWN
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 125 120) 0 true))

(define INITIAL-STAR-DOODAD-BUTTON-DRAG
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 250 240) (make-velocity 10 12)
               (make-mouse-position 125 120) 0 true))

(define INITIAL-SQUARE-DOODAD-BUTTON-DRAG
  (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 920 700) (make-velocity -13 -9)
               (make-mouse-position 125 120) 0 true))

(define INITIAL-STAR-DOODAD-BUTTON-UP
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 250 240) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 false))

(define INITIAL-SQUARE-DOODAD
  (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 460 350) (make-velocity -13 -9)
               (make-mouse-position 0 0) 0  false))

(define SELECTED-SQUARE-DOODAD
  (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 460 350) (make-velocity -13 -9)
               (make-mouse-position 460 350) 0  false))

(define SELECTED-STAR-DOODAD
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 true))

(define SELECTED-STAR-DOODAD-CHANGE-COLOR
  (make-doodad "green" (radial-star 8 10 50 "solid" "green")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 true))

(define SELECTED-STAR-DOODAD-PLACE-DOODAD
    (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 125 120) 0 true))

(define WORLD-AT-INITIAL-POSITIONS (make-world
          (list INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-WITH-SELECTED-DOODAD (make-world
          (list SELECTED-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-WITH-SELECTED-SQUARE-DOODAD (make-world
          (list INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-AFTER-BUTTON-DRAG-SQUARE (make-world
          (list INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD-BUTTON-DRAG)0 0 #false))

(define WORLD-AFTER-BUTTON-DOWN (make-world
          (list INITIAL-STAR-DOODAD-BUTTON-DOWN)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-AFTER-BUTTON-DRAG (make-world
          (list INITIAL-STAR-DOODAD-BUTTON-DRAG)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-AFTER-BUTTON-UP (make-world
          (list INITIAL-STAR-DOODAD-BUTTON-UP)
          (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define WORLD-AFTER-T-KEY (make-world
          (list DOODAD1 INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)1 0 #false))

(define WORLD-AFTER-T1-KEY (make-world
          (list DOODAD2 DOODAD1 INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)2 0 #false))

(define WORLD-AFTER-T2-KEY (make-world
          (list DOODAD3 DOODAD2 DOODAD1 INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)3 0 #false))

(define WORLD-AFTER-T3-KEY (make-world
          (list DOODAD4 DOODAD3 DOODAD2 DOODAD1 INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)4 0 #false))

(define WORLD-AFTER-Q-KEY (make-world
          (list INITIAL-STAR-DOODAD)
          (list DOODAD5 INITIAL-SQUARE-DOODAD)0 1 #false))

(define WORLD-AFTER-Q1-KEY (make-world
          (list INITIAL-STAR-DOODAD)
          (list DOODAD6 DOODAD5 INITIAL-SQUARE-DOODAD)0 2 #false))

(define WORLD-AFTER-Q2-KEY (make-world
          (list INITIAL-STAR-DOODAD)
          (list DOODAD7 DOODAD6 DOODAD5 INITIAL-SQUARE-DOODAD)0 3 #false))

(define WORLD-AFTER-Q3-KEY (make-world
          (list INITIAL-STAR-DOODAD)
          (list DOODAD8 DOODAD7 DOODAD6 DOODAD5 INITIAL-SQUARE-DOODAD)
          0 4 #false))

(define WORLD-AFTER-DOT-KEY (make-world '() '() 3 0 #false))

(define DOODAD-OLDEST-AGE (make-doodad "gold" DOODAD1-SHAPE
                 (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                 (make-velocity 10 12)
                 (make-mouse-position 0 0) 10 #false))

(define WORLD-BEFORE-DELETE-OLDEST-STAR (make-world
          (list DOODAD4 DOODAD3 DOODAD2 DOODAD1 DOODAD-OLDEST-AGE)
          (list INITIAL-SQUARE-DOODAD)4 0 #false))

(define WORLD-AFTER-DELETE-OLDEST-STAR (make-world
          (list DOODAD4 DOODAD3 DOODAD2 DOODAD1)
          '()4 0 #false))

(define WORLD-ON-PAUSE  (make-world
          (list INITIAL-STAR-DOODAD)
          (list INITIAL-SQUARE-DOODAD)0 0 #true))

(define DOODAD-STAR-ON-PAUSE-AFTER-TICK
    (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 0 0) 1 false))

(define DOODAD-SQUARE-ON-PAUSE-AFTER-TICK
    (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 460 350) (make-velocity -13 -9)
               (make-mouse-position 0 0) 1 false))

(define WORLD-AFTER-TICK-ON-PAUSE  (make-world
          (list DOODAD-STAR-ON-PAUSE-AFTER-TICK)
          (list DOODAD-SQUARE-ON-PAUSE-AFTER-TICK)0 0 #true))

(define WORLD-STAR-SELECTED (make-world
          (list DOODAD4 DOODAD3 DOODAD2 SELECTED-STAR-DOODAD)
          '()4 0 #false))

(define WORLD-STAR-COLOR-CHANGE-SELECTED (make-world
          (list DOODAD4 DOODAD3 DOODAD2 SELECTED-STAR-DOODAD-CHANGE-COLOR)
          '()4 0 #false))

(define IMAGE-OF-PAUSED-INITIAL-WORLD
  (place-image DOODAD1-SHAPE 125 120
               (place-image DOODAD2-SHAPE 460 350 EMPTY-CANVAS)))

(define WORLD-PLACE-SELECTED-DOODAD (make-world
          (list DOODAD2 SELECTED-STAR-DOODAD-PLACE-DOODAD)
          '()4 0 #false))

(define IMAGE-OF-SELECTED-DOODAD
  (place-image cir 125 120
               (place-image DOODAD1-SHAPE 125 120
               (place-image DOODAD1-SHAPE 125 120 EMPTY-CANVAS))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define DOODAD-SQUARE-FOR-IN-DOODAD-BEFORE
  (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 200 300)(make-velocity -13 -9)
               (make-mouse-position 0 0) 0 false))

(define DOODAD-SQUARE-FOR-IN-DOODAD-AFTER
  (make-doodad "gray" (square 71 "solid" "gray")
               (make-location 200 300)(make-velocity -13 -9)
               (make-mouse-position 200 300) 0 true))
               
(define WORLD-FOR-SQUARE-IN-DOODAD
  (make-world '()
              (list DOODAD-SQUARE-FOR-IN-DOODAD-BEFORE)0 0 false))

(define WORLD-AFTER-IN-DOODAD
  (make-world '()
              (list DOODAD-SQUARE-FOR-IN-DOODAD-AFTER)0 0 false))

(define INITIAL-WORLD
   (make-world
    (list INITIAL-STAR-DOODAD)
    (list INITIAL-SQUARE-DOODAD)0 0 #false))

(define STAR-BEFORE-Y-449
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 395 444) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 false))
(define STAR-AFTER-Y-449
   (make-doodad "green" (radial-star 8 10 50 "solid" "green")
               (make-location 405 440) (make-velocity 10 -12)
               (make-mouse-position 0 0) 1 false))

(define WORLD-BEFORE-Y-449
  (make-world
   (list STAR-BEFORE-Y-449)
   '() 0 0 false))

(define WORLD-AFTER-Y-449
  (make-world
   (list STAR-AFTER-Y-449)
   '() 0 0 false))
         
(define STAR-BEFORE-X-601
   (make-doodad "green" (radial-star 8 10 50 "solid" "green")
               (make-location 592 440) (make-velocity 10 -12)
               (make-mouse-position 0 0) 0 false))
(define STAR-AFTER-X-601
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 598 428) (make-velocity -10 -12)
               (make-mouse-position 0 0) 1 false))

(define WORLD-BEFORE-X-601
  (make-world
   (list STAR-BEFORE-X-601)
   '() 0 0 false))

(define WORLD-AFTER-X-601
  (make-world
   (list STAR-AFTER-X-601)
   '() 0 0 false))

(define STAR-BEFORE-X-0
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 5 400) (make-velocity -10 -12)
               (make-mouse-position 0 0) 0 false))
(define STAR-AFTER-X-0
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 5 388) (make-velocity 10 -12)
               (make-mouse-position 0 0) 1 false))

(define WORLD-BEFORE-X-0
  (make-world
   (list STAR-BEFORE-X-0)
   '() 0 0 false))

(define WORLD-AFTER-X-0
  (make-world
   (list STAR-AFTER-X-0)
   '() 0 0 false))

(define STAR-BEFORE-Y-0
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 445 11) (make-velocity -10 -12)
               (make-mouse-position 0 0) 0 false))
(define STAR-AFTER-Y-0
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 435 1) (make-velocity -10 12)
               (make-mouse-position 0 0) 1 false))

(define WORLD-BEFORE-Y-0
  (make-world
   (list STAR-BEFORE-Y-0)
   '() 0 0 false))

(define WORLD-AFTER-Y-0
  (make-world
   (list STAR-AFTER-Y-0)
   '() 0 0 false))

(define XY-LESS-THAN-ZERO-BEFORE
   (make-doodad "orange" (square 71 "solid" "orange")
               (make-location 5 8) (make-velocity -13 -9)
               (make-mouse-position 0 0) 0 false))
(define XY-LESS-THAN-ZERO-AFTER
   (make-doodad "crimson" (square 71 "solid" "crimson")
               (make-location 8 1) (make-velocity 13 9)
               (make-mouse-position 0 0) 1 false))

(define WORLD-BEFORE-XY-LESS-THAN-ZERO
  (make-world
   (list XY-LESS-THAN-ZERO-BEFORE)
   '() 0 0 false))

(define WORLD-AFTER-XY-LESS-THAN-ZERO
  (make-world
   (list XY-LESS-THAN-ZERO-AFTER)
   '() 0 0 false))

(define WORLD-FOR-LESS-THAN-ZERO-BEFORE
  (make-world (list XY-LESS-THAN-ZERO-BEFORE)
              '() 0 0 false))

(define WORLD-FOR-LESS-THAN-ZERO-AFTER
  (make-world (list XY-LESS-THAN-ZERO-AFTER)
              '() 0 0 false))

(define STAR-BEFORE-Y-449-SELECTED
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 395 444) (make-velocity 10 12)
               (make-mouse-position 0 0) 0 true))

(define SQUARE-INITIAL-AFTER-TICK
   (make-doodad "gray" (square 71 "solid" "gray")
                       (make-location 447 341) (make-velocity -13 -9)
                       (make-mouse-position 0 0) 1 false))
(define STAR-INITIAL-AFTER-TICK
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 135 132) (make-velocity 10 12)
               (make-mouse-position 0 0) 1 false))

(define INITIAL-WORLD-AFTER-TICK
  (make-world
   (list STAR-INITIAL-AFTER-TICK)
   (list SQUARE-INITIAL-AFTER-TICK)0 0 false))

(define WORLD-BEFORE-TICK-FOR-SELECTED
  (make-world (list SELECTED-STAR-DOODAD)
              '() 0 0 false))

(define SELECTED-STAR-DOODAD-AFTER-TICK
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)
               (make-mouse-position 0 0) 1 true))

(define WORLD-AFTER-TICK-FOR-SELECTED
  (make-world (list SELECTED-STAR-DOODAD-AFTER-TICK)
              '() 0 0 false))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-world : Any -> World
;; GIVEN: any value, this value is ignored
;; RETURNS: the initial world specified for the animation, that is, the world
;;          which includes the two doodads at their initial positions.
;; EXAMPLE: (initial-world -174) = (make-world
;;          (list (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
;;                              (make-location 125 120) (make-velocity 10 12)
;;                               (make-mouse-position 0 0) false))
;;          (list (make-doodad "gray" (square 71 "solid" "gray")
;;                              (make-location 460 350) (make-velocity -13 -9)
;;                              (make-mouse-position 0 0) false)) 0 0
;;           #false)

(define (initial-world any)
  (make-world (cons (make-doodad gold DOODAD1-SHAPE
                           (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                           (make-velocity VEL-X-OF-STAR VEL-Y-OF-STAR)
                           (make-mouse-position 0 0) 0 false) empty)
              (cons (make-doodad gray DOODAD2-SHAPE
                           (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                           (make-velocity VEL-X-OF-SQUARE VEL-Y-OF-SQUARE)
                           (make-mouse-position 0 0) 0 false) empty) 0 0
              false))

;; TESTS
(begin-for-test
  (check-equal? (initial-world any)
                WORLD-AT-INITIAL-POSITIONS
                "initial-world has not been created"))

;; animation : PosReal -> World
;; GIVEN: the speed of the animation, in seconds per tick, the larger the
;;        number given the slower the is a tick.
;; RETURNS: the final state of the world is returned
;; EXAMPLES:
;;     (animation 1) runs the animation at normal speed
;;     (animation 1/4) runs at a faster than normal speed

(define (animation speed)
  (big-bang (initial-world any)
            (on-tick world-after-tick speed)
            (on-draw world-to-scene)
            (on-key world-after-key-event)
            (on-mouse world-after-mouse-event)))

;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a World and a KeyEvent
;;        The KeyEvent is one of
;;        " " a pause,that is,the animation freezes on one press and gets active
;;            when pressed again.
;;        "t" which adds a star like doodad to the world.
;;        "q" which adds a square like doodad to the world.
;;        "." which deletes the oldest doodads from the star-like doodad list
;;            and the square-like doodad list
;;        or "c" KeyEvent which changes the color of the selected doodad. 
;; RETURNS: If the Key Event,that is," " has been pressed,then the world will
;;         pause if it is not in pause mode previously and if previously the
;;         screen was on pause,that is, freeze then the animation gets active.
;;         If the doodad is selected and a "c" KeyEvent occurs then the colour
;;         of the selected doodad changes.On "t" press the star doodad is added
;;         and "q" press the square doodad is added.
;; EXAMPLES:
;; (world-after-key-event WORLD-AT-INITIAL-POSITIONS "t") =
;;   
;; STRATEGY: Breaking down into cases

(define (world-after-key-event w ke)
  (cond
    [(key=? ke "t") (world-after-key-t w)]
    [(key=? ke "q") (world-after-key-q w)]
    [(key=? ke ".") (world-after-key-dot w)]
    [(key=? ke " ") (world-with-paused-toggled w)]
    [(key=? ke "c") (world-after-key-c w)]
    [else w]))

;; TESTS
(begin-for-test
  (check-equal? (world-after-key-event WORLD-AT-INITIAL-POSITIONS "t")
                WORLD-AFTER-T-KEY
                "world after 't' key did not add a star doodad")
  (check-equal? (world-after-key-event WORLD-AT-INITIAL-POSITIONS "q")
                WORLD-AFTER-Q-KEY
                "world after 'q' key did not add a square doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-Q-KEY "q")
                WORLD-AFTER-Q1-KEY
                "world after 'q' key did not add a square doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-Q1-KEY "q")
                WORLD-AFTER-Q2-KEY
                "world after 'q' key did not add a square doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-Q2-KEY "q")
                WORLD-AFTER-Q3-KEY
                "world after 'q' key did not add a square doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-T-KEY "t")
                WORLD-AFTER-T1-KEY
                "world after 't' key did not add a star doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-T1-KEY "t")
                WORLD-AFTER-T2-KEY
                "world after 't' key did not add a star doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-T2-KEY "t")
                WORLD-AFTER-T3-KEY
                "world after 't' key did not add a star doodad")
  (check-equal? (world-after-key-event WORLD-AFTER-T2-KEY ".")
                WORLD-AFTER-DOT-KEY
                "world after '.' key did not delete oldest doodads")
  (check-equal? (world-after-key-event WORLD-BEFORE-DELETE-OLDEST-STAR ".")
                WORLD-AFTER-DELETE-OLDEST-STAR
                "world after '.' key did not delete oldest doodads")
  (check-equal? (world-after-key-event WORLD-AT-INITIAL-POSITIONS " ")
                WORLD-ON-PAUSE
                "world after ' ' key did not freeze the animation")
  (check-equal? (world-after-key-event WORLD-STAR-SELECTED "c")
                WORLD-STAR-COLOR-CHANGE-SELECTED
                "world after 'c' key did not change the color of
                the selected doodad")
  (check-equal? (world-after-key-event WORLD-AT-INITIAL-POSITIONS "r")
                WORLD-AT-INITIAL-POSITIONS
                "world after 'r' key changed the world"))

;; world-after-key-t: World -> World
;; GIVEN: a World, which consists doodads either star-like or square-like
;; RETURNS: a World, after adding a star-like doodad to the list of star doodads
;;         for each press of 't' key the count-t variable is increased by 1 and
;;         accordingly the velocity vectors of the newly created are set.Each
;;         newly created star doodad has an initial velocity vector that's
;;         rotated 90 degrees clockwise from the initial velocity of the
;;         previously created star-like doodad.
;; EXAMPLES:
;;(world-after-key-t WORLD-AT-INITIAL-POSITIONS) = WORLD-AFTER-T-KEY
;; STRATEGY: Use template of World on w

(define (world-after-key-t w)
  (cond
    [(= (remainder (world-count-t w) 4) 0) (make-world
                                          (cons DOODAD1 (world-doodads-star w))
                                          (world-doodads-square w)
                                          (+ (world-count-t w) 1)
                                          (world-count-q w)
                                          (world-paused? w))]
    [(= (remainder (world-count-t w) 4) 1) (make-world
                                          (cons DOODAD2 (world-doodads-star w))
                                          (world-doodads-square w)
                                          (+ (world-count-t w) 1)
                                          (world-count-q w)
                                          (world-paused? w))]
    [(= (remainder (world-count-t w) 4) 2) (make-world
                                          (cons DOODAD3 (world-doodads-star w))
                                          (world-doodads-square w)
                                          (+ (world-count-t w) 1)
                                          (world-count-q w)
                                          (world-paused? w))]
    [(= (remainder (world-count-t w) 4) 3) (make-world
                                          (cons DOODAD4 (world-doodads-star w))
                                          (world-doodads-square w)
                                          (+ (world-count-t w) 1)
                                          (world-count-q w)
                                          (world-paused? w))]))

;; world-after-key-q: World -> World
;; GIVEN: a World, which consists doodads either star-like or square-like
;; RETURNS: a World, after adding a square-like doodad to the list of square
;;         doodads for each press of 'q' key the count-q variable is increased
;;         by 1 and accordingly the velocity vectors of the newly created are
;;         set.Each newly created square doodad has an initial velocity vector
;;         that's rotated 90 degrees clockwise from the initial velocity of the
;;         previously created square-like doodad.
;; EXAMPLES:
;;(world-after-key-t WORLD-AT-INITIAL-POSITIONS) = WORLD-AFTER-Q-KEY
;; STRATEGY: Use template of World on w

(define (world-after-key-q w)
  (cond
    [(= (remainder (world-count-q w) 4) 0) (make-world
                                          (world-doodads-star w)
                                          (cons DOODAD5
                                                (world-doodads-square w))
                                          (world-count-t w)
                                          (+ (world-count-q w) 1)
                                          (world-paused? w))]
    [(= (remainder (world-count-q w) 4) 1) (make-world
                                          (world-doodads-star w)
                                          (cons DOODAD6
                                                (world-doodads-square w))
                                          (world-count-t w)
                                          (+ (world-count-q w) 1)
                                          (world-paused? w))]
    [(= (remainder (world-count-q w) 4) 2) (make-world
                                          (world-doodads-star w)
                                          (cons DOODAD7
                                                (world-doodads-square w))
                                          (world-count-t w)
                                          (+ (world-count-q w) 1)
                                          (world-paused? w))]
    [(= (remainder (world-count-q w) 4) 3) (make-world
                                            (world-doodads-star w)
                                          (cons DOODAD8
                                                (world-doodads-square w))
                                          (world-count-t w)
                                          (+ (world-count-q w) 1)
                                          (world-paused? w))]))

;; world-after-key-dot: World -> World
;; GIVEN: a World
;; RETURNS: a World,after deleting(if any present) the oldest star-like and the 
;;          oldest square-like doodads.
;; EXAMPLES:
;; (world-after-key-dot WORLD-AFTER-T2-KEY) = WORLD-AFTER-DOT-KEY
;; STRATEGY: Use template of World on w

(define (world-after-key-dot w)
   (make-world
    (doodads-after-key-dot (world-doodads-star w) (world-doodads-star w))
    (doodads-after-key-dot (world-doodads-square w)(world-doodads-square w))
    (world-count-t w) (world-count-q w)(world-paused? w)))

;; doodads-after-key-dot: LOD LOD -> LOD
;; GIVEN: a ListOfDoodads, either list Of star doodads or list of square doodads
;; RETURNS: two ListOfDoodads, with the oldest star or square doodad(s) deleted
;;          from the list
;; HALTING MEASURE: (length lst) 
;; EXAMPLES:
;; (doodads-after-key-dot WORLD-BEFORE-DELETE-OLDEST-STAR
;;        WORLD-BEFORE-DELETE-OLDEST-STAR) =
;; WORLD-AFTER-DELETE-OLDEST-STAR
;; STRATEGY: Use template for lOD-square or LOD-star on lst

(define (doodads-after-key-dot lst complete-lst)
  (cond
    [(empty? lst) empty]
    [else (if (= (doodad-age (first lst)) (find-oldest-age complete-lst))
              (doodads-after-key-dot (rest lst) complete-lst)
              (cons (first lst)
                    (doodads-after-key-dot (rest lst) complete-lst)))]))

;; find-oldest-age :  LOD -> Integer 
;; GIVEN: a non-empty list of square or star doodads
;; RETURNS: an Integer, the oldest age of the doodads in the given list
;; HALTING MEASURE: (length lst)  
;; STRATEGY: Use template for LOD-square or LOD-star on lst

(define (find-oldest-age lst)
  (cond
    [(empty? (rest lst))(doodad-age (first lst))]
    [else (max (doodad-age (first lst))
                (find-oldest-age (rest lst)))]))

;; world-with-paused-toggled : World -> World
;; GIVEN: a World, which is either frozen or active due to the " " KeyEvent
;; RETURNS: a world just like the given one, but with paused? toggled,that is,
;;          if the value of the world-paused? for a given world is false the
;;          value is changed to true.If the value of the world-paused? for a
;;          given world is true the value is changed to false.
;; EXAMPLES:
;; (world-with-paused-toggled WORLD-AT-INITIAL-POSITIONS)
;;          = WORLD-ON-PAUSE
;; (world-with-paused-toggled WORLD-ON-PAUSE)
;;          = WORLD-AT-INITIAL-POSITIONS
;; STRATEGY: Use template for World on w

(define (world-with-paused-toggled w)
  (make-world
   (world-doodads-star w)
   (world-doodads-square w)
   (world-count-t w)
   (world-count-q w)
   (not (world-paused? w))))

;; world-after-key-c : World -> World
;; GIVEN: a World
;; RETURN: a World, after changing the color of the doodad(s) selected.If none
;;         of the doodads in lists are selected then there will be no change in
;;         color
;; EXAMPLES:
;; (world-after-key-c WORLD-STAR-SELECTED) = WORLD-STAR-COLOR-CHANGE-SELECTED
;; STRATEGY: Use template for World on w

(define (world-after-key-c w)
  (make-world (doodads-after-key-c (world-doodads-star w))
              (doodads-after-key-c (world-doodads-square w))
              (world-count-t w) (world-count-q w)
              (world-paused? w)))

;; doodads-after-key-c: LOD -> LOD
;; GIVEN: a LOD,
;; RETURNS: a LOD,with each selected doodad change in color
;; HALTING MEASURE: (length lst)  
;; STRATEGY: Use template of LOD-square or LOD-star on lst

(define (doodads-after-key-c lst)
  (cond
    [(empty? lst) empty]
    [(doodad-selected? (first lst))
              (cons (doodad-after-c (first lst))
                    (doodads-after-key-c (rest lst)))]
    [else (cons (first lst)
                (doodads-after-key-c(rest lst)))]))

;; doodad-after-c : Doodad -> Doodad
;; GIVEN: a Doodad, either a star-like doodad or square-like doodad
;; RETURNS: a Doodad, the doodad changes its color to the next color.
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-after-c doodad)
  (make-doodad (change-color (doodad-color doodad))
               (color-next (change-color (doodad-color doodad)))
               (make-location (doodad-x doodad)(doodad-y doodad))
               (make-velocity (doodad-vx doodad)(doodad-vy doodad))
               (make-mouse-position (doodad-mx doodad)(doodad-my doodad))
               (doodad-age doodad)(doodad-selected? doodad)))

;; world-to-scene: World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene that portrays the given world.The two doodads are placed in
;;          the empty rectangular canvas.
;; EXAMPLE:
;; (world-to-scene WORLD-AT-PAUSE-INITIAL) = IMAGE-OF-SELECTED-DOODAD
;; STRATEGY: Use template World for w

(define (world-to-scene w)
  (place-doodads
   (world-doodads-star w)
   (place-doodads
    (world-doodads-square w)
   EMPTY-CANVAS)))

;; TESTS
(begin-for-test
  (check-equal? (world-to-scene WORLD-AT-INITIAL-POSITIONS)
                IMAGE-OF-PAUSED-INITIAL-WORLD
                "The world hasn't been created properly")
  (check-equal? (world-to-scene WORLD-PLACE-SELECTED-DOODAD)
                IMAGE-OF-SELECTED-DOODAD
                "The world hasn't been created properly"))                
                
;; place-doodads: LOD Scene -> Scene
;; GIVEN: a LOD, a list of Doodads of square-like or star-like doodads
;; RETURNS: a Scene,  that portrays the given world.
;; HALTING MEASURE: (length lst)  
;; STRATEGY: Use template of LOD-star or LOD-square on lst

(define (place-doodads lst scene)
  (cond
    [(empty? lst) scene]
    [else (place-doodads (rest lst) (place-doodad (first lst) scene))]))

;; place-doodad: Doodad Scene -> Scene
;; GIVEN: a Doodad,either a star doodad or square doodad.
;; RETURNS: a Scene,  that portrays the given world.
;; STRATEGY: Combine simpler functions

(define (place-doodad doodad scene)
  (if (doodad-selected? doodad)
      (place-image cir
                  (mouse-position-mx (doodad-mouse-position doodad))
                  (mouse-position-my (doodad-mouse-position doodad))
     (place-image (doodad-shape doodad)
                  (doodad-x doodad) (doodad-y doodad) scene))
     (place-image (doodad-shape doodad)
                  (doodad-x doodad) (doodad-y doodad) scene)))

;; world-after-tick : World -> World
;; GIVEN: any World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick.If the
;;          world is paused the same present world is returned with the age of
;;          the doodads increase by 1 after every tick. else a new world
;;          is created after every tick. For every single tick the doodads are
;;          also created based on the conditions specified in doodad-after-tick
;; STRATEGY:Use template for World on w

(define (world-after-tick w)
  (if (world-paused? w)
      (increase-age w)
      (make-world (doodads-after-tick (world-doodads-star w))
                  (doodads-after-tick (world-doodads-square w))
                  (world-count-t w)(world-count-q w)
                  (world-paused? w))))

;; TESTS
(begin-for-test
  (check-equal?
   (world-after-tick WORLD-ON-PAUSE)
   WORLD-AFTER-TICK-ON-PAUSE
   "the age of the doodads did not increase after a tick when world is paused")
  (check-equal?
   (world-after-tick INITIAL-WORLD)
   INITIAL-WORLD-AFTER-TICK
   "the doodads inbetween boundary are not working as expected")
  (check-equal?
   (world-after-tick WORLD-FOR-LESS-THAN-ZERO-BEFORE)
   WORLD-FOR-LESS-THAN-ZERO-AFTER
   "the doodads did not work as expected when x and y are less than o")
  (check-equal?
   (world-after-tick WORLD-BEFORE-Y-449)
   WORLD-AFTER-Y-449
   "the doodads did not work as expected when y is greater than 449")
  (check-equal?
   (world-after-tick WORLD-BEFORE-X-601)
   WORLD-AFTER-X-601
   "the doodads did not work as expected when x is greater than 601")
  (check-equal?
   (world-after-tick WORLD-BEFORE-X-0)
   WORLD-AFTER-X-0
   "the doodads did not work as expected when x is less than 0")
  (check-equal?
   (world-after-tick WORLD-BEFORE-Y-0)
   WORLD-AFTER-Y-0
    "the doodads did not work as expected when y is less than 0")
  (check-equal?
   (world-after-tick WORLD-BEFORE-XY-LESS-THAN-ZERO)
   WORLD-AFTER-XY-LESS-THAN-ZERO
   "the doodads did not work as expected when x,y less than zero")
  (check-equal?
   (world-after-tick WORLD-BEFORE-TICK-FOR-SELECTED)
   WORLD-AFTER-TICK-FOR-SELECTED
   "the doodads did not move as expected when they were selected"))
  
;; increase-age: World -> World
;; GIVEN: a World, which either consists of doodads or might be empty
;; RETURNS: a World, with an increase in the age of all the doodads by one. 
;; STRATEGY: Using template for World on w

(define (increase-age w)
  (make-world (doodads-increase-age (world-doodads-star w))
              (doodads-increase-age (world-doodads-square w))
              (world-count-t w)(world-count-q w)
              (world-paused? w)))

;; doodads-increase-age: LOD -> LOD
;; GIVEN: a LOD, list of square-like doodads or star-like doodads.
;; RETURNS: a LOD,each doodad from the list is sent to doodad-increase-age
;;          function and the age of each doodad is incremented by one.
;; HALTING MEASURE: (length lst) 
;; STRATEGY: Using template for LOD-square or LOD-star on lst

(define (doodads-increase-age lst)
  (cond
    [(empty? lst) empty]
    [else (cons (doodad-increase-age (first lst))
                (doodads-increase-age (rest lst)))]))

;; doodad-increase-age: Doodad -> Doodad
;; GIVEN: a Doodad, either a star-like doodad or square-like doodad
;; RETURNS: a Doodad, the age of the doodad is incremented by one and returned.
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-increase-age doodad)
    (make-doodad  (doodad-color doodad) (doodad-shape doodad)
                  (make-location (doodad-x doodad)
                                 (doodad-y doodad))
                  (make-velocity (doodad-vx doodad) (doodad-vy doodad))
                  (make-mouse-position (doodad-mx doodad) (doodad-my doodad))
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodads-after-tick : LOD -> LOD
;; GIVEN: a LOD, which is either a list of square doodads or list of star
;;        doodads
;; RETURNS: a LOD, each doodad after every tick change the velocity vector or
;;          position according to the conditions and also change color when a
;;          acore bounce occurs. Each doodad is sent do doodad-after-tick and
;;          after the changes are made according to the conditions they are
;;          returned.
;; STRATEGY: Using template for LOD-square or LOD-star on lst

(define (doodads-after-tick lst)
  (cond
    [(empty? lst) empty]
    [else (cons (doodad-after-tick (first lst))
                (doodads-after-tick (rest lst)))]))

;; doodad-after-tick: Doodad -> Doodad
;; GIVEN: a Doodad, the doodad can either be a star like doodad or square-like
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.A doodad changes it's color if it's tentative
;;          position is going to hit any of the boundaries of the empty canvas.
;;          The Doodad does not change it's color if it is inbetween the
;;          boundaries of the empty canvas.The velocities change according to
;;          the tentative-x and tentative-y positions.The changes are made
;;          accordingly and a new Doodad is returned after every tick.
;; EXAMPLES:
;; (doodad-after-tick INITIAL-STAR-DOODAD) = STAR-INITIAL-AFTER-TICK
;; STAR-INITIAL-AFTER-TICK has new x and y co-ordinates which have changed
;; according to the corresponding vx and vy velocity values after one tick


(define (doodad-after-tick doodad)
  (if (doodad-selected? doodad)
      (doodad-increase-age doodad)
      (cond
    [(and (and (>= (tentative-x doodad) 0) (< (tentative-x doodad) 601))
          (and (>= (tentative-y doodad) 0) (< (tentative-y doodad) 449)))
          (doodad-in-between-border doodad)]
    [(and (< (tentative-x doodad) 0) (< (tentative-y doodad) 0))
           (doodad-less-than-origin doodad)]
    [(< (tentative-x doodad) 0)
          (doodad-at-x-zero doodad)]
    [(< (tentative-y doodad) 0)
          (doodad-at-tentative-y-zero doodad)]
    [(>= (tentative-x doodad) 601)
          (doodad-at-x-boundary doodad)]
    [(>= (tentative-y doodad) 449)
          (doodad-at-y-boundary doodad)])))

;; tentative-x : Doodad -> Integer
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: the tentative x co-ordinate is returned, which is the sum of the
;;          velocity in x direction and the present x position
;; EXAMPLES:
;; (tentative-x INITIAL-STAR-DOODAD) = 135
;; the x-coordinate of the doodad is 125 and the vx value is 10 so the tentative
;; x-position is 135
;; STRATEGY: Use template Doodad on doodad

(define (tentative-x doodad)
                   (+ (doodad-x doodad) (doodad-vx doodad)))

;; TESTS
(begin-for-test
  (check-equal? (tentative-x INITIAL-STAR-DOODAD)135
                "the tentative x-position has not been calculated right"))

;; tentative-y : Doodad -> Integer
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: the tentative y co-ordinate is returned, which is the sum of the
;;          velocity in y direction and the present y position
;; EXAMPLES:
;; (tentative-y INITIAL-STAR-DOODAD) = 132
;; the y-coordinate of the doodad is 120 and the vy value is 12 so the tentative
;; y-position is 132
;; STRATEGY: Use template Doodad on doodad

(define (tentative-y doodad)
                   (+ (doodad-y doodad) (doodad-vy doodad)))
;; TESTS
(begin-for-test
  (check-equal? (tentative-y INITIAL-STAR-DOODAD)132
                "the tentative y-position has not been calculated right"))

;; doodad-in-between-border : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.If the doodad is in between the borders of the
;;          empty canvas then the tentative x and y positions become the new
;;          x and y positions.In this case the colour does not change as there
;;          is no core bounce.
;; EXAMPLES:
;; (doodad-in-between-border INITIAL-STAR-DOODAD) = STAR-INITIAL-AFTER-TICK
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-in-between-border doodad)
    (make-doodad  (doodad-color doodad) (doodad-shape doodad)
                  (make-location (tentative-x doodad)
                                 (tentative-y doodad))
                  (make-velocity (doodad-vx doodad) (doodad-vy doodad))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodad-less-than-origin Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.The absolute value of the tentative co-ordinates
;;          are the new coordinates and the velocities are negated. As the
;;          boundary is touched a core bounce occurs and hence there is a color
;;          change.
;; EXAMPLES:
;; (doodad-less-than-origin XY-LESS-THAN-ZERO-BEFORE)
;;          = XY-LESS-THAN-ZERO-AFTER
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-less-than-origin doodad)
    (make-doodad (change-color (doodad-color doodad))
                 (color-next (change-color (doodad-color doodad)))
                  (make-location (abs (tentative-x doodad))
                                 (abs (tentative-y doodad)))
                  (make-velocity (- 0 (doodad-vx doodad))
                                 (- 0 (doodad-vy doodad)))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodad-at-x-zero : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.The absolute value of the tentative x-co-ordinate
;;          changes to its absolute value the corresponding velocity is negated
;;          the y co-ordinate and vy velocity remain unchanged. As the
;;          boundary is touched a core bounce occurs and hence there is a color
;;          change.
;; EXAMPLES:
;; (doodad-at-x-zero STAR-BEFORE-X-0)
;;          = STAR-AFTER-X-0
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-at-x-zero doodad)
     (make-doodad (change-color (doodad-color doodad))
                  (color-next (change-color (doodad-color doodad)))
                  (make-location (abs (tentative-x doodad))
                                 (tentative-y doodad))
                  (make-velocity (- 0 (doodad-vx doodad)) (doodad-vy doodad))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodad-at-tentative-y-zero : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.The absolute value of the tentative y-co-ordinate
;;          changes to its absolute value the corresponding velocity is negated
;;          the x co-ordinate and vx velocity remain unchanged. As the
;;          boundary is touched a core bounce occurs and hence there is a color
;;          change.
;; EXAMPLES:
;; (doodad-at-tentative-y-zero STAR-BEFORE-Y-0)
;;          = STAR-AFTER-Y-0
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-at-tentative-y-zero doodad)
     (make-doodad (change-color (doodad-color doodad))
                  (color-next (change-color (doodad-color doodad)))
                  (make-location (tentative-x doodad)
                                 (abs (tentative-y doodad)))
                  (make-velocity  (doodad-vx doodad) (- 0 (doodad-vy doodad)))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodad-at-x-boundary : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.The absolute value of the tentative x-co-ordinate
;;          changes and the corresponding velocity is negated
;;          the y co-ordinate and vy velocity remain unchanged. As the
;;          boundary is touched a core bounce occurs and hence there is a color
;;          change.
;; EXAMPLES:
;; (doodad-at-x-boundary STAR-BEFORE-X-601)
;;          = STAR-AFTER-X-601
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-at-x-boundary doodad)
        (make-doodad (change-color (doodad-color doodad))
                     (color-next (change-color (doodad-color doodad)))
                  (make-location (- 600 (- (tentative-x doodad) 600))
                                  (tentative-y doodad))
                  (make-velocity (- 0 (doodad-vx doodad)) (doodad-vy doodad))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; doodad-at-y-boundary : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.The absolute value of the tentative x-co-ordinate
;;          changes and the corresponding velocity is negated
;;          the y co-ordinate and vy velocity remain unchanged. As the
;;          boundary is touched a core bounce occurs and hence there is a color
;;          change.
;; EXAMPLES:
;; (doodad-at-y-boundary STAR-BEFORE-Y-449)
;;          = STAR-AFTER-Y-449
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-at-y-boundary doodad) 
        (make-doodad (change-color (doodad-color doodad))
                     (color-next (change-color (doodad-color doodad))) 
                     (make-location (tentative-x doodad)
                                    (- 448 (- (tentative-y doodad) 448)))
                  (make-velocity (doodad-vx doodad) (- 0 (doodad-vy doodad)))
                  (make-mouse-position 0 0)
                  (+ (doodad-age doodad) 1)(doodad-selected? doodad)))

;; change-color: String -> String
;; GIVEN: a String, the input string should be one of the colours in the
;;        itemization defined in Color,that is, either gold,green,blue,
;;        olivedrab,khaki,orange,crimson or gray.
;; RETURNS: a String, which represents the next color to be represented after
;;          the change in color.
;;          Star doodad is initially gold on core bounce it changes to green.
;;          If the star doodad is green it changes to blue on core bounce.
;;          This cycle of changing from gold to green to blue continues for
;;          every core bounce.
;;          Square doodad is initially gray on core bounce changes to olivedrab
;;          If the square doodad is olivedrab it changes to khaki on bounce.
;;          If the square doodad is khaki it changes to orange on bounce.
;;          If the square doodad is orange it changes to crimson on bounce.
;;          If the square doodad is crimson it changes to gray on bounce.
;;          This cycle continues for every core bounce of the square doodad.
;; EXAMPLES:
;;(change-color "gold") = "green"
;;(change-color "blue") = "gold"
;; STRATEGY: Use template color-fn on color

(define (change-color color)
  (cond
    [(string=? color gold) "green"]
    [(string=? color green) "blue"]
    [(string=? color blue) "gold"]
    [(string=? color gray)"olivedrab"]
    [(string=? color olivedrab) "khaki"]
    [(string=? color khaki) "orange"]
    [(string=? color orange) "crimson"]
    [(string=? color crimson) "gray"]))

;;TESTS
(begin-for-test
  (check-equal?
   (change-color "gold") "green"
   "The change-color on giving gold does not change color to green")
  (check-equal?
   (change-color "green") "blue"
   "The change-color on giving green does not change color to blue")
  (check-equal?
   (change-color "blue") "gold"
   "The change-color on giving blue does not change color to gold")
  (check-equal?
   (change-color "gray") "olivedrab"
   "The change-color on giving gray does not change color to olivedrab")
  (check-equal?
   (change-color "olivedrab") "khaki"
   "The change-color on giving olivedrab does not change color to khaki")
  (check-equal?
   (change-color "khaki") "orange"
   "The change-color on giving khaki does not change color to orange")
  (check-equal?
   (change-color "orange") "crimson"
   "The change-color on giving orange does not change color to crimson")
  (check-equal?
   (change-color "crimson") "gray"
   "The change-color on giving gold does not change color to gray"))

;; color-next: String -> Image
;; GIVEN: a String, the input string should be one of the colours in the
;;        itemization defined in Color,that is, either gold,green,blue,
;;        olivedrab,khaki,orange,crimson or gray.
;; RETURNS: a Image, an Image is returned based on the color input string.
;;          If the input string is one of gold,green or blue, then the it
;;          returns a radial-star image of the corresponding color given as the
;;          input string.
;;          If the input string is one of gray,olivedrab,khaki,orange or
;;          crimson, then a square is returned of the color given in the input
;;          string.
;; EXAMPLES:
;; (color-next "gold") = (radial-star 8 10 50 "solid" "gold")
;; (color-next "gray") = (square 71 "solid" "gray")

(define (color-next color)
  (cond
    [(string=? color "gold") (radial-star 8 10 50 "solid" "gold")]
    [(string=? color "green") (radial-star 8 10 50 "solid" "green")]
    [(string=? color "blue") (radial-star 8 10 50 "solid" "blue")]
    [(string=? color "gray") (square 71 "solid" "gray")]
    [(string=? color "olivedrab") (square 71 "solid" "olivedrab")]
    [(string=? color "khaki") (square 71 "solid" "khaki")]
    [(string=? color "orange") (square 71 "solid" "orange")]
    [(string=? color "crimson")(square 71 "solid" "crimson")]))

;; TESTS
(begin-for-test
  (check-equal?
   (color-next "gold")(radial-star 8 10 50 "solid" "gold")
   "The radial star of color gold is not returned by (color-next 'gold')")
  (check-equal?
   (color-next "green")(radial-star 8 10 50 "solid" "green")
   "The radial star of color green is not returned by (color-next 'green')")
  (check-equal?
   (color-next "blue")(radial-star 8 10 50 "solid" "blue")
   "The radial star of color blue is not returned by (color-next 'blue')")
  (check-equal?
   (color-next "gray")(square 71 "solid" "gray")
   "The square of color gold is not returned by (color-next 'gray')")
  (check-equal?
   (color-next "olivedrab")(square 71 "solid" "olivedrab")
   "The square of color olivedrab is not returned by (color-next 'olivedrab')")
  (check-equal?
   (color-next "khaki")(square 71 "solid" "khaki")
   "The square of color khaki is not returned by (color-next 'khaki')")
  (check-equal?
   (color-next "orange")(square 71 "solid" "orange")
   "The square of color orange is not returned by (color-next 'orange')")
  (check-equal?
   (color-next "crimson")(square 71 "solid" "crimson")
   "The square of color crimson is not returned by (color-next 'crimson')"))

;; doodad-x : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer,the x co-ordinate of the center of the doodad.
;; EXAMPLES:
;; (doodad-x DOODAD2) = 125
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Location on doodad

(define (doodad-x doodad)
  (location-x (doodad-location doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-x DOODAD2)125
                "The x co-ordinate of the doodad is not 125"))

;; doodad-y : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer,the y co-ordinate of the center of the doodad.
;; EXAMPLES:
;; (doodad-y DOODAD2) = 120
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Location on doodad

(define (doodad-y doodad)
  (location-y (doodad-location doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-y DOODAD2)120
                "The y-co-ordinate of the doodad is not 120"))

;; doodad-vx : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: vx,an Integer,which specifies the number of pixels the doodad
;;          should move on each tick in the x direction.
;; EXAMPLES:
;; (doodad-vx DOODAD1) = -12
;; (doodad-vx DOODAD5) = 9
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Velocity on doodad

(define (doodad-vx doodad)
  (velocity-vx (doodad-velocity doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-vx DOODAD1)-12
                "The velocity in the x direction of the doodad is not -12")
  (check-equal? (doodad-vx DOODAD5)9
                "The velocity in the x direction of the doodad is not 9"))

;; doodad-vy : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: vy,an Integer,which specifies the number of pixels the doodad
;;          should move on each tick in the y direction.
;; EXAMPLES:
;; (doodad-vy DOODAD1) = -12
;; (doodad-vy DOODAD5) = 9
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Velocity on doodad

(define (doodad-vy doodad)
  (velocity-vy (doodad-velocity doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-vy DOODAD1)10
                "The velocity in the y direction of the doodad is not -12")
  (check-equal? (doodad-vy DOODAD5)-13
                "The velocity in the y direction of the doodad is not 9"))

;; doodad-mx : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer, which specifies the mouse pointer x co-ordinate
;; EXAMPLES:
;; (doodad-mx DOODAD1) = 0
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Mouse-Position on doodad

(define (doodad-mx doodad)
  (mouse-position-mx (doodad-mouse-position doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-mx DOODAD1)0
                "The mouse-pointer x-coordinate of the doodad is not 0"))

;; doodad-my : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer, which specifies the mouse pointer y co-ordinate
;; EXAMPLES:
;; (doodad-my DOODAD1) = 0
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Mouse-Position on doodad

(define (doodad-my doodad)
  (mouse-position-my (doodad-mouse-position doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-my DOODAD1)0
                "The mouse-pointer y-coordinate of the doodad is not 0"))

;; doodad-color : Doodad -> Color
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: the color of the Doodad.
;; gold,green and blue are the colors of the star which change in the same
;; order one after the other after a core bounce on the star doodad
;; gray,olivedrab,khaki,orange,crimson are the colors of the square which
;; change in the same order one after the other after a core bounce on the
;; square doodad
;; EXAMPLES:
;; (doodad-color DOODAD1) = "gold"
;; (doodad-color DOODAD5) = "gray"
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-color doodad)
    (doodad-colour doodad))

(begin-for-test
  (check-equal? (doodad-color DOODAD1)gold
                "The color of the doodad is not gold"))

;; doodad-selected? : Doodad -> Boolean
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: true if the given doodad is selected else returns false if the
;;          the doodad is not selected.
;; EXAMPLES:
;; (doodad-selected? DOODAD1) = false
;; STRATEGY: Use template Doodad on doodad

(define (doodad-selected? doodad)
  (doodad-select? doodad))

(begin-for-test
  (check-equal? (doodad-selected? DOODAD1)false
                "The doodad is not selected so should be false")
  (check-equal? (doodad-selected? SELECTED-STAR-DOODAD-PLACE-DOODAD)true
                "The doodad is not selected so should be true"))

;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: a world and a description of a mouse event
;; RETURNS: the world follows the given mouse event.
;; STRATEGY: use template for World on w

(define (world-after-mouse-event w mx my mev)
  (make-world
   (doodads-after-mouse-event (world-doodads-star w) mx my mev)
   (doodads-after-mouse-event (world-doodads-square w) mx my mev)
   (world-count-t w)(world-count-q w)(world-paused? w)))

;; TESTS
(begin-for-test
  (check-equal?
   (world-after-mouse-event WORLD-AT-INITIAL-POSITIONS 125 120 "button-down")
   WORLD-AFTER-BUTTON-DOWN
   " The world on mouse event button down did not work as expected")
  (check-equal?
   (world-after-mouse-event WORLD-WITH-SELECTED-DOODAD 125 120 "drag")
   WORLD-AFTER-BUTTON-DRAG
   "the world on mouse event drag did not work as expected")
  
  (check-equal?
   (world-after-mouse-event WORLD-FOR-SQUARE-IN-DOODAD 200 300 "button-down")
   WORLD-AFTER-IN-DOODAD
   "the world on mouse event drag did not work as expected")
  (check-equal?
   (world-after-mouse-event WORLD-AFTER-BUTTON-DRAG 125 120 "button-up")
   WORLD-AFTER-BUTTON-UP
   "the world on mouse event button up did not work as expected")
  (check-equal?
   (world-after-mouse-event WORLD-AFTER-BUTTON-DRAG 125 120 "button-up")
   WORLD-AFTER-BUTTON-UP
   "the world on mouse event button up did not work as expected")
    (check-equal?
   (world-after-mouse-event WORLD-AFTER-BUTTON-DRAG 125 120 "leave")
   WORLD-AFTER-BUTTON-DRAG
   "the world on any other random mouse event did not return the same world"))
   

;; doodads-after-mouse-event : LOD Integer Integer MouseEvent -> LOD
;; GIVEN: a list of doodads, extracting each doodad from the list of doodads
;;        the function doodad-after-mouse-event is called,a doodad and a
;;        description of a mouse event along with the co-ordinates of the mouse.
;;        The description can be "button-down" or "drag" or "button-up".If any
;;        other description is given the doodad undergoes no changes.
;; RETURNS: the LOD after following the given mouse event
;; HALTING MEASURE: (length lst) 
;; STRATEGY: Using template for LOD-square or LOD-star on lst

(define (doodads-after-mouse-event lst mx my mev)
  (cond
    [(empty? lst)empty]
    [else (cons (doodad-after-mouse-event (first lst) mx my mev)
           (doodads-after-mouse-event (rest lst) mx my mev))]))

;; doodad-after-mouse-event : Doodad Integer Integer MouseEvent -> Doodad
;; GIVEN: a doodad and a description of a mouse event along with the
;;        co-ordinates of the mouse. The description can be "button-down" or
;;        "drag" or "button-up".If any other description is given the doodad
;;        undergoes no changes.
;; RETURNS: the doodad that should follow the given mouse event
;; STRATEGY: Cases on mouse event mev

(define (doodad-after-mouse-event doodad mx my mev)
  (cond
    [(mouse=? mev "button-down") (doodad-after-button-down doodad mx my)]
    [(mouse=? mev "drag") (doodad-after-drag doodad mx my)]
    [(mouse=? mev "button-up") (doodad-after-button-up doodad mx my)]
    [else doodad]))

;; doodad-after-button-down: Doodad Integer Integer
;; GIVEN: a Doodad and the x and y coordinates of the mouse
;; RETURNS: a Doodad, which is either a square or star
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-after-button-down doodad x y)
  (if (in-doodad? doodad x y)
      (make-doodad (doodad-color doodad) (doodad-shape doodad)
                   (make-location (doodad-x doodad) (doodad-y doodad))
                   (make-velocity (doodad-vx doodad) (doodad-vy doodad))
                   (make-mouse-position x y)(doodad-age doodad) true)
    doodad))

;; doodad-after-drag: Doodad Integer Integer
;; GIVEN: a Doodad and the x and y coordinates of the mouse
;; RETURNS: a Doodad, which is either a square or star
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-after-drag doodad x y)
  (if (doodad-selected? doodad)
      (make-doodad (doodad-color doodad) (doodad-shape doodad)
       (make-location (- x (- (doodad-mx doodad) (doodad-x doodad)))
                      (- y (- (doodad-my doodad) (doodad-y doodad))))
       (make-velocity (doodad-vx doodad) (doodad-vy doodad))
       (make-mouse-position x y) (doodad-age doodad) true)
     doodad))

;; TESTS
(begin-for-test
  (check-equal? (doodad-after-drag INITIAL-STAR-DOODAD 125 120)
                INITIAL-STAR-DOODAD
                "doodad after drag is not working as expected"))
                
;; doodad-after-button-up: Doodad Integer Integer
;; GIVEN: a Doodad and the x and y coordinates of the mouse
;; RETURNS: a Doodad, which is either a square or star
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-after-button-up doodad x y)
  (if (doodad-selected? doodad)
      (make-doodad (doodad-color doodad) (doodad-shape doodad)
                   (make-location (doodad-x doodad) (doodad-y doodad))
                   (make-velocity (doodad-vx doodad) (doodad-vy doodad))
                   (make-mouse-position 0 0)(doodad-age doodad) false)
      doodad))


;; in-doodad? :  Doodad Integer Integer
;; GIVEN: a Doodad and the x and y coordinates of the mouse
;; RETURNS: the position if the boundaries have not been crossed
;; STRATEGY: Divides into cases

(define (in-doodad? doodad x y)
  (if (or (or (string=? (doodad-color doodad) "gold")
              (string=? (doodad-color doodad) "green"))
          (string=? (doodad-color doodad) "blue"))
  (and
    (<=
     (- (doodad-x doodad) (/ STAR-OUTER-RADIUS 2))
     x
     (+ (doodad-x doodad) (/ STAR-OUTER-RADIUS 2)))
    (<=
     (- (doodad-y doodad) (/ STAR-OUTER-RADIUS 2))
     y
     (+ (doodad-y doodad) (/ STAR-OUTER-RADIUS 2))))
  (and
    (<=
     (- (doodad-x doodad) (/ SQUARE-SIDE-IN-DOODAD 2))
     x
     (+ (doodad-x doodad) (/ SQUARE-SIDE-IN-DOODAD 2)))
    (<=
     (- (doodad-y doodad) (/ SQUARE-SIDE-IN-DOODAD 2))
     y
     (+ (doodad-y doodad) (/ SQUARE-SIDE-IN-DOODAD 2))))))

  





































  
