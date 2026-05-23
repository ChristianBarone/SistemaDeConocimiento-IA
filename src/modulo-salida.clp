(defmodule SALIDA
    (import MAIN ?ALL)
    (import HEURISTICA ?ALL)
    (import REFINAMIENTO deftemplate estado-refinamiento)
    (import REFINAMIENTO deftemplate viaje-seleccionado)
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
    (bind ?norm-origen (REFINAMIENTO::normalizar-nombre ?origen))
    (bind ?norm-destino (REFINAMIENTO::normalizar-nombre ?destino))
    (bind ?transportes (find-all-instances ((?t Transporte)) TRUE))

    (loop-for-count (?i 1 (length$ ?transportes)) do
        (bind ?t (nth$ ?i ?transportes))
        (bind ?medio (send ?t get-medio))

        (if (not (and (neq ?odio "") (neq ?odio "Ninguno") (eq ?medio ?odio)))
         then
            (bind ?ori-slot (send ?t get-tieneOrigen))
            (bind ?des-slot (send ?t get-tieneFin))

            (bind ?lista-ori (if (multifieldp ?ori-slot) then ?ori-slot else (create$ ?ori-slot)))
            (bind ?lista-des (if (multifieldp ?des-slot) then ?des-slot else (create$ ?des-slot)))

            (bind ?ori-ok FALSE)
            (loop-for-count (?j 1 (length$ ?lista-ori)) do
                (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-ori)) ?norm-origen)
                    then (bind ?ori-ok TRUE) (break)))

            (bind ?des-ok FALSE)
            (loop-for-count (?j 1 (length$ ?lista-des)) do
                (if (eq (REFINAMIENTO::normalizar-nombre (nth$ ?j ?lista-des)) ?norm-destino)
                    then (bind ?des-ok TRUE) (break)))

            (if (and ?ori-ok ?des-ok)
                then (return ?t))
        )
    )
    (return FALSE)
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

(deffunction SALIDA::mostrar-itinerario (?diasTotales $?ciudades)
    (bind ?n (length$ ?ciudades))
    (if (= ?n 0) then (return))

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
    (assert (itinerario-por-imprimir 1))
    (printout t crlf "==========================================" crlf)
    (printout t "       TUS ITINERARIOS PERSONALIZADOS" crlf)
    (printout t "==========================================" crlf crlf)
)

(defrule SALIDA::mostrar-viajes-finales
    (declare (salience 90))
    (cabecera-mostrada)

    ?ctrl <- (itinerario-por-imprimir ?rank)
    (viaje-seleccionado (id ?trip) (ranking ?rank))
    ?trip-obj <- (object (is-a ViajeCandidato) (incluyeCiudad $?ciudades))
=>
    (bind ?dias (send ?trip-obj get-durada_dias))

    (printout t crlf "==========================================================" crlf)
    (printout t " ITINERARIO RECOMENDADO OPTIMO #" ?rank crlf)
    (printout t " Puntuacion : " (send ?trip-obj get-puntuacion) " puntos" crlf)
    (printout t " Coste Total: " (integer (send ?trip-obj get-precio_total)) " EUR" crlf)
    (printout t " Duracion   : " ?dias " dias" crlf)
    (printout t "==========================================================" crlf)

    ;; Enviamos los días calculados junto con la lista de ciudades
    (mostrar-itinerario ?dias ?ciudades)

    (retract ?ctrl)
    (assert (itinerario-por-imprimir (+ ?rank 1)))
)

(defrule SALIDA::finalizar-bucle-impresion
    (declare (salience 85))
    (cabecera-mostrada)
    (itinerario-por-imprimir ?rank)
    (not (viaje-seleccionado (ranking ?rank)))
    (not (viaje-mostrado))
=>
    (assert (viaje-mostrado))
)

(defrule SALIDA::mostrar-resumen-final
    (declare (salience 80))
    (viaje-mostrado)
    (not (resumen-mostrado))

    (viaje-seleccionado (id ?trip) (ranking 1))
    ?trip-obj <- (object (is-a ViajeCandidato))
=>
    (printout t crlf "==========================================" crlf)
    (printout t "       RESUMEN DE TU VIAJE DESTACADO" crlf)
    (printout t "==========================================" crlf)
    (printout t "Ciudades   : " (send ?trip-obj get-n_ciudades) crlf)
    (printout t "Duracion   : " (send ?trip-obj get-durada_dias) " dias" crlf)
    (printout t "Coste      : " (integer (send ?trip-obj get-precio_total)) " EUR" crlf)
    (printout t "Puntuacion : " (send ?trip-obj get-puntuacion) crlf)
    (printout t "==========================================" crlf crlf)
    (assert (resumen-mostrado))
)

(defrule SALIDA::sin-solucion
    (declare (salience 70))
    (estado-refinamiento (fase COMPLETADO))
    (cabecera-mostrada)
    (not (viaje-mostrado))
    (not (viaje-seleccionado (ranking 1)))
    (not (resumen-mostrado))
=>
    (printout t "No se ha podido generar un itinerario valido con las restricciones actuales." crlf crlf)
    (assert (resumen-mostrado))
)