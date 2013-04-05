(define *command-descriptions* '())

(define (add-command! namn funktion description)
  (put 'game-commands namn funktion)
  (set!  *command-descriptions* (cons (cons namn description) *command-descriptions*)))

(define (install-player-commands)
  (define (look . args) 
    (cond
      
      ((null? args)(display* (ask (ask *player* 'place) 'description) " \n")
                   (display "Dessa personer finns i rummet:\n")
                   (ask(ask *player* 'place)'agents_nice)
                   (if(null? (ask (ask *player* 'place) 'items))
                       (display "Det finns inga föremål här!!!\n")
                       (display "Dessa föremål finns i rummet:\n"))
                   (for-each (lambda (arg) (printf "~a \n" (car arg)))
                             (ask (ask *player* 'place) 'items))
                   (ask (ask *player* 'place ) 'exits_nice)
                   )
      
    ((ask (ask *player* 'place) 'get-neighbour (car args)) (printf "Du ser ~a !\n" (ask (ask (ask *player* 'place) 'get-neighbour (car args)) 'name)))
    ((ask (ask *player* 'place) 'get-agent (car args)) (display (ask (ask (ask *player* 'place) 'get-agent (car args)) 'description))(newline))
    ((ask (ask *player* 'place) 'get-item (car args)) (display (ask (ask (ask *player* 'place) 'get-item (car args)) 'description))(newline))
    (else (display (car args)) (display " finns inte!\n"))
    ))
  
  (define (move . args)
    (cond
      ((ask (ask *player* 'place) 'get-neighbour (car args)) (ask *player* 'Move-to! (ask (ask *player* 'place) 'get-neighbour (car args))) (printf "Du går till ~a. ~n" (ask *player* 'place_nice)))
      (else (display "Du gick in i väggen!\n"))))
  
  (define (drop . args)
    (cond
      ((null? args) (display "Vad ska jag slänga?\n"))
      ((ask *player* 'get-item (car args)) (ask (ask *player* 'get-item (car args)) 'move-to! (ask *player* 'place))  (printf "Du slänger bort ~a. \n" (ask (ask (ask *player* 'place) 'get-item (car args)) 'name)))
      (else (display "Du har inget sådant föremål\n"))))
  
   (define (take . args)
    (cond
      ((null? args) (display "Vad ska jag ta? \n"))
      ((ask (ask *player* 'place) 'get-item (car args)) (ask (ask (ask *player* 'place) 'get-item (car args)) 'move-to! *player*) (printf "Du plockar upp ~a. \n" (ask (ask *player* 'get-item (car args)) 'name)))
      (else (display "Du hittar inget sådant föremål. \n"))))
  
  (define (jump . args)
    (display "Du hoppar!")
    (for-each (lambda (arg) (display* arg " ")) args)
    (newline))
  
  (define (items)
    (if
     (null? (ask *player* 'items))
     (display "Väskan är tom. \n")
     (begin (display "I väskan finns: \n") (for-each (lambda (arg) (printf "~a \n" (car arg))) (ask *player* 'items)))))
  
  (define help 
    (lambda args
    (cond
      ((null? args)(printf "Dessa kommandon finns: \n")
                   (for-each (lambda (arg) (printf "~a   ~a \n" (car arg) (cdr arg))) *command-descriptions*))
      ((assq (car args) *command-descriptions*) (printf "~a   ~a \n" (car args) (cdr (assq (car args) *command-descriptions*))))
      (else (display "Fel"))
    )))
  
  (add-command! 'hjälp help "Visa detta hjälpmeddelande.")
  (add-command! 'titta look "<titta> <objekt> Titta runt omkring dig eller på specifika objekt.")
  (add-command! 'gå move "<gå> <riktning> Gå i en viss riktning.")
  (add-command! 'släng drop "<släng> <objekt> Lägg ett objekt i rummet.")
  (add-command! 'föremål items "Titta i din väska.")
  (add-command! 'ta take "<ta> <objekt> Plocka upp ett specifikt objekt och lägg det i din väska.")
  (add-command! 'hoppa jump "Hoppa."))



(install-player-commands)