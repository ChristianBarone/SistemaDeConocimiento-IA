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

    (bind ?mejor FALSE)
    (bind ?precioMejor 999999.0)

    (loop-for-count (?i 1 (length$ ?lista)) do
        (bind ?a (nth$ ?i ?lista))
        (if (instance-existp ?a)
            then
                (bind ?p_raw (send ?a get-precio_noche))
                (if (numberp ?p_raw)
                    then
                        (bind ?p (float ?p_raw))
                        (if (< ?p ?precioMejor)
                            then
                                (bind ?mejor ?a)
                                (bind ?precioMejor ?p)))
        )
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

(deffunction SALIDA::mostrar-parada (?ciu ?dias)
    (if (not (instance-existp ?ciu))
        then
            (printout t "  - [Error: Instancia de ciudad invalida o no encontrada]" crlf)
            (return))

    (printout t "  - Ciudad: " (send ?ciu get-nombre) " (" ?dias " dias)" crlf)
    (bind ?aloj (mejor-alojamiento ?ciu))

    (if (neq ?aloj FALSE)
        then
            (bind ?p_raw (send ?aloj get-precio_noche))
            (bind ?precio (if (numberp ?p_raw) then (float ?p_raw) else 0.0))
            (printout t "    Alojamiento recomendado: " (send ?aloj get-nombre)
                        " (" ?precio " EUR/noche)" crlf)
        else
            (printout t "    Alojamiento recomendado: No hay alojamientos disponibles registrados." crlf))
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

(deffunction SALIDA::mostrar-itinerario ($?ciudades)
    (bind ?n (length$ ?ciudades))
    (if (= ?n 0) then (return))

    (bind ?diasTotales (send [viaje-final] get-durada_dias))
    (bind ?diasPorCiudad (max 1 (integer (/ ?diasTotales ?n))))

    (printout t crlf "ITINERARIO PROPUESTO:" crlf)
    (loop-for-count (?i 1 ?n) do
        (bind ?ciu (nth$ ?i ?ciudades))
        (mostrar-parada ?ciu ?diasPorCiudad)
    )
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
    ;; Extraemos el contenido del multislot incluyeCiudad en la variable $?ciudades
    ?trip <- (object (is-a ViajeCandidato)
                     (seleccionado TRUE)
                     (valido TRUE)
                     (incluyeCiudad $?ciudades))
    (not (viaje-mostrado))
=>
    ;; ¡Ahora sí! Le pasamos la lista de ciudades pura a la función de impresión
    (mostrar-itinerario ?ciudades)
    (assert (viaje-mostrado))
)

(defrule SALIDA::mostrar-resumen-final
    (declare (salience 80))
    (viaje-mostrado)
    (not (resumen-mostrado))
    ?trip <- (object (is-a ViajeCandidato)
                     (seleccionado TRUE)
                     (valido TRUE))
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
                 (seleccionado TRUE)
                 (valido TRUE)))
    (not (resumen-mostrado))
=>
    (printout t "No se ha podido generar un itinerario valido con las restricciones actuales." crlf crlf)
    (assert (resumen-mostrado))
)