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
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
                (setf puntuacion-actual
                  (+ puntuacion-actual
                     (cond ((= abajo 0) 0)
                           ((= abajo 1) 0)
                           ((= abajo 2) 0)
                           ((= abajo 3) 0))
                     (cond ((= der 0) 0)
                           ((= der 1) 0)
                           ((= der 2) 0)
                           ((= der 3) 0))
                     (cond ((= izq 0) 0)
                           ((= izq 1) 0)
                           ((= izq 2) 0)
                           ((= izq 3) 0))
                     (cond ((= abajo-izq 0) 0)
                           ((= abajo-izq 1) 0)
                           ((= abajo-izq 2) 0)
                           ((= abajo-izq 3) 0))
                     (cond ((= arriba-der 0) 0)
                           ((= arriba-der 1) 0)
                           ((= arriba-der 2) 0)
                           ((= arriba-der 3) 0))
                     (cond ((= arriba-izq 0) 0)
                           ((= arriba-izq 1) 0)
                           ((= arriba-izq 2) 0)
                           ((= arriba-izq 3) 0)))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-oponente columna fila))
                     (der (contar-derecha tablero ficha-oponente columna fila))
                     (izq (contar-izquierda tablero ficha-oponente columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
                (setf puntuacion-oponente
                  (+ puntuacion-oponente
                     (cond ((= abajo 0) 0)
                           ((= abajo 1) 10)
                           ((= abajo 2) 100)
                           ((= abajo 3) 1000))
                     (cond ((= der 0) 0)
                           ((= der 1) 10)
                           ((= der 2) 100)
                           ((= der 3) 1000))
                     (cond ((= izq 0) 0)
                           ((= izq 1) 10)
                           ((= izq 2) 100)
                           ((= izq 3) 1000))
                     (cond ((= abajo-izq 0) 0)
                           ((= abajo-izq 1) 10)
                           ((= abajo-izq 2) 100)
                           ((= abajo-izq 3) 1000))
                     (cond ((= arriba-der 0) 0)
                           ((= arriba-der 1) 10)
                           ((= arriba-der 2) 100)
                           ((= arriba-der 3) 1000))
                     (cond ((= arriba-izq 0) 0)
                           ((= arriba-izq 1) 10)
                           ((= arriba-izq 2) 100)
                           ((= arriba-izq 3) 1000))))))
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
;       (1)))))
