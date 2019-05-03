;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRACTICA 4 INTELIGENCIA ARTIFICIAL
;;
;; AUTORES:
;; Santiago Valderrabano Zamorano --> santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno     --> martin.delasheras@estudiante.uam.es
;;
;; Grupo 2302
;; Pareja 3
;;
;; Codigo heuristica: FC259
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :2302_P03_ab29a ; se declara un paquete con el grupo, la pareja y
  ; el código
  (:use :common-lisp :conecta4)  ; el paquete usa common-lisp y conecta4
  (:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias
(in-package 2302_P03_ab29a)
(defvar *alias* 'DefensaNumantina) ; alias que aparece en el ranking

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; En esta heuristica, hemos optado por una version simple de la inicial
;; centrada fundamentalmente en la defensa, como en todas las heuristicas,
;; empieza por comprobar si hay ganador, dando la maxima puntuacion en caso de
;; ganemos nosotros y la minima si gana el oponente. Despues, para el jugador
;; comprueba si tiene 3 fichas seguidas en algun lado suma 3000, en caso
;; contrario no suma nada. En cambio para el oponente se computa que tenga 1, 2
;; o 3 fichas seguidas, para luego restar las puntuaciones.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
      (let ((puntuacion-actual 0)
            (puntuacion-oponente 0))
        (loop for columna from 0 below (tablero-ancho tablero) do
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo
                      (contar-abajo
                       tablero ficha-actual columna fila))
                     (arriba
                      (contar-arriba
                       tablero ficha-actual columna fila))
                     (der
                      (contar-derecha
                       tablero ficha-actual columna fila))
                     (izq
                      (contar-izquierda
                       tablero ficha-actual columna fila))
                     (abajo-der
                      (contar-abajo-derecha
                       tablero ficha-actual columna fila))
                     (arriba-izq
                      (contar-arriba-izquierda
                       tablero ficha-actual columna fila))
                     (abajo-izq
                      (contar-abajo-izquierda
                       tablero ficha-actual columna fila))
                     (arriba-der
                      (contar-arriba-derecha
                       tablero ficha-actual columna fila))
                     (horizontal
                      (+ der izq))
                     (vertical
                      (+ abajo arriba))
                     (diag-des
                      (+ abajo-izq arriba-der))
                     (diag-asc
                      (+ abajo-der arriba-izq)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                    (if (= vertical 3)
                      3000
                      0)
                    (if (= horizontal 3)
                      3000
                      0)
                    (if (= diag-des 3)
                      3000
                      0)
                    (if (= diag-asc 3)
                      3000
                      0))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo
                      (contar-abajo
                       tablero ficha-oponente columna fila))
                     (arriba
                      (contar-arriba
                       tablero ficha-actual columna fila))
                     (der
                      (contar-derecha
                       tablero ficha-oponente columna fila))
                     (izq
                      (contar-izquierda
                       tablero ficha-oponente columna fila))
                     (abajo-der
                      (contar-abajo-derecha
                       tablero ficha-oponente columna fila))
                     (arriba-izq
                      (contar-arriba-izquierda
                       tablero ficha-oponente columna fila))
                     (abajo-izq
                      (contar-abajo-izquierda
                       tablero ficha-oponente columna fila))
                     (arriba-der
                      (contar-arriba-derecha
                       tablero ficha-oponente columna fila))
                     (horizontal
                      (+ der izq))
                     (vertical
                      (+ abajo arriba))
                     (diag-des
                      (+ abajo-izq arriba-der))
                     (diag-asc
                      (+ abajo-der arriba-izq)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                    (cond ((= vertical 0) 0)
                          ((= vertical 1) 20)
                          ((= vertical 2) 200)
                          ((= vertical 3) 7000)
                          (t 0))
                    (cond ((= horizontal 0) 0)
                          ((= horizontal 1) 20)
                          ((= horizontal 2) 200)
                          ((= horizontal 3) 7000)
                          (t 0))
                    (cond ((= diag-des 0) 0)
                          ((= diag-des 1) 20)
                          ((= diag-des 2) 200)
                          ((= diag-des 3) 7000)
                          (t 0))
                    (cond ((= diag-asc 0) 0)
                          ((= diag-asc 1) 20)
                          ((= diag-asc 2) 200)
                          ((= diag-asc 3) 7000)
                          (t 0))))))
        (- puntuacion-actual puntuacion-oponente)))))
