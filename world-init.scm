(load "interaction-utils.scm")
(load "object-system.scm")
(load "make-agent.scm")
(load "pram-la-04.scm")
(load "make-place.scm")
(load "make-thing.scm")



(define Datasekten (make-place 'Datasekten "Det luktar varm dator här inne, såväl som billigt klägg."))
(define H409 (make-place 'H409 "Detta är BERPAS rum. Låt inte BERPA se dig!!"))
(define T200 (make-place 'T200 "Detta rum fungerar som den store Gyulais högkvarter."))
(define Trapphus (make-place 'Trapphus "Trappor som leder lite överallt."))
(define Matsal (make-place 'Matsal "Underkasta dig den mäktige Jakob och hans tallriksautomat!"))

(define (make&add-agent name desc place)
(let ((new-agent (make-agent name desc)))
(ask new-agent 'move-to! place)
new-agent))

(define (make&add-item name desc place)
(let ((new-item (make-thing name desc)))
(ask new-item 'move-to! place)
new-item))

(define (connect-places! place1 exit1 place2 exit2)
(ask place1 'add-neighbour exit1 place2)
(ask place2 'add-neighbour exit2 place1))

(connect-places! Trapphus 'Upp H409 'Ner)
(connect-places! Trapphus 'Vänster datasekten 'Höger)
(connect-places! Trapphus 'Höger matsal 'Vänster)
(connect-places! Trapphus 'Ner t200 'Upp)

(define BERPA
(make&add-agent 'BERPA
"Den onda BERPA grymtar åt dig."
H409))
(define Gyulai
(make&add-agent 'Gyulai
"Gyulai uppmuntrar dig att fortsätta längre in i datorns underbara värld."
T200))
(define *player*
(make&add-agent 'spelare
"Detta är du själv."
Datasekten))
(define Jakob
(make&add-agent 'Jakob
"Fyra in, fyra ut! - Jakob, skolvärd."
Matsal))
(define Sektmål
  (make&add-item 'Sektmål "Chokladboll och Dr. Pepper! Mums!" Datasekten))

(define BERPAS-penna
  (make&add-item 'BERPAS-penna "Den onda pennan som BERPA använder för att rätta dina stavfel!" Datasekten))


