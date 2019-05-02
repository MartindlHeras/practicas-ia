;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 3
;; Grupo 2302
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_a2b3d ; se declara un paquete con el grupo, la pareja y
  ; el código
  (:use :common-lisp :conecta4)  ; el paquete usa common-lisp y conecta4
  (:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias
(in-package 2302_P03_a2b3d)
(defvar *alias* 'LosYerbajosDelJavide) ; alias que aparece en el ranking


; MIRAMOS CUANTAS FICHAS TENEMOS EN EL LA COLUMNA CENTRAL.
; POR CADA FICHA NUESTRA, SUMAMOS 3PTS A LA PUNTUACION.

; FORMAMOS GRUPOS DE 4 FICHAS POR CADA COLUMNA.
; EN TOTAL SE FORMAN 3 GRUPOS DE 4 POR COLUMNA.
; A CONTINUACION LOS MANDAMOS A EVALUAR A puntuacion-grupo-4

; FORMAMOS GRUPOS DE 4 FICHAS POR CADA FILA.
; EN TOTAL SE FORMAN 4 GRUPOS DE 4 POR FILA.
; A CONTINUACION LOS MANDAMOS A EVALUAR A puntuacion-grupo-4


; FORMAMOS TODOS LOS POSBILES GRUPOS DE 4 EN DIAGONAL DESCENDENTE
; LOS MANDAMOS A EVALUAR A puntuacion-grupo-4

; FORMAMOS TODOS LOS POSBILES GRUPOS DE 4 EN DIAGONAL ASCENDENTE
; LOS MANDAMOS A EVALUAR A puntuacion-grupo-4

(defun heuristica (estado)
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion 0))
        (loop for filaCentro from 0 below (1- (tablero-alto tablero)) do
              (setf puntuacion
                (+ puntuacion
                   (if (eql
                        (obtener-ficha tablero 3 filaCentro) ficha-actual)
                       3
                     0))))
        (loop for columnaV from 0 below (1- (tablero-ancho tablero)) do
              (loop for filaV from 0 to 2 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaV filaV))
                           (ficha2
                            (obtener-ficha
                             tablero columnaV (+ 1 filaV)))
                           (ficha3
                            (obtener-ficha
                             tablero columnaV (+ 2 filaV)))
                           (ficha4
                            (obtener-ficha
                             tablero columnaV (+ 3 filaV))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaH from 0 below (1- (tablero-alto tablero)) do
              (loop for columnaH from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaH filaH))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaH) filaH))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaH) filaH))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaH) filaH)))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaDD from 3 to 5 do
              (loop for columnaDD from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaDD filaDD))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaDD) (- filaDD 1)))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaDD) (- filaDD 2)))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaDD) (- filaDD 3))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        (loop for filaDA from 0 to 2 do
              (loop for columnaDA from 0 to 3 do
                    (let* ((ficha1
                            (obtener-ficha
                             tablero columnaDA filaDA))
                           (ficha2
                            (obtener-ficha
                             tablero (+ 1 columnaDA) (+ 1 filaDA)))
                           (ficha3
                            (obtener-ficha
                             tablero (+ 2 columnaDA) (+ 2 filaDA)))
                           (ficha4
                            (obtener-ficha
                             tablero (+ 3 columnaDA) (+ 3 filaDA))))
                      (setf puntuacion
                        (+ puntuacion
                           (puntuacion-grupo-4
                            ficha1
                            ficha2
                            ficha3
                            ficha4
                            ficha-actual
                            ficha-oponente))))))
        puntuacion))))

(defun puntuacion-grupo-4 (ficha1 ficha2 ficha3 ficha4 ficha-nuestra ficha-oponente)
  (let ((puntuacion 0)
        (total-nuestra 0)
        (total-oponente 0)
        (total-vacias 0))
    (setf total-nuestra
      (+ total-nuestra
         (cond ((eql
                 ficha-nuestra ficha1)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha2)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha3)
                1)
               (t 0))
         (cond ((eql
                 ficha-nuestra ficha4)
                1)
               (t 0))))
    (setf total-oponente
      (+ total-oponente
         (cond ((eql
                 ficha-oponente ficha1)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha2)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha3)
                1)
               (t 0))
         (cond ((eql
                 ficha-oponente ficha4)
                1)
               (t 0))))
    (setf total-vacias
      (+ total-vacias
         (cond ((null ficha1)
                1)
               (t 0))
         (cond ((null ficha2)
                1)
               (t 0))
         (cond ((null ficha3)
                1)
               (t 0))
         (cond ((null ficha4)
                1)
               (t 0))))
    (setf puntuacion
      (+ puntuacion
         (cond ((= total-nuestra 4)
                100)
               ((and
                 (= total-nuestra 3) (= total-vacias 1))
                5)
               ((and
                 (= total-nuestra 2) (= total-vacias 2))
                2)
               (t 0))
         (if (and
              (= total-oponente 3) (= total-vacias 1))
             -4
           0)))
    puntuacion))
