;;; Módulo de heurística: puntúa ciudades candidatas según criterios del usuario

(defmodule heuristica
    (import MAIN ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR TEMÁTICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI tematica-ok = SI Y cluster = Mediterranea|Costa ENTONCES ventaja "Destino romantico"
(defrule heuristica::ventaja-romantico-costa
    (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (cluster_tematico ?cl&:(or (eq ?cl "Mediterranea") (eq ?cl "Costa"))))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (grado nil))
=>
    (slot-insert$ ?cand ventajas 1 "Destino romantico")
)

; SI tematica-ok = SI Y cluster = Historica|Artistica ENTONCES ventaja "Gran patrimonio"
(defrule heuristica::ventaja-cultural-historica
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (cluster_tematico ?cl&:(or (eq ?cl "Historica") (eq ?cl "Artistica"))))
=>
    (slot-insert$ ?cand ventajas 1 "Gran patrimonio")
)

; SI tematica-ok = SI Y cluster = Metropolis ENTONCES ventaja "Gran ciudad"
(defrule heuristica::ventaja-metropolis
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (cluster_tematico "Metropolis"))
=>
    (slot-insert$ ?cand ventajas 1 "Gran ciudad")
)

; SI tematica-ok = NO ENTONCES desventaja "Tematica no coincide"
(defrule heuristica::desventaja-tematica-no-encaja
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok NO) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica no coincide")
)

; SI tematica-ok = PARCIAL ENTONCES desventaja "Tematica parcialmente compatible"
(defrule heuristica::desventaja-tematica-parcial
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok PARCIAL) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica parcialmente compatible")
)

; SI tematica-ok = NO ENTONCES desventaja "Tematica no coincide"
(defrule heuristica::desventaja-tematica-no-encaja
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok NO) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica no coincide")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR PRESUPUESTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI presupuesto-ok = SI Y nivel_de_vida < 1.1 ENTONCES ventaja "Ciudad economica"
(defrule heuristica::ventaja-ciudad-economica
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (nivel_de_vida ?ndv&:(< ?ndv 1.1)))
=>
    (slot-insert$ ?cand ventajas 1 "Ciudad economica")
)

; SI presupuesto-ok = NO ENTONCES desventaja "Cara para el presupuesto"
(defrule heuristica::desventaja-precio-alto
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto-ok NO) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Cara para el presupuesto")
)

; SI presupuesto-ok = PARCIAL ENTONCES desventaja "Precio ajustado"
(defrule heuristica::desventaja-precio-ajustado
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto-ok PARCIAL) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Precio ajustado")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR OFERTA TURÍSTICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI ciudad tiene >= 3 POI ENTONCES ventaja "Gran oferta turistica"
(defrule heuristica::ventaja-gran-oferta-turistica
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (grado nil))
    (object (name ?c) (tienePOI $?pois&:(>= (length$ ?pois) 3)))
=>
    (slot-insert$ ?cand ventajas 1 "Gran oferta turistica")
)

; SI ciudad tiene Museo Y tematica-ok = SI ENTONCES ventaja "Rica oferta cultural"
(defrule heuristica::ventaja-museo
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a Museo))
=>
    (slot-insert$ ?cand ventajas 1 "Rica oferta cultural")
)

; SI ciudad tiene Parque ENTONCES ventaja "Espacios naturales"
(defrule heuristica::ventaja-parque
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a Parque))
=>
    (slot-insert$ ?cand ventajas 1 "Espacios naturales")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR ALOJAMIENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI presupuesto-ok = SI Y ciudad tiene Hotel ENTONCES ventaja "Hotel de calidad disponible"
(defrule heuristica::ventaja-hotel-disponible
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Hotel))
=>
    (slot-insert$ ?cand ventajas 1 "Hotel de calidad disponible")
)

; SI presupuesto-ok = SI|PARCIAL Y ciudad tiene Hostal ENTONCES ventaja "Alojamiento economico"
(defrule heuristica::ventaja-hostal
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok ?pok&:(or (eq ?pok SI) (eq ?pok PARCIAL)))
                     (ciudad ?c) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Hostal))
=>
    (slot-insert$ ?cand ventajas 1 "Alojamiento economico disponible")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR CLIMA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI clima = Calido Y tematica-ok = SI ENTONCES ventaja "Clima ideal"
(defrule heuristica::ventaja-clima-calido
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (clima_habitual "Calido"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima ideal")
)

; SI clima = Templado ENTONCES ventaja "Clima agradable"
(defrule heuristica::ventaja-clima-templado
    ?cand <- (object (is-a CandidatoCiudad) (tematica-ok SI) (ciudad ?c) (grado nil))
    (object (name ?c) (clima_habitual "Templado"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima agradable")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS/DESVENTAJAS POR TRANSPORTE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI transporte-ok = SI ENTONCES ventaja "Transporte conveniente"
(defrule heuristica::ventaja-transporte-ok
    ?cand <- (object (is-a CandidatoCiudad) (transporte-ok SI) (grado nil))
=>
    (slot-insert$ ?cand ventajas 1 "Transporte conveniente")
)

; SI transporte-ok = NO ENTONCES desventaja "Requiere transporte no deseado"
(defrule heuristica::desventaja-transporte-no-ok
    ?cand <- (object (is-a CandidatoCiudad) (transporte-ok NO) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Requiere transporte no deseado")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR ACCESIBILIDAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI accesibilidad-ok = NO ENTONCES desventaja "Problemas de accesibilidad"
(defrule heuristica::desventaja-accesibilidad
    ?cand <- (object (is-a CandidatoCiudad) (accesibilidad-ok NO) (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Problemas de accesibilidad")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CLASIFICACIÓN DE CANDIDATOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI tematica-ok = SI Y presupuesto-ok = SI Y tiene ventajas ENTONCES MUY_RECOMENDABLE
(defrule heuristica::clasificar-muy-recomendable
    (declare (salience -1))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok SI|PARCIAL)
                     (ventajas $?v&:(> (length$ ?v) 0))
                     (grado nil))
=>
    (send ?cand put-grado MUY_RECOMENDABLE)
    (send ?cand put-motivo "Cumple todos los criterios con ventajas")
)

; SI tematica-ok = SI Y presupuesto-ok = SI ENTONCES ADECUADO
(defrule heuristica::clasificar-adecuado
    (declare (salience -2))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok SI|PARCIAL)
                     (grado nil))
=>
    (send ?cand put-grado ADECUADO)
    (send ?cand put-motivo "Cumple los criterios principales")
)

; SI presupuesto-ok = PARCIAL Y tematica-ok = SI ENTONCES PARCIALMENTE_ADECUADO
(defrule heuristica::clasificar-parcial-presupuesto
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok PARCIAL)
                     (accesibilidad-ok SI|PARCIAL)
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Presupuesto algo ajustado")
    (slot-insert$ ?cand desventajas 1 "Presupuesto ajustado")
)

; SI tematica-ok = PARCIAL ENTONCES PARCIALMENTE_ADECUADO
(defrule heuristica::clasificar-parcial-tematica
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok PARCIAL)
                     (presupuesto-ok SI|PARCIAL)
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Tematica parcialmente compatible")
)

; SI transporte-ok = NO ENTONCES PARCIALMENTE_ADECUADO
(defrule heuristica::clasificar-parcial-transporte
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI|PARCIAL)
                     (presupuesto-ok SI|PARCIAL)
                     (transporte-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Transporte no conveniente")
)

; SI accesibilidad-ok = NO ENTONCES NO_RECOMENDABLE
(defrule heuristica::clasificar-no-recomendable-accesibilidad
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad) (accesibilidad-ok NO) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "Sin accesibilidad adecuada")
    (slot-insert$ ?cand desventajas 1 "Sin accesibilidad")
)

; SI presupuesto-ok = NO ENTONCES NO_RECOMENDABLE
(defrule heuristica::clasificar-no-recomendable-presupuesto
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto-ok NO) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "Excede el presupuesto")
    (slot-insert$ ?cand desventajas 1 "Precio excesivo")
)

; SI tematica-ok = NO Y presupuesto-ok = NO ENTONCES NO_RECOMENDABLE
(defrule heuristica::clasificar-no-recomendable-total
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok NO)
                     (presupuesto-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "No encaja con el perfil")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TRANSICIÓN AL SIGUIENTE MÓDULO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SI heuristica completa ENTONCES pasar a refinamiento
(defrule heuristica::pasar-a-refinamiento
    (declare (salience -10))
=>
    (printout t crlf "--- Heuristica completada ---" crlf)
    (do-for-all-instances ((?cand CandidatoCiudad)) TRUE
        (bind ?c (send ?cand get-ciudad))
        (printout t "  " (nth$ 1 (send ?c get-nombre))
                  " -> " (send ?cand get-grado)
                  " | " (send ?cand get-motivo) crlf)
        (printout t "     Ventajas:    " (send ?cand get-ventajas) crlf)
        (printout t "     Desventajas: " (send ?cand get-desventajas) crlf)
    )
    (printout t crlf)
    (focus refinamiento)
)