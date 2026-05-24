;;; Módulo de heurística: evalúa y clasifica ciudades candidatas
;;; LÓGICA: Primero filtrar por RESTRICCIONES (obligatorias)
;;;         Luego ordenar por PREFERENCIAS (opcionales)

(defmodule HEURISTICA
    (import MAIN ?ALL)
    (import ABSTRACCION ?ALL)
    (import PREGUNTAS ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. CREAR CANDIDATOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::crear-candidatos-ciudad
    (declare (salience 10))
    (entrada-completada)
    (object (is-a Ciudad) (name ?n))
=>
    (make-instance (sym-cat "Cand-" ?n) of CandidatoCiudad (ciudad ?n))
)

(defrule HEURISTICA::crear-candidatos-alojamiento
    (declare (salience 10))
    (entrada-completada)
    (object (is-a Alojamiento) (name ?n))
=>
    (make-instance (sym-cat "Cand-" ?n) of AlojamientoCandidato (alojamiento ?n))
)

(defrule HEURISTICA::crear-candidatos-transporte
    (declare (salience 10))
    (entrada-completada)
    (object (is-a Transporte) (name ?n))
=>
    (make-instance (sym-cat "Cand-" ?n) of TransporteCandidato (transporte ?n))
)

(defrule HEURISTICA::crear-candidatos-puntointeres
    (declare (salience 10))
    (entrada-completada)
    (object (is-a PuntoDeInteres) (name ?n))
=>
    (make-instance (sym-cat "Cand-" ?n) of PuntoDeInteresCandidato (puntodeinteres ?n))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. EVALUAR RESTRICCIONES (OBLIGATORIAS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::restriccion-transporte-odiado
    (declare (salience 10))
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_odiado ?transp))
    ?cand <- (object (is-a TransporteCandidato) (transporte ?transp))
=>
    (bind ?ok SI)
    (send ?cand put-odiado ?ok)
)

;; Ara mateix no considerem que una ciutat no sigui plenament accessible (perquè ho creiem. Implementable si eso)
; (defrule HEURISTICA::restriccion-accesibilidad-ciudad
;     (declare (salience 5))
;     ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
;     ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
;     (object (is-a Ciudad) (name ?ciu) (accesible ?nivel))
; =>
;     (bind ?ok SI)
;     (if (and (eq ?mov TRUE) (eq ?nivel PARCIAL)) then (bind ?ok PARCIAL))
;     (send ?cand put-accesibilidad_ok ?ok)
; )

(defrule HEURISTICA::restriccion-accesibilidad-alojamiento
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?aloj))
    (object (is-a Alojamiento) (name ?aloj) (accesible ?nivel))
=>
    (bind ?ok SI)
    (if (and (eq ?mov TRUE) (eq ?nivel NO)) then (bind ?ok NO))
    (send ?cand put-accesibilidad_ok ?ok)
)

(defrule HEURISTICA::restriccion-accesibilidad-transporte
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a TransporteCandidato) (transporte ?trans) (odiado NO))
    (object (is-a Transporte) (tipo ?trans) (accesible ?nivel))
=>
    (bind ?ok SI)
    (if (and (eq ?mov TRUE) (eq ?nivel NO)) then (bind ?ok NO))
    (send ?cand put-accesibilidad_ok ?ok)
)

(defrule HEURISTICA::restriccion-accesibilidad-puntodeinteres
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a PuntoDeInteresCandidato) (puntodeinteres ?pi))
    (object (is-a PuntoDeInteres) (name ?pi) (accesible ?nivel))
=>
    (bind ?ok SI)
    (if (and (eq ?mov TRUE) (eq ?nivel NO)) then (bind ?ok NO)
     else (if (and (eq ?mov TRUE) (eq ?nivel PARCIAL)) then (bind ?ok PARCIAL)))
    (send ?cand put-accesibilidad_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-ciudad
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (is-a Ciudad) (name ?ciu) (nivel_de_vida ?nv))
=>
    (bind ?ok NO)
    (if (eq ?nivel LUJO) then (bind ?ok SI)
     else (if (and (eq ?nivel MUY_RECOMENDABLE) (<= ?nv 2.0)) then (bind ?ok SI)
     else (if (and (eq ?nivel MUY_RECOMENDABLE) (<= ?nv 2.3)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel MEDIO) (<= ?nv 1.5)) then (bind ?ok SI)
     else (if (and (eq ?nivel MEDIO) (<= ?nv 1.8)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel BAJO) (<= ?nv 1.0)) then (bind ?ok SI)
     else (if (and (eq ?nivel BAJO) (<= ?nv 1.3)) then (bind ?ok PARCIAL))))))))
    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-alojamiento
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?aloj))
    (object (is-a Alojamiento) (name ?aloj) (precio_noche ?precio))
=>
    (bind ?ok NO)
    (if (and (eq ?nivel LUJO) (>= ?precio 350)) then (bind ?ok SI)
     else (if (and (eq ?nivel LUJO) (>= ?precio 250)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel ALTO) (>= ?precio 80) (<= ?precio 320)) then (bind ?ok SI)
     else (if (and (eq ?nivel ALTO) (>= ?precio 65) (<= ?precio 350)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel MEDIO) (>= ?precio 30) (<= ?precio 90)) then (bind ?ok SI)
     else (if (and (eq ?nivel MEDIO) (>= ?precio 15) (<= ?precio 100)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel BAJO) (<= ?precio 35)) then (bind ?ok SI)
     else (if (and (eq ?nivel BAJO) (<= ?precio 50)) then (bind ?ok PARCIAL)))))))))
    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-transporte
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a TransporteCandidato) (transporte ?trans) (odiado NO))
    (object (is-a Transporte) (tipo ?trans) (precio ?precio))
=>
    (bind ?ok NO)
    (if (and (eq ?nivel LUJO) (>= ?precio 300)) then (bind ?ok SI)
     else (if (and (eq ?nivel LUJO) (>= ?precio 200)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel ALTO) (>= ?precio 80) (<= ?precio 320)) then (bind ?ok SI)
     else (if (and (eq ?nivel ALTO) (>= ?precio 65) (<= ?precio 350)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel MEDIO) (>= ?precio 30) (<= ?precio 90)) then (bind ?ok SI)
     else (if (and (eq ?nivel MEDIO) (>= ?precio 15) (<= ?precio 100)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel BAJO) (<= ?precio 35)) then (bind ?ok SI)
     else (if (and (eq ?nivel BAJO) (<= ?precio 50)) then (bind ?ok PARCIAL)))))))))
    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-puntodeinteres
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a PuntoDeInteresCandidato) (puntodeinteres ?punto))
    (object (is-a PuntoDeInteres) (name ?punto) (precio_PI ?precio))
=>
    (bind ?ok NO)
    (if (eq ?nivel LUJO) then (bind ?ok SI)
     else (if (and (eq ?nivel ALTO) (<= ?precio 150)) then (bind ?ok SI)
     else (if (and (eq ?nivel ALTO) (<= ?precio 200)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel MEDIO) (<= ?precio 70)) then (bind ?ok SI)
     else (if (and (eq ?nivel MEDIO) (<= ?precio 80)) then (bind ?ok PARCIAL)
     else (if (and (eq ?nivel BAJO) (<= ?precio 30)) then (bind ?ok SI)
     else (if (and (eq ?nivel BAJO) (<= ?precio 40)) then (bind ?ok PARCIAL))))))))
    (send ?cand put-presupuesto_ok ?ok)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. EVALUAR PREFERENCIAS (OPCIONALES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::preferencia-tematica
    (declare (salience 0))
    (tematica-deducida ?t)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (name ?ciu) (cluster_tematico ?cluster))
=>
    ; (if (eq ?t ?cluster) then (send ?cand put-tematica_ok SI)
    ; ;; Incompatibles: {Aventura, descanso}, {Romantico, Familiar}
    ;  else (if (or (and (eq ?t Aventura) (eq ?cluster Descanso)) ((and (eq ?cluster Aventura) (eq ?t Descanso))))
    ;       then (send ?cand put-tematica_ok NO)
    ;  else (if (or (and (eq ?t Romantico) (eq ?cluster Familiar)) ((and (eq ?cluster Romatico) (eq ?t Familiar))))
    ;       then (send ?cand put-tematica_ok NO)
    ;  else (send ?cand put-tematica_ok PARCIAL))))
)


;;; INCOMPATIBILIDADES TEMÁTICAS

;;; Usuario busca Descanso → ciudad de Aventura es incompatible
(defrule HEURISTICA::incompatibilidad-descanso-aventura
    (declare (salience 1))
    (tematica-deducida Descanso)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (desventajas $?d) (grado nil))
    (object (name ?ciu) (cluster_tematico Aventura))
    (test (eq (member$ "Incompatible: ciudad de aventura/riesgo" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Incompatible: ciudad de aventura/riesgo")
    (send ?cand put-tematica_ok NO)
    (send ?cand put-incompatibilidad_especifica SI)  ; ← flag
)

;;; Usuario busca Familiar → ciudad Romántica no es apta para niños
(defrule HEURISTICA::incompatibilidad-familiar-romantico
    (declare (salience 1))
    (tematica-deducida Familiar)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (desventajas $?d) (grado nil))
    (object (name ?ciu) (cluster_tematico Romantico))
    (test (eq (member$ "Incompatible: ciudad orientada a parejas" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Incompatible: ciudad orientada a parejas")
    (send ?cand put-tematica_ok NO)
    (send ?cand put-incompatibilidad_especifica SI)  ; ← flag
)

;;; Usuario busca Cultural → ciudad de Descanso tiene poca oferta cultural
(defrule HEURISTICA::incompatibilidad-cultural-descanso
    (declare (salience 1))
    (tematica-deducida Cultural)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (desventajas $?d) (grado nil))
    (object (name ?ciu) (cluster_tematico Descanso))
    (test (eq (member$ "Oferta cultural limitada" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Oferta cultural limitada")
    (send ?cand put-tematica_ok NO)
    (send ?cand put-incompatibilidad_especifica SI)  ; ← flag
)

;;; Usuario busca Romantico → ciudad de Aventura no encaja con ambiente romántico
(defrule HEURISTICA::incompatibilidad-romantico-aventura
    (declare (salience 1))
    (tematica-deducida Romantico)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (desventajas $?d) (grado nil))
    (object (name ?ciu) (cluster_tematico Aventura))
    (test (eq (member$ "Ambiente poco romantico" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Ambiente poco romantico")
    (send ?cand put-tematica_ok NO)
    (send ?cand put-incompatibilidad_especifica SI)  ; ← flag
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. AÑADIR VENTAJAS Y DESVENTAJAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::ventaja-tematica-perfecta
    ?cand <- (object (is-a CandidatoCiudad) (tematica_ok SI) (ventajas $?v) (grado nil))
    (test (eq (member$ "Tematica perfecta" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Tematica perfecta")
)

;; TODO: millorar clima
; (defrule HEURISTICA::ventaja-clima-calido
;     ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
;     (object (name ?c) (clima_habitual "Calido"))
;     (test (eq (member$ "Clima ideal" ?v) FALSE))
; =>
;     (slot-insert$ ?cand ventajas 1 "Clima ideal")
; )

; (defrule HEURISTICA::ventaja-clima-templado
;     ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
;     (object (name ?c) (clima_habitual "Templado"))
;     (test (eq (member$ "Clima agradable" ?v) FALSE))
; =>
;     (slot-insert$ ?cand ventajas 1 "Clima agradable")
; )

(defrule HEURISTICA::ventaja-ciudad-economica
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (nivel_de_vida ?ndv&:(< ?ndv 1.1)))
    (test (eq (member$ "Ciudad economica" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Ciudad economica")
)

(defrule HEURISTICA::ventaja-oferta-turistica
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tienePOI $?pois&:(>= (length$ ?pois) 3)))
    (test (eq (member$ "Gran oferta turistica" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Gran oferta turistica")
)

(defrule HEURISTICA::ventaja-museos
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a PuntoDeInteres) (tipo MUSEO))
    (test (eq (member$ "Rica oferta cultural" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Rica oferta cultural")
)

(defrule HEURISTICA::ventaja-parques
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a PuntoDeInteres) (tipo PARQUE))
    (test (eq (member$ "Espacios naturales" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Espacios naturales")
)

;; Pot ser q no funcioni be la restriccio de Estrelles
(defrule HEURISTICA::ventaja-hotel
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Alojamiento) (calidad ?cat&:(or (eq ?cat "5 Estrellas") (eq ?cat "4 Estrellas")))
            (categoria HOTEL))
    (test (eq (member$ "Hotel de calidad disponible" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Hotel de calidad disponible")
)

(defrule HEURISTICA::ventaja-alojamiento-economico
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (precio_noche ?precio&:(<= ?precio 50)))
    (test (eq (member$ "Alojamiento economico disponible" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Alojamiento economico disponible")
)

(defrule HEURISTICA::ventaja-transporte-ok
    ?cand <- (object (is-a TransporteCandidato) (accesibilidad_ok SI) (odiado NO) (ventajas $?v))
    (test (eq (member$ "Transporte conveniente" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Transporte conveniente")
)

(defrule HEURISTICA::desventaja-tematica-no-encaja
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica_ok NO)
                     (incompatibilidad_especifica NO) 
                     (desventajas $?d)
                     (grado nil))
    (test (eq (member$ "Tematica no coincide" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica no coincide")
)

(defrule HEURISTICA::desventaja-tematica-parcial
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica_ok PARCIAL)
                     (incompatibilidad_especifica NO) 
                     (desventajas $?d)
                     (grado nil))
    (test (eq (member$ "Tematica parcialmente compatible" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica parcialmente compatible")
)

(defrule HEURISTICA::desventaja-precio-alto
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto_ok NO) (desventajas $?d) (grado nil))
    (test (eq (member$ "Cara para el presupuesto" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Cara para el presupuesto")
)

(defrule HEURISTICA::desventaja-precio-ajustado
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto_ok PARCIAL) (desventajas $?d) (grado nil))
    (test (eq (member$ "Precio ajustado" ?d) FALSE))
=>
    (slot-insert$ ?cand desventajas 1 "Precio ajustado")
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. CLASIFICACIÓN FINAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::bloquear-presupuesto-ciudad
    (declare (salience 0))
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Excede presupuesto maximo")
    (if (eq (member$ "RESTRICCIÓN: Precio excesivo" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Precio excesivo"))
)

(defrule HEURISTICA::bloquear-presupuesto-Alojamiento
    (declare (salience 0))
    ?cand <- (object (is-a AlojamientoCandidato) (presupuesto_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Excede presupuesto maximo")
    (if (eq (member$ "RESTRICCIÓN: Precio excesivo" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Precio excesivo"))
)

(defrule HEURISTICA::bloquear-presupuesto-Transporte
    (declare (salience 0))
    ?cand <- (object (is-a TransporteCandidato) (presupuesto_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Excede presupuesto maximo")
    (if (eq (member$ "RESTRICCIÓN: Precio excesivo" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Precio excesivo"))
)

(defrule HEURISTICA::bloquear-presupuesto-PuntoDeInteres
    (declare (salience 0))
    ?cand <- (object (is-a PuntoDeInteresCandidato) (presupuesto_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Excede presupuesto maximo")
    (if (eq (member$ "RESTRICCIÓN: Precio excesivo" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Precio excesivo"))
)

(defrule HEURISTICA::bloquear-accesibilidad-Transporte
    (declare (salience 0))
    ?cand <- (object (is-a TransporteCandidato) (accesibilidad_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Sin accesibilidad adecuada")
    (if (eq (member$ "RESTRICCIÓN: Sin accesibilidad" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Sin accesibilidad"))
)

(defrule HEURISTICA::bloquear-accesibilidad-Alojamiento
    (declare (salience 0))
    ?cand <- (object (is-a AlojamientoCandidato) (accesibilidad_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Sin accesibilidad adecuada")
    (if (eq (member$ "RESTRICCIÓN: Sin accesibilidad" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Sin accesibilidad"))
)

(defrule HEURISTICA::bloquear-accesibilidad-PuntoDeInteres
    (declare (salience 0))
    ?cand <- (object (is-a PuntoDeInteresCandidato) (accesibilidad_ok NO) (desventajas $?d) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    ;(send ?cand put-motivo "RESTRICCIÓN: Sin accesibilidad adecuada")
    (if (eq (member$ "RESTRICCIÓN: Sin accesibilidad" ?d) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Sin accesibilidad"))
)

(defrule HEURISTICA::bloquear-transporte-odiado
    (declare (salience 0))
    ?cand <- (object (is-a TransporteCandidato) (odiado SI) (desventajas $?v))
=>
    ;(send ?cand put-motivo "RESTRICCIÓN: Requiere transporte odiado")
    (if (eq (member$ "RESTRICCIÓN: Transporte odiado" ?v) FALSE) then
        (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Transporte odiado"))
)

(defrule HEURISTICA::clasificar-muy-recomendable
    (declare (salience -1))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto_ok SI)
                     ;; (transporte_ok SI)
                     ;(accesibilidad_ok SI)
                     (tematica_ok SI)
                     (ventajas $?v&:(> (length$ ?v) 0))
                     (grado nil))
=>
    (send ?cand put-grado MUY_RECOMENDABLE)
    (send ?cand put-motivo "Cumple todas restricciones y preferencias optimas")
)

(defrule HEURISTICA::clasificar-adecuado
    (declare (salience -2))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto_ok SI)
                     ; (transporte_ok SI)
                     ;(accesibilidad_ok SI)
                     (grado nil))
=>
    (send ?cand put-grado ADECUADO)
    (send ?cand put-motivo "Cumple todas restricciones")
)

(defrule HEURISTICA::clasificar-poco-recomendable-presupuesto
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad) (presupuesto_ok PARCIAL) (grado nil))
=>
    (send ?cand put-grado POCO_ADECUADO)
    (send ?cand put-motivo "Presupuesto algo ajustado")
)

(defrule HEURISTICA::clasificar-poco-recomendable-tematica
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad) (tematica_ok PARCIAL) (grado nil))
=>
    (send ?cand put-grado POCO_ADECUADO)
    (send ?cand put-motivo "Tematica parcialmente compatible")
)

(defrule HEURISTICA::clasificar-no-recomendable-total
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad) (tematica_ok NO) (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "No encaja con el perfil tematico")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TRANSICIÓN AL SIGUIENTE MÓDULO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::pasar-a-refinamiento
    (declare (salience -10))
=>
    (printout t crlf "--- Heuristica completada ---" crlf)
    (do-for-all-instances ((?cand CandidatoCiudad)) TRUE
        (bind ?c (send ?cand get-ciudad))
        (printout t "  " (send ?c get-nombre) " -> " (send ?cand get-grado) crlf)
        (printout t "     Motivo: " (send ?cand get-motivo) crlf)
        (printout t "     Ventajas:    " (send ?cand get-ventajas) crlf)
        (printout t "     Desventajas: " (send ?cand get-desventajas) crlf crlf)
    )
    (focus REFINAMIENTO)
)
