(defmodule SALIDA
    (import MAIN ?ALL)
    (import HEURISTICA ?ALL)
    (import REFINAMIENTO deftemplate estado-refinamiento)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCIONES AUXILIARES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction SALIDA::mejor-alojamiento (?ciu)
    (bind ?lista (send ?ciu get-tieneAlojamiento))
    (if (= (length$ ?lista) 0)
        then
            (return FALSE))

    (bind ?mejor (nth$ 1 ?lista))
    (bind ?precioMejor (float (send ?mejor get-precio_noche)))

    (loop-for-count (?i 2 (length$ ?lista)) do
        (bind ?a (nth$ ?i ?lista))
        (bind ?p (float (send ?a get-precio_noche)))
        (if (< ?p ?precioMejor)
            then
                (bind ?mejor ?a)
                (bind ?precioMejor ?p))
    )

    (return ?mejor)
)

(deffunction SALIDA::dias-objetivo-viaje (?nCiudades)
    (bind ?dmin (send [usuario1] get-dias_min))
    (bind ?dmax (send [usuario1] get-dias_max))
    (bind ?cmax (send [usuario1] get-ciudades_max))

    (bind ?base (max 1 (integer (/ ?dmax (max 1 ?cmax)))))
    (bind ?diasEstimados (* ?nCiudades ?base))

    (if (< ?diasEstimados ?dmin)
        then
            (bind ?diasEstimados ?dmin))
    (if (> ?diasEstimados ?dmax)
        then
            (bind ?diasEstimados ?dmax))
    (if (< ?diasEstimados ?nCiudades)
        then
            (bind ?diasEstimados ?nCiudades))

    (return ?diasEstimados)
)

(deffunction SALIDA::dias-en-parada (?diasTotales ?nCiudades ?posicion)
    (bind ?base (integer (/ ?diasTotales ?nCiudades)))
    (bind ?resto (- ?diasTotales (* ?base ?nCiudades)))

    (if (<= ?posicion ?resto)
        then
            (return (+ ?base 1))
        else
            (return ?base))
)

(deffunction SALIDA::coste-parada (?ciu ?dias)
    (bind ?aloj (mejor-alojamiento ?ciu))
    (bind ?precioAloj
        (if (eq ?aloj FALSE)
            then 0.0
            else (float (send ?aloj get-precio_noche))))
    (bind ?nivelVida (float (send ?ciu get-nivel_de_vida)))

    (return (+ (* (float ?dias) ?precioAloj)
               (* 25.0 ?nivelVida)))
)

(deffunction SALIDA::buscar-transporte (?origen ?destino ?odio)
    (bind ?lista
        (find-all-instances ((?trans Transporte))
            (and (eq (send ?trans get-tieneOrigen) ?origen)
                 (eq (send ?trans get-tieneFin) ?destino)
                 (or (eq ?odio "")
                     (eq ?odio "Ninguno")
                     (neq (send ?trans get-medio) ?odio)))))

    (if (> (length$ ?lista) 0)
        then
            (return (nth$ 1 ?lista))
        else
            (return FALSE))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCIONES DE PRESENTACION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction SALIDA::mostrar-parada (?ciu ?pos ?dias)
    (bind ?aloj (mejor-alojamiento ?ciu))
    (bind ?nombreHotel
        (if (eq ?aloj FALSE)
            then "Sin alojamiento asignado"
            else (send ?aloj get-nombre)))
    (bind ?precio (coste-parada ?ciu ?dias))

    (printout t "PARADA " ?pos ": " (send ?ciu get-nombre) " (" ?dias " dias)" crlf)
    (printout t "  * ALOJAMIENTO : " ?nombreHotel crlf)
    (printout t "  * COSTE PARADA: " (integer ?precio) " EUR" crlf)
    (printout t "------------------------------------------" crlf)
)

(deffunction SALIDA::mostrar-trayecto (?ciuOri ?ciuDest ?odio)
    (bind ?t (buscar-transporte ?ciuOri ?ciuDest ?odio))

    (if (neq ?t FALSE)
        then
            (printout t "  >> "
                        (send ?t get-medio)
                        " | "
                        (send ?t get-duracion_horas)
                        "h | "
                        (integer (send ?t get-precio))
                        " EUR"
                        crlf)
        else
            (printout t "  >> (Sin transporte directo disponible)" crlf))
)

(deffunction SALIDA::mostrar-itinerario (?trip)
    (bind ?ciudades (send ?trip get-incluyeCiudad))
    (bind ?nCiudades (send ?trip get-n_ciudades))
    (bind ?diasTotales (send ?trip get-durada_dias))
    (bind ?odio (send [usuario1] get-transporte_odiado))

    (if (> ?nCiudades 0)
        then
            (bind ?dias1 (dias-en-parada ?diasTotales ?nCiudades 1))
            (mostrar-parada (nth$ 1 ?ciudades) 1 ?dias1)

            (if (> ?nCiudades 1)
                then
                    (loop-for-count (?i 2 ?nCiudades) do
                        (bind ?ori (nth$ (- ?i 1) ?ciudades))
                        (bind ?des (nth$ ?i ?ciudades))
                        (bind ?diasI (dias-en-parada ?diasTotales ?nCiudades ?i))
                        (mostrar-trayecto ?ori ?des ?odio)
                        (mostrar-parada ?des ?i ?diasI))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; REGLAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule SALIDA::mostrar-cabecera
    (declare (salience 100))
    (estado-refinamiento (fase COMPLETADO))
    (not (cabecera-mostrada))
=>
    (assert (cabecera-mostrada))
    (printout t crlf "==========================================" crlf)
    (printout t "       TU ITINERARIO PERSONALIZADO" crlf)
    (printout t "==========================================" crlf crlf)
)

(defrule SALIDA::mostrar-viaje-final
    (declare (salience 90))
    (cabecera-mostrada)
    ?trip <- (object (is-a ViajeCandidato)
                     (seleccionado SI)
                     (valido SI))
    (not (viaje-mostrado))
=>
    (mostrar-itinerario ?trip)
    (assert (viaje-mostrado))
)

(defrule SALIDA::mostrar-resumen-final
    (declare (salience 80))
    (viaje-mostrado)
    (not (resumen-mostrado))
    ?trip <- (object (is-a ViajeCandidato)
                     (seleccionado SI)
                     (valido SI))
=>
    (printout t crlf "==========================================" crlf)
    (printout t "           RESUMEN DE TU VIAJE" crlf)
    (printout t "==========================================" crlf)
    (printout t "Ciudades   : " (send ?trip get-n_ciudades) crlf)
    (printout t "Duracion   : " (send ?trip get-durada_dias) " dias" crlf)
    (printout t "Coste      : " (integer (send ?trip get-precio_total)) " EUR" crlf)
    (printout t "Puntuacion : " (send ?trip get-puntuacion) crlf)
    (printout t "==========================================" crlf crlf)
    (assert (resumen-mostrado))
)

(defrule SALIDA::sin-solucion
    (declare (salience 70))
    (estado-refinamiento (fase COMPLETADO))
    (cabecera-mostrada)
    (not (viaje-mostrado))
    (not (object (is-a ViajeCandidato)
                 (seleccionado SI)
                 (valido SI)))
    (not (resumen-mostrado))
=>
    (printout t "No se ha podido generar un itinerario valido con las restricciones actuales." crlf crlf)
    (assert (resumen-mostrado))
)
