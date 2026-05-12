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

;; Regla 3: Seleccionar ciudades con menor grado (Adecuado o Parcial)
(defrule SALIDA::seleccionar-ciudades-restantes
    (declare (salience 85))
    ?cand <- (object (is-a CandidatoCiudad) 
                     (ciudad ?ciu) 
                     (grado ADECUADO|PARCIALMENTE_ADECUADO))
    (not (ciudad-seleccionada (ciudad ?ciu)))
=>
    ;; Extraemos la lista de hoteles de la ciudad (slot tieneAlojamiento)
    (bind ?lista-hoteles (send ?ciu get-tieneAlojamiento))
    
    ;; Seleccionamos el primer hotel de la lista si existe
    (bind ?hotel-elegido [ninguno])
    (if (> (length$ ?lista-hoteles) 0) 
        then (bind ?hotel-elegido (nth$ 1 ?lista-hoteles)))

    (assert (ciudad-seleccionada 
                (ciudad ?ciu) 
                (alojamiento ?hotel-elegido)
                (posicion 1))) ;; El orden se puede ajustar después
)

;; Regla 4: Mostrar detalle de la parada
(defrule SALIDA::mostrar-parada
    (declare (salience 80))
    ?f <- (ciudad-seleccionada (ciudad ?ciu) (alojamiento ?aloj) (posicion ?pos))
    (not (mostrada ?ciu))
    
    ;; Obtenemos los datos de la instancia Ciudad
    ?obj-ciu <- (object (is-a Ciudad) (name ?ciu) (nombre ?nomCiudad))
    
    ;; Obtenemos los datos de la instancia Usuario para el transporte
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    ;; 1. Obtener nombre del Hotel
    (bind ?nombreHotel "Sin hotel asignado")
    (if (neq ?aloj [ninguno])
        then (bind ?nombreHotel (nth$ 1 (send ?aloj get-nombre))))
    
    ;; 2. Lógica de Transporte (Simplificada: si no odia el avión, recomienda avión)
    (bind ?odio (send ?u get-transporte_odiado))
    (bind ?transporte "Tren")
    (if (neq ?odio "Avion") then (bind ?transporte "Avion"))

    ;; 3. Impresión por pantalla
    (printout t "PARADA " ?pos ": " ?nomCiudad crlf)
    (printout t "  * HOTEL: " ?nombreHotel crlf)
    (printout t "  * TRANSPORTE RECOMENDADO: " ?transporte crlf)
    
    ;; 4. Mostrar Puntos de Interés (POI)
    (bind ?pois (send ?obj-ciu get-tienePOI))
    (if (> (length$ ?pois) 0) then
        (printout t "  * VISITAS RECOMENDADAS: ")
        (foreach ?p ?pois (printout t (instance-name ?p) " "))
        (printout t crlf))
        
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