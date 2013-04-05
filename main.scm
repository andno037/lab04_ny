(load "world-init.scm")
(load "table-helper.scm")
(load "player-commands.scm")


(define (new-game)

(display "Du har flytt till Berzan, ty du är rätt för Katedral. Här är du säker, för tillfället... \n")  
  
(define (loop)
  (display ">>")
  (enter-new-command!)
  (cond
    ((eof-object? (get-command-name) )'GTFO)
    ((eq? (get-command-name) 'quit)  'GTFO!)
    ((not(get 'game-commands (get-command-name))) 
     (display "Vad gör du din idiot? ")
     (display (get-command-name))
     (display " är inget kommando!")
     (newline)
     (loop))
    (else  (apply (get 'game-commands (get-command-name)) (get-command-arguments)) (loop))))(loop))