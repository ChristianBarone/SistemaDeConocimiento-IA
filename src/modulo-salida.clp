(defmodule SALIDA
    (import MAIN ?ALL)
    (import HEURISTICA ?ALL)
    (import REFINAMIENTO deftemplate estado-refinamiento)
    (import REFINAMIENTO deftemplate viaje-seleccionado)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCIONES DE PRESENTACION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction SALIDA::mostrar-pois-ciudad (?ciu)
   (bind ?pois (send ?ciu get-tienePOI))

   (if (= (length$ ?pois) 0)
      then
         (printout t "    POI: No hay puntos de interes registrados." crlf)
      else
         (loop-for-count (?i 1 (length$ ?pois))
            do
            (bind ?poi (nth$ ?i ?pois))
            (printout t "    POI: " ?poi crlf)))
)

(deffunction SALIDA::mostrar-parada (?ciu ?dias)
   (if (not (instance-existp ?ciu))
      then
         (printout t "  - Error: instancia de ciudad invalida o no encontrada." crlf)
         (return))

   (printout t "  - Ciudad: " (send ?ciu get-nombre) " (" ?dias " dias)" crlf)

   (bind ?aloj (REFINAMIENTO::mejor-alojamiento ?ciu))
   (if (neq ?aloj FALSE)
      then
         (bind ?praw (send ?aloj get-precio_noche))
         (bind ?precio (if (numberp ?praw) then (float ?praw) else 0.0))
         (printout t "    Alojamiento recomendado: "
                     (send ?aloj get-nombre)
                     " (" ?precio " EUR/noche)" crlf)
      else
         (printout t "    Alojamiento recomendado: No hay alojamientos disponibles registrados." crlf))

   (SALIDA::mostrar-pois-ciudad ?ciu)
)

(deffunction SALIDA::mostrar-trayecto (?ciuOri ?ciuDest ?odio)
    (bind ?t (REFINAMIENTO::buscar-transporte-entre ?ciuOri ?ciuDest))

    (if (neq ?t FALSE)
        then
            (printout t "  >> "
                        (send ?t get-tipo)
                        " | "
                        (send ?t get-duracion_horas)
                        "h | "
                        (integer (send ?t get-precio))
                        " EUR"
                        crlf)
        else
            (printout t "  >> (Sin transporte directo disponible)" crlf))
)

(deffunction SALIDA::mostrar-itinerario (?diasTotales ?ciudades)
   (bind ?n (length$ ?ciudades))
   (if (= ?n 0) then (return))

   (printout t crlf "ITINERARIO PROPUESTO" crlf)
   (loop-for-count (?i 1 ?n)
      do
      (bind ?ciu (nth$ ?i ?ciudades))
      (bind ?diasParada (REFINAMIENTO::dias-en-parada ?diasTotales ?n ?i))
      (SALIDA::mostrar-parada ?ciu ?diasParada)
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