;;; test-heuristica.clp
;;; Prueba aislada del modulo HEURISTICA
;;; Los slots de evaluacion (tematica-ok, presupuesto-ok, etc.) se rellenan
;;; directamente, simulando lo que habria hecho el modulo de abstraccion

(defmodule MAIN (export ?ALL))

(load "ontologia_v3.clp")
(load "instancias_v3.clp")
(load "modulo-preguntas.clp")
(load "modulo-abstraccion.clp")
(load "modulo-heuristica.clp")

;;; ============================================================
;;; CASO 1: Pareja romantica, presupuesto ALTO
;;; tematica encaja con Mediterranea/Costa → Barcelona, Niza MUY_RECOMENDABLE
;;; Paris: tematica SI (Metropolis) pero no es costa → ADECUADO
;;; ============================================================

(definstances MAIN::candidatos-caso1

    ; Barcelona: Mediterranea, nivel_vida 1.1, Hotel+Hostal, 3 POI (Parque+Museo+Monumento)
    ([cand-Barcelona] of CandidatoCiudad
        (ciudad          [Barcelona])
        (tematica_ok     SI)
        (presupuesto_ok  SI)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )

    ; Madrid: Metropolis, nivel_vida 1.0
    ([cand-Madrid] of CandidatoCiudad
        (ciudad          [Madrid])
        (tematica_ok     PARCIAL)
        (presupuesto_ok  SI)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )

    ; Paris: Metropolis, nivel_vida 1.4 → presupuesto ajustado para ALTO
    ([cand-Paris] of CandidatoCiudad
        (ciudad          [Paris])
        (tematica_ok     SI)
        (presupuesto_ok  PARCIAL)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )

    ; Niza: Costa, nivel_vida 1.2, clima Calido
    ([cand-Niza] of CandidatoCiudad
        (ciudad          [Niza])
        (tematica_ok     SI)
        (presupuesto_ok  SI)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )

    ; Roma: Historica, nivel_vida 1.2
    ([cand-Roma] of CandidatoCiudad
        (ciudad          [Roma])
        (tematica_ok     PARCIAL)
        (presupuesto_ok  SI)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )

    ; Florencia: Artistica, nivel_vida 1.1
    ([cand-Florencia] of CandidatoCiudad
        (ciudad          [Florencia])
        (tematica_ok     PARCIAL)
        (presupuesto_ok  SI)
        (accesibilidad_ok SI)
        (transporte_ok   SI)
    )
)

(defrule MAIN::iniciar-caso1
    (declare (salience 1000))
    (initial-fact)
=>
    (printout t crlf "==============================" crlf)
    (printout t "CASO 1: Pareja romantica, presupuesto ALTO" crlf)
    (printout t "  Esperado: Barcelona/Niza -> MUY_RECOMENDABLE" crlf)
    (printout t "            Paris          -> PARCIALMENTE_ADECUADO" crlf)
    (printout t "            Madrid/Roma/Florencia -> PARCIALMENTE_ADECUADO" crlf)
    (printout t "==============================" crlf crlf)
)

(reset)
(focus HEURISTICA)
(run)
