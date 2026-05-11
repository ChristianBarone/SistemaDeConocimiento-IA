;;; test-heuristica.clp
;;; Prueba aislada del modulo HEURISTICA
;;; Los slots de evaluacion (tematica-ok, presupuesto-ok, etc.) se rellenan
;;; directamente, simulando lo que habria hecho el modulo de abstraccion

(defmodule MAIN (export ?ALL))

(load "ontologia.clp")
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
        (tematica-ok     SI)
        (presupuesto-ok  SI)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
    )

    ; Madrid: Metropolis, nivel_vida 1.0
    ([cand-Madrid] of CandidatoCiudad
        (ciudad          [Madrid])
        (tematica-ok     PARCIAL)
        (presupuesto-ok  SI)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
    )

    ; Paris: Metropolis, nivel_vida 1.4 → presupuesto ajustado para ALTO
    ([cand-Paris] of CandidatoCiudad
        (ciudad          [Paris])
        (tematica-ok     SI)
        (presupuesto-ok  PARCIAL)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
    )

    ; Niza: Costa, nivel_vida 1.2, clima Calido
    ([cand-Niza] of CandidatoCiudad
        (ciudad          [Niza])
        (tematica-ok     SI)
        (presupuesto-ok  SI)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
    )

    ; Roma: Historica, nivel_vida 1.2
    ([cand-Roma] of CandidatoCiudad
        (ciudad          [Roma])
        (tematica-ok     PARCIAL)
        (presupuesto-ok  SI)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
    )

    ; Florencia: Artistica, nivel_vida 1.1
    ([cand-Florencia] of CandidatoCiudad
        (ciudad          [Florencia])
        (tematica-ok     PARCIAL)
        (presupuesto-ok  SI)
        (accesibilidad-ok SI)
        (transporte-ok   SI)
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