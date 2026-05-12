(defmodule SALIDA
    (import MAIN ?ALL)
    (import REFINAMIENTO ?ALL)
    (export ?ALL)
)

;;; ========================================
;;; GENERACIÓN DEL VIAJE PERSONALIZADO
;;; ========================================

;; Plantilla para controlar las ciudades seleccionadas
(deftemplate SALIDA::ciudad-seleccionada
    (slot ciudad (type INSTANCE))
    (slot alojamiento (type INSTANCE))
    (slot posicion (type INTEGER))
)

;; Regla 1: Mostrar cabecera
(defrule SALIDA::mostrar-cabecera
    (declare (salience 100))
    (not (cabecera-mostrada))
=>
    (assert (cabecera-mostrada TRUE))
    (printout t crlf "==========================================" crlf)
    (printout t "       TU ITINERARIO PERSONALIZADO" crlf)
    (printout t "==========================================" crlf crlf)
)

;; Regla 2: Seleccionar ciudades válidas (sin restricciones violadas)
;; Preferencia: MUY_RECOMENDABLE > ADECUADO > PARCIALMENTE_ADECUADO
(defrule SALIDA::seleccionar-ciudades-muy-recomendable
    (declare (salience 90))
    ?cand <- (object (is-a CandidatoCiudad) 
                     (ciudad ?ciu) 
                     (grado MUY_RECOMENDABLE))
    (not (ciudad-seleccionada (ciudad ?ciu)))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (< (length$ (find-all-facts ((?f ciudad-seleccionada)) TRUE)) 
              (nth$ 1 (send ?u get-ciudades_max))))
=>
    (bind ?aloList (send ?ciu get-tieneAlojamiento))
    (bind ?alojamiento (if (> (length$ ?aloList) 0) 
                           then (nth$ 1 ?aloList)
                           else nil))
    (bind ?pos (+ 1 (length$ (find-all-facts ((?f ciudad-seleccionada)) TRUE))))
    (assert (ciudad-seleccionada 
             (ciudad ?ciu) 
             (alojamiento ?alojamiento)
             (posicion ?pos)))
)

;; Regla 3: Seleccionar ciudades ADECUADO si no hay MUY_RECOMENDABLE
(defrule SALIDA::seleccionar-ciudades-adecuado
    (declare (salience 85))
    ?cand <- (object (is-a CandidatoCiudad) 
                     (ciudad ?ciu) 
                     (grado ADECUADO))
    (not (ciudad-seleccionada (ciudad ?ciu)))
    ?u <- (object (is-a Usuario) (name [usuario1]))
    (test (< (length$ (find-all-facts ((?f ciudad-seleccionada)) TRUE)) 
              (nth$ 1 (send ?u get-ciudades_max))))
=>
    (bind ?aloList (send ?ciu get-tieneAlojamiento))
    (bind ?alojamiento (if (> (length$ ?aloList) 0) 
                           then (nth$ 1 ?aloList)
                           else nil))
    (bind ?pos (+ 1 (length$ (find-all-facts ((?f ciudad-seleccionada)) TRUE))))
    (assert (ciudad-seleccionada 
             (ciudad ?ciu) 
             (alojamiento ?alojamiento)
             (posicion ?pos)))
)

;; Regla 4: Mostrar el itinerario generado
(defrule SALIDA::mostrar-itinerario
    (declare (salience 50))
    ?cs <- (ciudad-seleccionada (ciudad ?ciu) 
                                (alojamiento ?alo)
                                (posicion ?pos))
    (not (mostrada ?ciu))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (bind ?nomCiudad (nth$ 1 (send ?ciu get-nombre)))
    (bind ?nomAlojamiento (if (and ?alo (neq ?alo nil)) 
                              then (nth$ 1 (send ?alo get-nombre))
                              else "No disponible"))
    
    ;; Obtener transporte
    (bind ?transporte (send ?ciu get-tipo_transporte)) 

    (printout t "PARADA " ?pos ": " ?nomCiudad crlf)
    (printout t "  * HOTEL: " ?nomAlojamiento crlf)
    (printout t "  * TRANSPORTE RECOMENDADO: " ?transporte crlf)
    
    ;; Mostrar puntos de interés si existen
    (bind ?poisList (send ?ciu get-tienePOI))
    (if (> (length$ ?poisList) 0)
        then
        (printout t "  * LUGARES: " (nth$ 1 ?poisList) crlf))
    (printout t "------------------------------------------" crlf)
    
    (assert (mostrada ?ciu))
)

;; Regla 5: Mostrar resumen final
(defrule SALIDA::mostrar-resumen-final
    (declare (salience -100))
    (cabecera-mostrada)
    (not (resumen-mostrado))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (bind ?numCiudades (length$ (find-all-facts ((?f ciudad-seleccionada)) TRUE)))
    (bind ?diasMin (nth$ 1 (send ?u get-dias_min)))
    (bind ?diasMax (nth$ 1 (send ?u get-dias_max)))
    (bind ?presupuestoMax (nth$ 1 (send ?u get-presupuesto_max)))
    
    (printout t crlf "==========================================" crlf)
    (printout t "           RESUMEN DE TU VIAJE" crlf)
    (printout t "==========================================" crlf)
    (printout t "Ciudades:        " ?numCiudades crlf)
    (printout t "Duración:        " ?diasMin "-" ?diasMax " días" crlf)
    (printout t "Presupuesto max: " ?presupuestoMax "€" crlf)
    (printout t "==========================================" crlf crlf)
    
    (assert (resumen-mostrado TRUE))
)