;;; Módulo de preguntas: recopila preferencias del usuario

(defmodule PREGUNTAS
    (import MAIN ?ALL)
    (export ?ALL)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CONTROL DE FASES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate PREGUNTAS::fase-entrada
    (slot fase (type SYMBOL))
)

(deftemplate PREGUNTAS::entrada-completada
    (slot completada (type SYMBOL) (default TRUE))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; INICIALIZACIÓN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Inicializa la instancia de usuario y activa la primera fase
(defrule PREGUNTAS::mostrar-bienvenida
    (declare (salience 100))
    (not (fase-entrada))
    (not (entrada-completada (completada TRUE)))
=>
    (printout t crlf "=== SISTEMA DE RECOMENDACION DE VIAJES ===" crlf crlf)
    (make-instance [usuario1] of Usuario)
    (assert (fase-entrada (fase VIAJE)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PREGUNTAS DE VIAJE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recoge motivo del viaje y acompañantes
(defrule PREGUNTAS::solicitar-viaje
    ?f <- (fase-entrada (fase VIAJE))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t "-- MOTIVO DEL VIAJE --" crlf)
    (printout t "Cual es el motivo? (1.Bodas 2.Fin_De_Curso 3.Vacaciones 4.Negocios 5.Otro) [3]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 3 else (string-to-field ?resp)))

    (bind ?motivo
        (if (eq ?op 1) then "Bodas"
        else (if (eq ?op 2) then "Fin_De_Curso"
        else (if (eq ?op 4) then "Negocios"
        else (if (eq ?op 5) then "Otro" else "Vacaciones")))))

    (printout t "Con quien viajas? (1.Solo 2.Pareja 3.Familia_Con_Ninos 4.Amigos) [1]: ")
    (bind ?resp2 (readline))
    (bind ?op2 (if (eq ?resp2 "") then 1 else (string-to-field ?resp2)))

    (bind ?acomp
        (if (eq ?op2 2) then "Pareja"
        else (if (eq ?op2 3) then "Familia_Con_Ninos"
        else (if (eq ?op2 4) then "Amigos" else "Solo"))))

    (printout t "En cual temporada viajas? (1.Primavera 2.Verano 3.Otono 4.Invierno) [1]: ")
    (bind ?resp (readline))
    (bind ?op3 (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (bind ?tempor
        (if (eq ?op3 2) then "VERANO"
        else (if (eq ?op3 3) then "OTONO"
        else (if (eq ?op3 4) then "INVIERNO" else "PRIMAVERA"))))

    (send ?u put-motivo_viaje ?motivo)
    (send ?u put-acompanyants ?acomp)
    (send ?u put-temporada_viaje ?tempor)
    (modify ?f (fase PRESUPUESTO))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PREGUNTAS DE PRESUPUESTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recoge presupuesto y duración del viaje
(defrule PREGUNTAS::solicitar-presupuesto
    ?f <- (fase-entrada (fase PRESUPUESTO))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- PRESUPUESTO Y DURACION --" crlf)

    (printout t "Presupuesto maximo (euros) [500]: ")
    (bind ?resp (readline))
    (bind ?pres (if (eq ?resp "") then 500 else (string-to-field ?resp)))

    (printout t "Dias minimo [3]: ")
    (bind ?resp (readline))
    (bind ?dmin (if (eq ?resp "") then 3 else (string-to-field ?resp)))

    (printout t "Dias maximo [7]: ")
    (bind ?resp (readline))
    (bind ?dmax (if (eq ?resp "") then 7 else (string-to-field ?resp)))

    (printout t "Del 1 al 5, grado de ahorro [1]: ")
    (bind ?resp (readline))
    (bind ?ahorro (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (printout t "Del 1 al 5, prioridad de calidad de alojamiento [3]: ")
    (bind ?resp (readline))
    (bind ?cal_aloj (if (eq ?resp "") then 3 else (string-to-field ?resp)))

    ; Ajuste simple de consistencia
    (if (> ?dmin ?dmax) then
        (bind ?aux ?dmin)
        (bind ?dmin ?dmax)
        (bind ?dmax ?aux))

    (send ?u put-presupuesto_max (float ?pres))
    (send ?u put-dias_min (integer ?dmin))
    (send ?u put-dias_max (integer ?dmax))
    (send ?u put-grado_ahorro (integer ?ahorro))
    (send ?u put-prioridad_alojamiento (integer ?cal_aloj))
    (modify ?f (fase CIUDADES))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PREGUNTAS DE CIUDADES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recoge el rango de ciudades a visitar y días por ciudad
(defrule PREGUNTAS::solicitar-ciudades
    ?f <- (fase-entrada (fase CIUDADES))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- CIUDADES --" crlf)

    (printout t "Numero minimo de ciudades a visitar [1]: ")
    (bind ?resp (readline))
    (bind ?cmin (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (printout t "Numero maximo de ciudades a visitar [3]: ")
    (bind ?resp (readline))
    (bind ?cmax (if (eq ?resp "") then 3 else (string-to-field ?resp)))

    ; Ajuste simple de consistencia
    (if (> ?cmin ?cmax) then
        (bind ?aux ?cmin)
        (bind ?cmin ?cmax)
        (bind ?cmax ?aux))

    (printout t "Dias minimo en cada ciudad [1]: ")
    (bind ?resp (readline))
    (bind ?cdmin (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (printout t "Dias maximo en cada ciudad [3]: ")
    (bind ?resp (readline))
    (bind ?cdmax (if (eq ?resp "") then 3 else (string-to-field ?resp)))

    ; Ajuste simple de consistencia
    (if (> ?cdmin ?cdmax) then
        (bind ?aux ?cdmin)
        (bind ?cdmin ?cdmax)
        (bind ?cdmax ?aux))

    (send ?u put-ciudades_min (integer ?cmin))
    (send ?u put-ciudades_max (integer ?cmax))
    (send ?u put-ciudad_dias_min (integer ?cdmin))
    (send ?u put-ciudad_dias_max (integer ?cdmax))
    (modify ?f (fase PERFIL))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PREGUNTAS DE PERFIL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recoge nivel cultural, grado explorador y movilidad
(defrule PREGUNTAS::solicitar-perfil
    ?f <- (fase-entrada (fase PERFIL))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- PERFIL --" crlf)

    (printout t "Nivel cultural (1.Bajo 2.Medio 3.Alto) [2]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 2 else (string-to-field ?resp)))
    (bind ?cultura
        (if (eq ?op 1) then "Bajo"
        else (if (eq ?op 3) then "Alto" else "Medio")))

    (printout t "Grado explorador (1-5) [3]: ")
    (bind ?resp (readline))
    (bind ?expl (if (eq ?resp "") then 3 else (string-to-field ?resp)))
    (if (< ?expl 1) then (bind ?expl 1))
    (if (> ?expl 5) then (bind ?expl 5))

    (printout t "Movilidad reducida? (s/n) [n]: ")
    (bind ?resp (readline))
    (bind ?movil (if (member$ ?resp (create$ "s" "S" "si" "SI" "Si")) then TRUE else FALSE))

    (send ?u put-nivel_cultural ?cultura)
    (send ?u put-explorador (integer ?expl))
    (send ?u put-movilidad_reducida ?movil)
    (modify ?f (fase ODIADO))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PREGUNTAS DE TRANSPORTE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Recoge el transporte que el usuario quiere evitar
(defrule PREGUNTAS::solicitar-transporte-evitar
    ?f <- (fase-entrada (fase ODIADO))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- TRANSPORTE --" crlf)
    (printout t "Algun transporte que quieras evitar? (1.Ninguno 2.Avion 3.Tren 4.Autobus) [1]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (bind ?transp
        (if (eq ?op 2) then "Avion"
        else (if (eq ?op 3) then "Tren"
        else (if (eq ?op 4) then "Autobus" else "Ninguno"))))

    (send ?u put-transporte_odiado ?transp)
    (modify ?f (fase PREFERIDO))
)

(defrule PREGUNTAS::solicitar-transporte-preferir
    ?f <- (fase-entrada (fase PREFERIDO))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t "Algun transporte que prefieras? (1.Ninguno 2.Avion 3.Tren 4.Autobus) [1]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 1 else (string-to-field ?resp)))

    (bind ?transp
        (if (eq ?op 2) then "Avion"
        else (if (eq ?op 3) then "Tren"
        else (if (eq ?op 4) then "Autobus" else "Ninguno"))))

    (send ?u put-transporte_preferido ?transp)
    (modify ?f (fase FIN))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FINALIZACIÓN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Muestra un resumen de entrada y activa el siguiente módulo
(defrule PREGUNTAS::finalizar
    ?f <- (fase-entrada (fase FIN))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "=== RESUMEN ===" crlf)
    (printout t "Motivo: " (send ?u get-motivo_viaje) crlf)
    (printout t "Acompanantes: " (send ?u get-acompanyants) crlf)
    (printout t "Temporada: " (send ?u get-temporada_viaje) crlf)
    (printout t "Presupuesto: " (send ?u get-presupuesto_max) " euros" crlf)
    (printout t "Duracion: " (send ?u get-dias_min) "-" (send ?u get-dias_max) " dias" crlf)
    (printout t "Ahorro: " (send ?u get-grado_ahorro) crlf)
    (printout t "Calidad: " (send ?u get-prioridad_alojamiento) crlf)
    (printout t "Ciudades: " (send ?u get-ciudades_min) "-" (send ?u get-ciudades_max) crlf)
    (printout t "Dias por ciudad: " (send ?u get-ciudad_dias_min) "-" (send ?u get-ciudad_dias_max) crlf)
    (printout t "Cultura: " (send ?u get-nivel_cultural) crlf)
    (printout t "Explorador: " (send ?u get-explorador) crlf)
    (printout t "Movilidad reducida: " (send ?u get-movilidad_reducida) crlf)
    (printout t "Transporte evitado: " (send ?u get-transporte_odiado) crlf)
    (printout t "Transporte preferido: " (send ?u get-transporte_preferido) crlf)
    (printout t crlf "Buscando viaje..." crlf crlf)

    (retract ?f)
    (assert (entrada-completada (completada TRUE)))
    (focus ABSTRACCION)
)
