
(defun entrenador (jugador1 jugador2 total)
  (let ((ganador (ganador (partida *jugador-prueba2* *jugador-prueba2*))))
    (cond ((not ganador) 0)
      ((eql ganador 0) (1+ total))
      (t (1- total))))
  total)

(print (entrenador *jugador-prueba2* *jugador-prueba2* 0))
