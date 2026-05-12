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

(defrule HEURISTICA::crear-candidatos
    (declare (salience 10))
    (entrada-completada)
    (object (is-a Ciudad) (name ?n))
=>
    (make-instance (sym-cat "Cand-" ?n) of CandidatoCiudad (ciudad ?n))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. EVALUAR RESTRICCIONES (OBLIGATORIAS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; RESTRICCIÓN 1: PRESUPUESTO
(defrule HEURISTICA::restriccion-presupuesto
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (name ?ciu) (nivel_de_vida ?nv))
=>
    (bind ?ok NO)
    ;; LUJO: todas las ciudades están bien
    (if (eq ?nivel LUJO) then (bind ?ok SI)
     ;; ALTO: ciudades con nivel_de_vida <= 2.0
     else (if (and (eq ?nivel ALTO) (<= ?nv 2.0)) then (bind ?ok SI)
     ;; MEDIO: ciudades con nivel_de_vida <= 1.5
     else (if (and (eq ?nivel MEDIO) (<= ?nv 1.5)) then (bind ?ok SI)
     ;; BAJO: solo ciudades muy económicas (<= 1.0)
     else (if (and (eq ?nivel BAJO) (<= ?nv 1.0)) then (bind ?ok SI)))))
    
    (send ?cand put-presupuesto-ok ?ok)
)

;;; RESTRICCIÓN 2: TRANSPORTE (no usar medio odiado)
(defrule HEURISTICA::restriccion-transporte
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_odiado ?transp))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
=>
    ;; Si no hay transporte odiado o es "Ninguno", OK
    ;; Si hay, asumimos que hay alternativas (mejor en versión completa)
    (bind ?ok (if (or (eq ?transp "") (eq ?transp "Ninguno")) then SI else SI))
    (send ?cand put-transporte-ok ?ok)
)

;;; RESTRICCIÓN 3: ACCESIBILIDAD (si movilidad_reducida == TRUE, requiere SI)
(defrule HEURISTICA::restriccion-accesibilidad
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
=>
    ;; Si NO hay movilidad reducida, todas las ciudades están OK
    ;; Si hay, necesitamos que sea SI (no PARCIAL)
    (if (eq ?mov FALSE)
        then (send ?cand put-accesibilidad-ok SI)
        else (send ?cand put-accesibilidad-ok PARCIAL))  ;; TODO: verificar accesibilidad real
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. EVALUAR PREFERENCIAS (OPCIONALES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; PREFERENCIA 1: TEMÁTICA
(defrule HEURISTICA::preferencia-tematica
    (tematica-deducida ?t)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (name ?ciu) (cluster_tematico ?cluster))
=>
    (if (eq ?t ?cluster) 
        then (send ?cand put-tematica-ok SI)
        else (send ?cand put-tematica-ok PARCIAL))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. AÑADIR VENTAJAS Y DESVENTAJAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ventaja: Temática encaja perfectamente
(defrule HEURISTICA::ventaja-tematica-perfecta
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (grado nil))
=>
    (slot-insert$ ?cand ventajas 1 "Temática perfecta")
)

; Ventaja: Clima cálido
(defrule HEURISTICA::ventaja-clima-calido
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (clima_habitual "Calido"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima ideal")
)

; Ventaja: Clima templado
(defrule HEURISTICA::ventaja-clima-templado
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (clima_habitual "Templado"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima agradable")
)

; Ventaja: Ciudad económica
(defrule HEURISTICA::ventaja-ciudad-economica
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (nivel_de_vida ?ndv&:(< ?ndv 1.1)))
=>
    (slot-insert$ ?cand ventajas 1 "Ciudad económica")
)

; Ventaja: Amplia oferta turística
(defrule HEURISTICA::ventaja-oferta-turistica
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (tienePOI $?pois&:(>= (length$ ?pois) 3)))
=>
    (slot-insert$ ?cand ventajas 1 "Gran oferta turística")
)

; Ventaja: Tiene museos
(defrule HEURISTICA::ventaja-museos
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a Museo))
=>
    (slot-insert$ ?cand ventajas 1 "Rica oferta cultural")
)

; Ventaja: Tiene parques
(defrule HEURISTICA::ventaja-parques
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (tienePOI $? ?poi $?))
    (object (name ?poi) (is-a Parque))
=>
    (slot-insert$ ?cand ventajas 1 "Espacios naturales")
)

; Ventaja: Hotel de calidad disponible
(defrule HEURISTICA::ventaja-hotel
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Hotel))
=>
    (slot-insert$ ?cand ventajas 1 "Hotel de calidad disponible")
)

; Desventaja: Temática no encaja
(defrule HEURISTICA::desventaja-tematica-no-encaja
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok PARCIAL)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Temática parcialmente compatible")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. CLASIFICACIÓN FINAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; BLOQUEADOR 1: Si presupuesto NO, es NO_RECOMENDABLE (RESTRICCIÓN VIOLADA)
(defrule HEURISTICA::bloquear-presupuesto
    (declare (salience 0))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "RESTRICCIÓN: Excede presupuesto máximo")
    (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Precio excesivo")
)

;;; BLOQUEADOR 2: Si accesibilidad NO (cuando hay movilidad reducida), es NO_RECOMENDABLE
(defrule HEURISTICA::bloquear-accesibilidad
    (declare (salience 0))
    ?cand <- (object (is-a CandidatoCiudad)
                     (accesibilidad-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "RESTRICCIÓN: Sin accesibilidad adecuada")
    (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Sin accesibilidad")
)

;;; BLOQUEADOR 3: Si transporte NO, es NO_RECOMENDABLE
(defrule HEURISTICA::bloquear-transporte
    (declare (salience 0))
    ?cand <- (object (is-a CandidatoCiudad)
                     (transporte-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "RESTRICCIÓN: Requiere transporte prohibido")
    (slot-insert$ ?cand desventajas 1 "RESTRICCIÓN: Transporte prohibido")
)

;;; CLASIFICAR: MUY_RECOMENDABLE (todas restricciones OK + ventajas)
(defrule HEURISTICA::clasificar-muy-recomendable
    (declare (salience -1))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok ?acc&:(or (eq ?acc SI) (eq ?acc PARCIAL)))
                     (tematica-ok SI)
                     (ventajas $?v&:(> (length$ ?v) 0))
                     (grado nil))
=>
    (send ?cand put-grado MUY_RECOMENDABLE)
    (send ?cand put-motivo "Cumple todas restricciones + preferencias óptimas")
)

;;; CLASIFICAR: ADECUADO (todas restricciones OK, preferencias parciales)
(defrule HEURISTICA::clasificar-adecuado
    (declare (salience -2))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok ?acc&:(or (eq ?acc SI) (eq ?acc PARCIAL)))
                     (grado nil))
=>
    (send ?cand put-grado ADECUADO)
    (send ?cand put-motivo "Cumple todas restricciones")
)

;;; TRANSICIÓN AL SIGUIENTE MÓDULO
(defrule HEURISTICA::pasar-a-refinamiento
    (declare (salience -10))
=>
    (printout t crlf "--- Heurística completada ---" crlf)

    (do-for-all-instances ((?cand CandidatoCiudad)) TRUE
        (bind ?c (send ?cand get-ciudad))
        (bind ?nombre (nth$ 1 (send ?c get-nombre)))
        (bind ?grado (send ?cand get-grado))
        (bind ?motivo (send ?cand get-motivo))

        (printout t "  " ?nombre " -> " ?grado crlf)
        (printout t "     Motivo: " ?motivo crlf)
        (printout t "     Ventajas:    " (send ?cand get-ventajas) crlf)
        (printout t "     Desventajas: " (send ?cand get-desventajas) crlf crlf)
    )

    (focus REFINAMIENTO)
)

(defrule HEURISTICA::evaluar-presupuesto-candidato
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (name ?ciu) (nivel_de_vida ?nv))
=>
    (bind ?ok NO)
    (if (eq ?nivel LUJO) then (bind ?ok SI)
     else (if (and (eq ?nivel ALTO) (<= ?nv 2.0)) then (bind ?ok SI)
     else (if (and (eq ?nivel MEDIO) (<= ?nv 1.5)) then (bind ?ok SI)
     else (if (and (eq ?nivel BAJO) (<= ?nv 1.0)) then (bind ?ok SI)))))
    
    (send ?cand put-presupuesto-ok ?ok)
)

(defrule HEURISTICA::evaluar-tematica-candidato
    (tematica-deducida ?t)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (name ?ciu) (cluster_tematico ?cluster))
=>
    (if (eq ?t ?cluster) 
        then (send ?cand put-tematica-ok SI)
        else (send ?cand put-tematica-ok PARCIAL))
)

(defrule HEURISTICA::evaluar-transporte-candidato
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_odiado ?transp))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
=>
    ;; Por ahora, asumimos que el transporte es compatible si no es el odiado
    (if (eq ?transp "Ninguno")
        then (send ?cand put-transporte-ok SI)
        else (send ?cand put-transporte-ok SI))  ;; Asumir que hay alternativas
)

(defrule HEURISTICA::evaluar-accesibilidad-candidato
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
=>
    ;; Por ahora, asumir que todas las ciudades tienen algo de accesibilidad
    ;; Si hay movilidad reducida, marcar como PARCIAL (requiere verificación)
    (if (eq ?mov TRUE)
        then (send ?cand put-accesibilidad-ok PARCIAL)
        else (send ?cand put-accesibilidad-ok SI))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS Y DESVENTAJAS POR TEMÁTICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja a ciudades costeras o mediterráneas compatibles con la temática
(defrule HEURISTICA::ventaja-romantico-costa
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (cluster_tematico ?cl&:(or (eq ?cl "Mediterranea")
                                       (eq ?cl "Costa"))))
=>
    (slot-insert$ ?cand ventajas 1 "Destino romantico")
)

; Añade ventaja cultural a ciudades históricas o artísticas
(defrule HEURISTICA::ventaja-cultural-historica
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (cluster_tematico ?cl&:(or (eq ?cl "Historica")
                                       (eq ?cl "Artistica"))))
=>
    (slot-insert$ ?cand ventajas 1 "Gran patrimonio")
)

; Añade ventaja a grandes ciudades metropolitanas
(defrule HEURISTICA::ventaja-metropolis
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (cluster_tematico "Metropolis"))
=>
    (slot-insert$ ?cand ventajas 1 "Gran ciudad")
)

; Añade desventaja cuando la temática no coincide
(defrule HEURISTICA::desventaja-tematica-no-encaja
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok NO)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica no coincide")
)

; Añade desventaja cuando la temática es parcialmente compatible
(defrule HEURISTICA::desventaja-tematica-parcial
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok PARCIAL)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Tematica parcialmente compatible")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS Y DESVENTAJAS POR PRESUPUESTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja a ciudades económicas
(defrule HEURISTICA::ventaja-ciudad-economica
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (nivel_de_vida ?ndv&:(< ?ndv 1.1)))
=>
    (slot-insert$ ?cand ventajas 1 "Ciudad economica")
)

; Añade desventaja cuando el presupuesto no es suficiente
(defrule HEURISTICA::desventaja-precio-alto
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok NO)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Cara para el presupuesto")
)

; Añade desventaja cuando el presupuesto es ajustado
(defrule HEURISTICA::desventaja-precio-ajustado
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok PARCIAL)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Precio ajustado")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR OFERTA TURÍSTICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja a ciudades con amplia oferta de puntos de interés
(defrule HEURISTICA::ventaja-gran-oferta-turistica
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (tienePOI $?pois&:(>= (length$ ?pois) 3)))
=>
    (slot-insert$ ?cand ventajas 1 "Gran oferta turistica")
)

; Añade ventaja cultural si la ciudad contiene museos
(defrule HEURISTICA::ventaja-museo
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (tienePOI $? ?poi $?))
    (object (name ?poi)
            (is-a Museo))
=>
    (slot-insert$ ?cand ventajas 1 "Rica oferta cultural")
)

; Añade ventaja natural si la ciudad contiene parques
(defrule HEURISTICA::ventaja-parque
    ?cand <- (object (is-a CandidatoCiudad)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (tienePOI $? ?poi $?))
    (object (name ?poi)
            (is-a Parque))
=>
    (slot-insert$ ?cand ventajas 1 "Espacios naturales")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR ALOJAMIENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja cuando existen hoteles compatibles con el presupuesto
(defrule HEURISTICA::ventaja-hotel-disponible
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj)
            (is-a Hotel))
=>
    (slot-insert$ ?cand ventajas 1 "Hotel de calidad disponible")
)

; Añade ventaja cuando existen alojamientos económicos
(defrule HEURISTICA::ventaja-hostal
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok ?pok&:(or (eq ?pok SI)
                                               (eq ?pok PARCIAL)))
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj)
            (is-a Hostal))
=>
    (slot-insert$ ?cand ventajas 1 "Alojamiento economico disponible")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS POR CLIMA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja a ciudades con clima cálido
(defrule HEURISTICA::ventaja-clima-calido
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (clima_habitual "Calido"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima ideal")
)

; Añade ventaja a ciudades con clima templado
(defrule HEURISTICA::ventaja-clima-templado
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (ciudad ?c)
                     (grado nil))
    (object (name ?c)
            (clima_habitual "Templado"))
=>
    (slot-insert$ ?cand ventajas 1 "Clima agradable")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS Y DESVENTAJAS POR TRANSPORTE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade ventaja cuando el transporte es compatible
(defrule HEURISTICA::ventaja-transporte-ok
    ?cand <- (object (is-a CandidatoCiudad)
                     (transporte-ok SI)
                     (grado nil))
=>
    (slot-insert$ ?cand ventajas 1 "Transporte conveniente")
)

; Añade desventaja cuando el transporte no es compatible
(defrule HEURISTICA::desventaja-transporte-no-ok
    ?cand <- (object (is-a CandidatoCiudad)
                     (transporte-ok NO)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Requiere transporte no deseado")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; VENTAJAS Y DESVENTAJAS POR ACCESIBILIDAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Añade desventaja cuando existen problemas de accesibilidad
(defrule HEURISTICA::desventaja-accesibilidad
    ?cand <- (object (is-a CandidatoCiudad)
                     (accesibilidad-ok NO)
                     (grado nil))
=>
    (slot-insert$ ?cand desventajas 1 "Problemas de accesibilidad")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CLASIFICACIÓN DE CANDIDATOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Clasifica como muy recomendable cuando todos los criterios son favorables
(defrule HEURISTICA::clasificar-muy-recomendable
    (declare (salience -1))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok ?acc&:(or (eq ?acc SI)
                                                 (eq ?acc PARCIAL)))
                     (ventajas $?v&:(> (length$ ?v) 0))
                     (grado nil))
=>
    (send ?cand put-grado MUY_RECOMENDABLE)
    (send ?cand put-motivo "Cumple todos los criterios con ventajas")
)

; Clasifica como adecuado cuando cumple los criterios principales
(defrule HEURISTICA::clasificar-adecuado
    (declare (salience -2))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok SI)
                     (transporte-ok SI)
                     (accesibilidad-ok ?acc&:(or (eq ?acc SI)
                                                 (eq ?acc PARCIAL)))
                     (grado nil))
=>
    (send ?cand put-grado ADECUADO)
    (send ?cand put-motivo "Cumple los criterios principales")
)

; Clasifica como parcialmente adecuado cuando el presupuesto es limitado
(defrule HEURISTICA::clasificar-parcial-presupuesto
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok SI)
                     (presupuesto-ok PARCIAL)
                     (accesibilidad-ok ?acc&:(or (eq ?acc SI)
                                                 (eq ?acc PARCIAL)))
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Presupuesto algo ajustado")
    (slot-insert$ ?cand desventajas 1 "Presupuesto ajustado")
)

; Clasifica como parcialmente adecuado cuando la temática es parcial
(defrule HEURISTICA::clasificar-parcial-tematica
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok PARCIAL)
                     (presupuesto-ok ?pok&:(or (eq ?pok SI)
                                               (eq ?pok PARCIAL)))
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Tematica parcialmente compatible")
)

; Clasifica como parcialmente adecuado cuando el transporte no es compatible
(defrule HEURISTICA::clasificar-parcial-transporte
    (declare (salience -3))
    ?cand <- (object (is-a CandidatoCiudad)
                     (tematica-ok ?tok&:(or (eq ?tok SI)
                                            (eq ?tok PARCIAL)))
                     (presupuesto-ok ?pok&:(or (eq ?pok SI)
                                               (eq ?pok PARCIAL)))
                     (transporte-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado PARCIALMENTE_ADECUADO)
    (send ?cand put-motivo "Transporte no conveniente")
)

; Clasifica como no recomendable cuando falla la accesibilidad
(defrule HEURISTICA::clasificar-no-recomendable-accesibilidad
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad)
                     (accesibilidad-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "Sin accesibilidad adecuada")
    (slot-insert$ ?cand desventajas 1 "Sin accesibilidad")
)

; Clasifica como no recomendable cuando excede el presupuesto
(defrule HEURISTICA::clasificar-no-recomendable-presupuesto
    (declare (salience -4))
    ?cand <- (object (is-a CandidatoCiudad)
                     (presupuesto-ok NO)
                     (grado nil))
=>
    (send ?cand put-grado NO_RECOMENDABLE)
    (send ?cand put-motivo "Excede el presupuesto")
    (slot-insert$ ?cand desventajas 1 "Precio excesivo")
)

; Clasifica como no recomendable cuando temática y presupuesto fallan simultáneamente
(defrule HEURISTICA::clasificar-no-recomendable-total
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

; Muestra el resumen heurístico y transfiere el control al refinamiento
(defrule HEURISTICA::pasar-a-refinamiento
    (declare (salience -10))
=>
    (printout t crlf "--- Heuristica completada ---" crlf)

    (do-for-all-instances ((?cand CandidatoCiudad)) TRUE
        (bind ?c (send ?cand get-ciudad))

        (printout t "  "
                    (nth$ 1 (send ?c get-nombre))
                    " -> "
                    (send ?cand get-grado)
                    " | "
                    (send ?cand get-motivo)
                    crlf)

        (printout t "     Ventajas:    "
                    (send ?cand get-ventajas)
                    crlf)

        (printout t "     Desventajas: "
                    (send ?cand get-desventajas)
                    crlf)
    )

    (printout t crlf)
    (focus REFINAMIENTO)
)
