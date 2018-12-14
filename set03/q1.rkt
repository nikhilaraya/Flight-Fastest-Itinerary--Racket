;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; q1.rkt : Building an animation that displays two doodads moving around in an
;; rectangular enclosure

;; Goal: The two doodads,that is,the radial star and square move after every
;;       tick according to the velocity components.If the tentative positions
;;       of the doodads hits any of the boundaries then the doodads perform a
;;       core bounce.For each bounce each of the doodad's change colors.On
;;       pressing the spacebar(" ") the animation is frozen and on pressing the 
;;       spacebar(" ") again the animation gets active.

(require rackunit)
(require "extras.rkt")

(check-location "03" "q1.rkt")

(provide
        animation
        initial-world
        world-after-tick
        world-after-key-event
        world-paused?
        world-doodad-star
        world-doodad-square
        doodad-x
        doodad-y
        doodad-vx
        doodad-vy
        doodad-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; any value for initial-world
(define any 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINATIONS

(define-struct world (doodad1 doodad2 pause?))

;; A World is a
;;    (make-world Doodad Doodad Boolean)
;; INTERPRETATION:
;; doodad1 is the radial-star shaped doodad
;; doodad2 is the square shaped doodad
;; pause? is Boolean value which describes whether or not the world is paused 

;; TEMPLATE:
;; world-fn : World -> ??
;; (define (world-fn w)
;;  (...
;;      (world-doodad1 w)
;;      (world-doodad2 w)
;;      (world-pause? w)))

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

(define-struct doodad (colour shape location velocity))

;; A Doodad is a
;;    (make-doodad Color Image Location Velocity)
;; INTERPRETATION:
;; colour is of type Color which has the present color of the doodad
;; shape is either the star with 8 points and an inner radius of 10 pixels
;;       and outer radius of 50 pixels or it is a square with radius 71 pixels
;; location is of type Location which specifies the x and y co-ordinates of the
;;       center of the doodad
;; velocity is of type Velocity which specifies the velocity in the x direction
;;       and y direction

;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn d)
;;  (...
;;      (doodad-colour d)
;;      (doodad-shape d)
;;      (doodad-location d)
;;      (doodad-velocity d)))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; defining world for testing
(define WORLD-AT-INITIAL-POSITIONS (make-world
          (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
                       (make-location 125 120) (make-velocity 10 12))
          (make-doodad "gray" (square 71 "solid" "gray")
                       (make-location 460 350) (make-velocity -13 -9))#false))

(define WORLD-AT-PAUSE-INITIAL (make-world
          (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
                       (make-location 125 120) (make-velocity 10 12))
          (make-doodad "gray" (square 71 "solid" "gray")
                       (make-location 460 350) (make-velocity -13 -9))#true))

(define WORLD-AFTER-FIRST-TICK (make-world
          (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
                      (make-location 135 132) (make-velocity 10 12))
          (make-doodad "gray" (square 71 "solid" "gray")
                     (make-location 447 341) (make-velocity -13 -9)) #false))

(define DOODAD-STAR-INITIAL
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 125 120) (make-velocity 10 12)))

(define STAR-INITIAL-AFTER-TICK
  (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 135 132) (make-velocity 10 12)))

(define DOODAD-SQUARE-INITIAL
   (make-doodad "gray" (square 71 "solid" "gray")
                       (make-location 460 350) (make-velocity -13 -9)))
(define SQUARE-INITIAL-AFTER-TICK
   (make-doodad "gray" (square 71 "solid" "gray")
                       (make-location 447 341) (make-velocity -13 -9)))
(define STAR-BEFORE-Y-449
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 395 444) (make-velocity 10 12)))
(define STAR-AFTER-Y-449
   (make-doodad "green" (radial-star 8 10 50 "solid" "green")
               (make-location 405 440) (make-velocity 10 -12)))
(define STAR-BEFORE-X-601
   (make-doodad "green" (radial-star 8 10 50 "solid" "green")
               (make-location 592 440) (make-velocity 10 -12)))
(define STAR-AFTER-X-601
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 598 428) (make-velocity -10 -12)))
(define STAR-BEFORE-X-0
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 5 400) (make-velocity -10 -12)))
(define STAR-AFTER-X-0
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 5 388) (make-velocity 10 -12)))
(define STAR-BEFORE-Y-0
   (make-doodad "blue" (radial-star 8 10 50 "solid" "blue")
               (make-location 445 11) (make-velocity -10 -12)))
(define STAR-AFTER-Y-0
   (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
               (make-location 435 1) (make-velocity -10 12)))
(define XY-LESS-THAN-ZERO-BEFORE
   (make-doodad "orange" (square 71 "solid" "orange")
               (make-location 5 8) (make-velocity -13 -9)))
(define XY-LESS-THAN-ZERO-AFTER
   (make-doodad "crimson" (square 71 "solid" "crimson")
               (make-location 8 1) (make-velocity 13 9)))
(define IMAGE-OF-PAUSED-INITIAL-WORLD
  (place-image DOODAD1-SHAPE 125 120
               (place-image DOODAD2-SHAPE 460 350 EMPTY-CANVAS)))

(define IMAGE-OF-STAR-DOODAD-INITIAL
  (place-image DOODAD1-SHAPE 125 120 EMPTY-CANVAS))

(define IMAGE-OF-SQUARE-DOODAD-INITIAL
  (place-image DOODAD2-SHAPE 460 350 EMPTY-CANVAS))

(define PAUSE-KEY-EVENT " ")
(define NON-PAUSE-KEY-EVENT "q")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-world : Any -> World
;; GIVEN: any value, this value is ignored
;; RETURNS: the initial world specified for the animation, that is, the world
;;          which includes the two doodads at their initial positions.
;; EXAMPLE: (initial-world -174) = (make-world
;;          (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
;;                              (make-location 125 120) (make-velocity 10 12))
;;          (make-doodad "gray" (square 71 "solid" "gray")
;;                              (make-location 460 350) (make-velocity -13 -9))
;;           #false)

(define (initial-world any)
  (make-world (make-doodad gold DOODAD1-SHAPE 
                           (make-location X-COORD-OF-STAR Y-COORD-OF-STAR)
                           (make-velocity VEL-X-OF-STAR VEL-Y-OF-STAR))
              (make-doodad gray DOODAD2-SHAPE 
                           (make-location X-COORD-OF-SQUARE Y-COORD-OF-SQUARE)
                           (make-velocity VEL-X-OF-SQUARE VEL-Y-OF-SQUARE))
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
  (big-bang (initial-world speed)
            (on-tick world-after-tick speed)
            (on-draw world-to-scene)
            (on-key world-after-key-event)))


;; world-after-tick : World -> World
;; GIVEN: any World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick.If the
;;          world is paused the same present world is returned else a new world
;;          is created after every tick. For every single tick the doodads are
;;          also created based on the conditions specified in doodad-after-tick
;; EXAMPLES:
;;     (world-after-tick WORLD-AT-INITIAL-POSITIONS)
;;       = (make-world (make-doodad "gold" (radial-star 8 10 50 "solid" "gold")
;;                       (make-location 135 132) (make-velocity 10 12))
;;                       (make-doodad "gray" (square 71 "solid" "gray")
;;                      (make-location 447 341) (make-velocity -13 -9)) #false)
;; STRATEGY:Use template for World on w

(define (world-after-tick w)
(if  (world-paused? w)
    w
    (make-world
        (doodad-after-tick (world-doodad-star w))
        (doodad-after-tick (world-doodad-square w))
        (world-paused? w))))

;; TESTS

(begin-for-test
  (check-equal? (world-after-tick WORLD-AT-INITIAL-POSITIONS)
                WORLD-AFTER-FIRST-TICK
                "The world after the first tick wasn't created properly")
  (check-equal? (world-after-tick WORLD-AT-PAUSE-INITIAL)
                WORLD-AT-PAUSE-INITIAL
                "The same world hasn't been returned after the tick on pause"))

;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a World and a KeyEvent
;;        The KeyEvent should be a pause,that is, on the press of the space key
;; RETURNS: If the Key Event,that is," " has been pressed,then the world will
;;         pause if it is not in pause mode previously and if previously the
;;         screen was on pause,that is, freeze then the animation gets active.
;; EXAMPLES:
;; (world-after-key-event WORLD-AT-INITIAL-POSITIONS " ")
;;                               = WORLD-AT-PAUSE-INITIAL
;; (world-after-key-event WORLD-AT-INITIAL-POSITIONS "k")
;;                               = WORLD-AT-INITIAL-POSITIONS

(define (world-after-key-event w ke)
  (if (is-pause-key-event? ke)
      (world-with-paused-toggled w)
      w))

;; TESTS
(begin-for-test
  (check-equal?
   (world-after-key-event WORLD-AT-INITIAL-POSITIONS PAUSE-KEY-EVENT )
   WORLD-AT-PAUSE-INITIAL
   "The unpaused world did not pause after ' ' KeyEvent'")
  
  (check-equal?
   (world-after-key-event WORLD-AT-INITIAL-POSITIONS NON-PAUSE-KEY-EVENT)
   WORLD-AT-INITIAL-POSITIONS
   "The unpaused world did pause after 'q' KeyEvent'")
  
  (check-equal?
   (world-after-key-event WORLD-AT-PAUSE-INITIAL PAUSE-KEY-EVENT )
   WORLD-AT-INITIAL-POSITIONS
   "The paused world did not unpause after ' ' KeyEvent'")
  
  (check-equal?
   (world-after-key-event WORLD-AT-PAUSE-INITIAL NON-PAUSE-KEY-EVENT)
   WORLD-AT-PAUSE-INITIAL
   "The paused world did unpause after 'q' KeyEvent'"))


;; world-paused? : World -> Boolean
;; GIVEN: a World, which has a value world-pause? whose value is true if the
;;        the world is in pause state and false when the world is active.
;; RETURNS: true when the given World is paused and returns false when the
;;          given world is active.
;; EXAMPLE: (world-paused? WORLD-AT-PAUSE-INITIAL) = true
;;          (world-paused? WORLD-AT-INITIAL-POSITIONS) = false
;; STRATEGY: Use template for World on world

(define (world-paused? world)
  (world-pause? world))

;; TESTS
(begin-for-test
  (check-equal? (world-paused? WORLD-AT-PAUSE-INITIAL)true
                "The world is frozen so the value for world-paused? is true")
  (check-equal? (world-paused? WORLD-AT-INITIAL-POSITIONS)false
                "The world is active so the value for world-paused? is false"))

          
;; world-doodad-star : World -> Doodad
;; GIVEN: a World, which is a struct having two doodads, one of them is a
;;        star-like doodad and another is a square doodad.
;; RETURNS: the star-like Doodad of the World is returned
;; EXAMPLES:
;; (world-doodad-star WORLD-AT-INITIAL-POSITIONS) = DOODAD-STAR-INITIAL
;; STRATEGY: Use template for World on world

(define (world-doodad-star world)
  (world-doodad1 world))

;; TESTS
(begin-for-test
  (check-equal? (world-doodad-star WORLD-AT-INITIAL-POSITIONS)
                DOODAD-STAR-INITIAL
                "The star like doodad has not been returned"))
  
;; world-doodad-square : World -> Doodad
;; GIVEN: a World, which is a struct having two doodads, one of them is a
;;        star-like doodad and another is a square doodad.
;; RETURNS: the square Doodad of the World is returned
;; EXAMPLES:
;; (world-doodad-square WORLD-AT-INITIAL-POSITIONS) = DOODAD-SQUARE-INITIAL
;; STRATEGY: Use template for World on world

(define (world-doodad-square world)
  (world-doodad2 world))

;; TESTS
(begin-for-test
  (check-equal? (world-doodad-square WORLD-AT-INITIAL-POSITIONS)
                DOODAD-SQUARE-INITIAL
                "The square doodad has not been returned"))

;; doodad-x : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer,the x co-ordinate of the center of the doodad.
;; EXAMPLES:
;; (doodad-x DOODAD-STAR-INITIAL) = 125
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Location on doodad

(define (doodad-x doodad)
  (location-x (doodad-location doodad)))

;;TESTS
(begin-for-test
  (check-equal? (doodad-x DOODAD-STAR-INITIAL)125
                "The x co-ordinate of the doodad is not 125"))

;; doodad-y : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: an Integer,the y co-ordinate of the center of the doodad.
;; EXAMPLES:
;; (doodad-y DOODAD-STAR-INITIAL) = 120
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Location on doodad

(define (doodad-y doodad)
  (location-y (doodad-location doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-y DOODAD-STAR-INITIAL)120
                "The y-co-ordinate of the doodad is not 120"))

;; doodad-vx : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: vx,an Integer,which specifies the number of pixels the doodad
;;          should move on each tick in the x direction.
;; EXAMPLES:
;; (doodad-vx DOODAD-STAR-INITIAL) = 10
;; (doodad-vx DOODAD-SQUARE-INITIAL) = -13
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Velocity on doodad

(define (doodad-vx doodad)
  (velocity-vx (doodad-velocity doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-vx DOODAD-STAR-INITIAL)10
                "The velocity in the x direction of the doodad is not 10")
  (check-equal? (doodad-vx DOODAD-SQUARE-INITIAL)-13
                "The velocity in the x direction of the doodad is not -13"))


;; doodad-vy : Doodad -> Integer
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: vy,an Integer,which specifies the number of pixels the doodad
;;          should move on each tick in the y direction.
;; EXAMPLES:
;; (doodad-vy DOODAD-STAR-INITIAL) = 12
;; (doodad-vy DOODAD-SQUARE-INITIAL) = -9
;; STRATEGY: Use template for Doodad on doodad and also use template of
;;           Velocity on doodad

(define (doodad-vy doodad)
  (velocity-vy (doodad-velocity doodad)))

;; TESTS
(begin-for-test
  (check-equal? (doodad-vy DOODAD-STAR-INITIAL)12
                "The velocity in the y direction of the doodad is not 12")
  (check-equal? (doodad-vy DOODAD-SQUARE-INITIAL)-9
                "The velocity in the y direction of the doodad is not -9"))

;; doodad-color : Doodad -> Color
;; GIVEN: a Doodad, which is either a star like doodad or the square doodad.
;; RETURNS: the color of the Doodad.
;; gold,green and blue are the colors of the star which change in the same
;; order one after the other after a core bounce on the star doodad
;; gray,olivedrab,khaki,orange,crimson are the colors of the square which
;; change in the same order one after the other after a core bounce on the
;; square doodad
;; EXAMPLES:
;; (doodad-color DOODAD-STAR-INITIAL) = "gold"
;; (doodad-color DOODAD-SQUARE-INITIAL) = "gray"
;; STRATEGY: Use template of Doodad on doodad

(define (doodad-color doodad)
    (doodad-colour doodad))

(begin-for-test
  (check-equal? (doodad-color DOODAD-STAR-INITIAL)gold
                "The color of the doodad is not gold"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HELPER FUNCTIONS

;; world-to-scene: World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene that portrays the given world.The two doodads are placed in
;;          the empty rectangular canvas.
;; EXAMPLE:
;; (world-to-scene WORLD-AT-PAUSE-INITIAL) = IMAGE-OF-PAUSED-INITIAL-WORLD
;; STRATEGY: Use template World for w 

(define (world-to-scene w)
    (place-doodad
      (world-doodad1 w)
      (place-doodad
       (world-doodad2 w)
       EMPTY-CANVAS)))

;; TESTS
(begin-for-test
  (check-equal?
   (world-to-scene WORLD-AT-PAUSE-INITIAL)
   IMAGE-OF-PAUSED-INITIAL-WORLD
   "world-to-scene WORLD-AT-PAUSED-INITIAL returned incorrect image"))
  
;; place-doodad: Doodad Scene -> Scene
;; GIVEN: a Doodad and a Scene. The given Doodad should be placed in the
;;        given Scene. The Scene is initially an empty canvas but after placing
;;        one doodad into the scene, the scene for the next doodad is no
;;        longer the empty canvas.The new scene contains the placed doodad.
;; RETURNS: a scene like the given one, but with the given doodads placed on it
;; EXAMPLES:
;; (place-doodad DOODAD-STAR-INITIAL) = IMAGE-OF-STAR-DOODAD-INITIAL
;; (place-doodad DOODAD-SQUARE-INITIAL) = IMAGE-OF-SQUARE-DOODAD-INITIAL
;; STRATEGY: Combining simpler functions

(define (place-doodad doodad scene)
  (place-image (doodad-shape doodad) (doodad-x doodad) (doodad-y doodad) scene))

;; TESTS
(begin-for-test
  (check-equal?
   (place-doodad DOODAD-STAR-INITIAL EMPTY-CANVAS)
   IMAGE-OF-STAR-DOODAD-INITIAL
   "(place-doodad DOODAD-STAR-INITIAL) returned unexpected image or value")
  (check-equal?
   (place-doodad DOODAD-SQUARE-INITIAL EMPTY-CANVAS)
   IMAGE-OF-SQUARE-DOODAD-INITIAL
   "(place-doodad DOODAD-SQUARE-INITIAL) returned unexpected image or value"))


;; world-with-paused-toggled : World -> World
;; GIVEN: a World, which is either frozen or active due to the " " KeyEvent
;; RETURNS: a world just like the given one, but with paused? toggled,that is,
;;          if the value of the world-paused? for a given world is false the
;;          value is changed to true.If the value of the world-paused? for a
;;          given world is true the value is changed to false.
;; EXAMPLES:
;; (world-with-paused-toggled WORLD-AT-INITIAL-POSITIONS)
;;          = WORLD-AT-PAUSE-INITIAL
;; (world-with-paused-toggled WORLD-AT-PAUSE-INITIAL)
;;          = WORLD-AT-INITIAL-POSITIONS
;; STRATEGY: Use template for World on w

(define (world-with-paused-toggled w)
  (make-world
   (world-doodad1 w)
   (world-doodad2 w)
   (not (world-paused? w))))
          
;; TESTS
(begin-for-test
  (check-equal?
   (world-with-paused-toggled WORLD-AT-INITIAL-POSITIONS)
   WORLD-AT-PAUSE-INITIAL
   "(world-with-pause-toggled WORLD-AT-INITIAL-POSITIONS) did not change the
     world-paused? value")
  (check-equal?
   (world-with-paused-toggled WORLD-AT-PAUSE-INITIAL)
   WORLD-AT-INITIAL-POSITIONS
   "(world-with-pause-toggled WORLD-AT-PAUSE-INITIAL) did not change the
     world-paused? value"))

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent is given to check whether it is a pauseKeyEvent or not.
;;        The pause KeyEvent is represented by " ".So the pause KeyEvent given
;;        is checked for " ".
;; RETURNS: true if the KeyEvent represents a pause instruction,that is, the
;;          KeyEvent is " ". It returns false when the KeyEvent is anything
;;          other than " ".
;; EXAMPLES:
;; (is-pause-key-event? PAUSE-KEY-EVENT) = true
;; (is-pause-key-event? NON-PAUSE-KEY-EVENT) = false

(define (is-pause-key-event? ke)
  (key=? ke " "))

;; TESTS
(begin-for-test
  (check-equal? (is-pause-key-event? PAUSE-KEY-EVENT)true
                "is-pause-key-event? is returning false for ' ' KeyEvent")
  (check-equal? (is-pause-key-event? NON-PAUSE-KEY-EVENT)false
                "is-pause-key-event? is returning true for 'q' KeyEvent"))

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
;; (doodad-after-tick DOODAD-STAR-INITIAL) = STAR-INITIAL-AFTER-TICK
;; STAR-INITIAL-AFTER-TICK has new x and y co-ordinates which have changed
;; according to the corresponding vx and vy velocity values after one tick
;; (doodad-after-tick DOODAD-SQUARE-INITIAL) = SQUARE-INITIAL-AFTER-TICK
;; SQUARE-INITIAL-AFTER-TICK has new x and y co-ordinates which have changed
;; according to the corresponding vx and vy velocity values after one tick
;; STRATEGY: Dividing into cases and combining simple functions

(define (doodad-after-tick doodad)
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
          (doodad-at-y-boundary doodad)]))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-after-tick STAR-BEFORE-Y-449)
   STAR-AFTER-Y-449
   "the doodad did not change accordingly after the y coordinate hit 449")
  (check-equal?
   (doodad-after-tick STAR-BEFORE-X-601)
   STAR-AFTER-X-601
   "the doodad did not change accordingly after the x coordinate hit 601")
  (check-equal?
   (doodad-after-tick STAR-BEFORE-X-0)
   STAR-AFTER-X-0
   "the doodad did not change accordingly after the x coordinate hit 0")
  (check-equal?
   (doodad-after-tick STAR-BEFORE-Y-0)
   STAR-AFTER-Y-0
   "the doodad did not change accordingly after the y coordinate hit 0")
  (check-equal?
   (doodad-after-tick XY-LESS-THAN-ZERO-BEFORE)
   XY-LESS-THAN-ZERO-AFTER
   "the doodad did not change accordingly when both y and x are less than o"))
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tentative-x : Doodad -> Integer
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: the tentative x co-ordinate is returned, which is the sum of the
;;          velocity in x direction and the present x position
;; EXAMPLES:
;; (tentative-x DOODAD-STAR-INITIAL) = 135
;; the x-coordinate of the doodad is 125 and the vx value is 10 so the tentative
;; x-position is 135
;; STRATEGY: Use template Doodad on doodad

(define (tentative-x doodad)
                   (+ (doodad-x doodad) (doodad-vx doodad)))

;; TESTS
(begin-for-test
  (check-equal? (tentative-x DOODAD-STAR-INITIAL)135
                "the tentative x-position has not been calculated right"))

;; tentative-y : Doodad -> Integer
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: the tentative y co-ordinate is returned, which is the sum of the
;;          velocity in y direction and the present y position
;; EXAMPLES:
;; (tentative-y DOODAD-STAR-INITIAL) = 132
;; the y-coordinate of the doodad is 120 and the vy value is 12 so the tentative
;; y-position is 132
;; STRATEGY: Use template Doodad on doodad

(define (tentative-y doodad)
                   (+ (doodad-y doodad) (doodad-vy doodad)))

;; TESTS
(begin-for-test
  (check-equal? (tentative-y DOODAD-STAR-INITIAL)132
                "the tentative y-position has not been calculated right"))

;; doodad-in-between-border : Doodad -> Doodad
;; GIVEN: a Doodad, which is either a square or star doodad
;; RETURNS: a Doodad, after a tick the Doodad's change their color or velocity
;;          or the location.If the doodad is in between the borders of the
;;          empty canvas then the tentative x and y positions become the new
;;          x and y positions.In this case the colour does not change as there
;;          is no core bounce.
;; EXAMPLES:
;; (doodad-in-between-border DOODAD-STAR-INITIAL) = STAR-INITIAL-AFTER-TICK
;; STRATEGY: Use template for Doodad on doodad

(define (doodad-in-between-border doodad)
    (make-doodad  (doodad-color doodad) (doodad-shape doodad)
                  (make-location (tentative-x doodad)
                                 (tentative-y doodad))
                  (make-velocity (doodad-vx doodad) (doodad-vy doodad))))

;; TESTS:
(begin-for-test
  (check-equal?
   (doodad-in-between-border DOODAD-STAR-INITIAL)
   STAR-INITIAL-AFTER-TICK
   "The doodad did not move to its tentative positions in between the border"))

                                  
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
                                 (- 0 (doodad-vy doodad)))))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-less-than-origin XY-LESS-THAN-ZERO-BEFORE)
   XY-LESS-THAN-ZERO-AFTER
   "The doodad didnt move to its tentative positions in when x and y are <0"))

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
                  (make-velocity (- 0 (doodad-vx doodad)) (doodad-vy doodad))))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-at-x-zero STAR-BEFORE-X-0)
   STAR-AFTER-X-0
   "The doodad didnt move to its tentative positions in when tentative x<0"))

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
                  (make-velocity  (doodad-vx doodad) (- 0 (doodad-vy doodad)))))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-at-tentative-y-zero STAR-BEFORE-Y-0)
   STAR-AFTER-Y-0
      "The doodad didnt move to its tentative positions in when tentative y<0"))

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
                  (make-velocity (- 0 (doodad-vx doodad)) (doodad-vy doodad))))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-at-x-boundary STAR-BEFORE-X-601)
   STAR-AFTER-X-601
   "The doodad didnt move to its tentative positions in when tentative x>601"))

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
                  (make-velocity (doodad-vx doodad) (- 0 (doodad-vy doodad)))))

;; TESTS
(begin-for-test
  (check-equal?
   (doodad-at-y-boundary STAR-BEFORE-Y-449)
   STAR-AFTER-Y-449
   "The doodad didnt move to its tentative positions in when tentative y>449"))

