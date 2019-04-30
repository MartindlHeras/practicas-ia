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
(defvar *alias* 'TePartoAlMedio) ; alias que aparece en el ranking

(defun heuristica (estado)
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
        (let* ((vertical (contar-columna tablero ficha-actual ficha-oponente 3 0))
               (esquina1 (contar-columna tablero ficha-actual ficha-oponente 0 0))
               (esquina2 (contar-columna tablero ficha-actual ficha-oponente 6 0)))
          (setf puntuacion-actual
            (cond ((< vertical 6)
                   (+ vertical (/ +val-max+ 2)))
                   ((if (< esquina1 5)
                        (if (> esquina1 0)
                              (+ esquina1 (/ +val-max+ 4))
                              (if (< esquina2 5)
                                    (if (> esquina2 0)
                                          (+ esquina2 (/ +val-max+ 4))
                                          0)))))
                   (t 0))))
        puntuacion-actual))))


(defun contar-columna (tablero ficha-actual ficha-oponente columna fila)
  (if (or (not (dentro-del-tablero-p tablero columna fila))
          (and (not (eql (obtener-ficha tablero columna fila) ficha-actual))
               (not (eql (obtener-ficha tablero columna fila) ficha-oponente))))
      0
    (1+ (contar-columna tablero ficha-actual ficha-oponente columna (1+ fila)))))
