;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 3
;; Grupo 2302
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_fc259 ; se declara un paquete con el grupo, la pareja y
  ; el código
  (:use :common-lisp :conecta4)  ; el paquete usa common-lisp y conecta4
  (:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias
(in-package 2302_P03_fc259)
(defvar *alias* 'AVerSiVaDUE) ; alias que aparece en el ranking

(defun prueba1 (estado)
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0))
        (let* ((vertical-actual (contar-abajo tablero ficha-actual 4 0))
               (vertical-oponente (contar-abajo tablero ficha-oponente 4 0))
               (vertical (+ vertical-actual vertical-oponente))
               (esquina1-actual (contar-abajo tablero ficha-actual 0 0))
               (esquina1-oponente (contar-abajo tablero ficha-oponente 0 0))
               (esquina1 (+ esquina1-actual esquina1-oponente))
               (esquina2-actual  (contar-abajo tablero ficha-actual 6 0))
               (esquina2-oponente  (contar-abajo tablero ficha-oponente 6 0))
               (esquina2  (+ esquina2-actual esquina2-oponente)))
          (setf puntuacion-actual
            (cond ((< vertical 5)
                   (cond ((> vertical-actual 0) +val-max+)
                         (t 0)))
                  (t (cond ((< esquina1 5)
                            (cond ((> esquina1-actual 0) +val-max+)
                                  (t 0)))
                           ((< esquina2 5)
                            (cond ((> esquina2-actual 0) +val-max+)
                                  (t 0)))
                           (t 0))))))
        puntuacion-actual))))
