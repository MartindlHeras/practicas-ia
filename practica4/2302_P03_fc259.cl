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
(defvar *alias* 'Neto&GletoDue) ; alias que aparece en el ranking


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
                     (vertical (contar-abajo tablero ficha-actual columna fila))
                     (diagonal-asc (contar-arriba-derecha tablero ficha-actual columna fila)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                     (cond ((= vertical 0) 0)
                           ((= vertical 1) 10)
                           ((= vertical 2) 100)
                           ((= vertical 3) 1000))
                     (cond ((= diagonal-asc 0) 0)
                           ((= diagonal-asc 1) 10)
                           ((= diagonal-asc 2) 100)
                           ((= diagonal-asc 3) 1000)))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (vertical (contar-abajo tablero ficha-oponente columna fila))
                     (diagonal-asc (contar-arriba-derecha tablero ficha-oponente columna fila)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                     (cond ((= vertical 0) 0)
                           ((= vertical 1) 10)
                           ((= vertical 2) 200)
                           ((= vertical 3) 1500))
                     (cond ((= diagonal-asc 0) 0)
                           ((= diagonal-asc 1) 10)
                           ((= diagonal-asc 2) 200)
                           ((= diagonal-asc 3) 1500))))))
         (loop for fila from 0 below (tablero-alto tablero) do
               (let* ((columna 0)
                      (horizontal (contar-derecha tablero ficha-actual columna fila)))
                 (setf puntuacion-actual
                   (+ puntuacion-actual
                      (cond ((= horizontal 0) 0)
                            ((= horizontal 1) 10)
                            ((= horizontal 2) 100)
                            ((= horizontal 3) 1000)))))
               (let* ((columna 0)
                      (horizontal (contar-derecha tablero ficha-oponente columna fila)))
                 (setf puntuacion-oponente
                   (+ puntuacion-oponente
                      (cond ((= horizontal 0) 0)
                            ((= horizontal 1) 10)
                            ((= horizontal 2) 200)
                            ((= horizontal 3) 1500))))))
        (- puntuacion-actual puntuacion-oponente)))))


;;;; FUNCIONES AUXILIARES ;;;;

; (defun contar-escalera-descendente (tablero ficha columna fila)
;     (+ (if (or (not (dentro-del-tablero-p tablero columna fila))
;     	  (not (eql (obtener-ficha tablero columna fila) ficha)))
;          0
;        (1))
;      (if (or (not (dentro-del-tablero-p tablero columna (1 - fila)))
;       (not (eql (obtener-ficha tablero columna (1 - fila)) ficha)))
;        0
;       (1))
;      (if (or (not (dentro-del-tablero-p tablero (1 - columna) (1 - fila)))
;       (not (eql (obtener-ficha tablero (1- columna) (1 - fila)) ficha)))
;        0
;       (1))))
;
; (defun contar-vertical (tablero ficha columna fila)
;     (+
;      (loop for filaN from fila to 0 do
;       (if (or (not (dentro-del-tablero-p tablero columna filaN))
;     	 (not (eql (obtener-ficha tablero columna filaN) ficha)))
;         0
;       (1 + (contar-vertical tablero ficha columna (1 - fila)))))))
