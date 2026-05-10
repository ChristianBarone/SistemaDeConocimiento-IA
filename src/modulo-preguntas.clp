
(defmodule PREGUNTAS
    (import MAIN ?ALL)
    (export ?ALL)
)

(deftemplate PREGUNTAS::fase-entrada
    (slot fase (type SYMBOL))
)

(deftemplate PREGUNTAS::entrada-completada
    (slot completada (type SYMBOL) (default TRUE))
)

(defrule PREGUNTAS::mostrar-bienvenida
    (declare (salience 100))
    (not (fase-entrada))
    (not (entrada-completada))
    =>
    (printout t crlf "=== SISTEMA DE RECOMENDACION DE VIAJES ===" crlf crlf)
    (make-instance [usuario1] of Usuario)
    (assert (fase-entrada (fase VIAJE)))
)

(defrule PREGUNTAS::solicitar-viaje
    ?f <- (fase-entrada (fase VIAJE))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t "-- MOTIVO DEL VIAJE --" crlf)
    (printout t "¿Cual es el motivo? (1.Bodas 2.Fin_De_Curso 3.Vacaciones 4.Negocios 5.Otro): ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 3 else (string-to-field ?resp)))
    (bind ?motivo (switch ?op
        (case 1 then "Bodas")
        (case 2 then "Fin_De_Curso")
        (case 3 then "Vacaciones")
        (case 4 then "Negocios")
        (default "Otro")
    ))
    (printout t "¿Con quien viajas? (1.Solo 2.Pareja 3.Familia_Con_Ninos 4.Amigos): ")
    (bind ?resp2 (readline))
    (bind ?op2 (if (eq ?resp2 "") then 1 else (string-to-field ?resp2)))
    (bind ?acomp (switch ?op2
        (case 1 then "Solo")
        (case 2 then "Pareja")
        (case 3 then "Familia_Con_Ninos")
        (default "Amigos")
    ))
    (send ?u put-motivo_viaje ?motivo)
    (send ?u put-acompanyants ?acomp)
    (modify ?f (fase PRESUPUESTO))
)

(defrule PREGUNTAS::solicitar-presupuesto
    ?f <- (fase-entrada (fase PRESUPUESTO))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- PRESUPUESTO Y DURACION --" crlf)
    (printout t "Presupuesto maximo (euros): ")
    (bind ?pres (read))
    (printout t "Dias minimo: ")
    (bind ?resp (readline))
    (bind ?dmin (if (eq ?resp "") then 3 else (string-to-field ?resp)))
    (printout t "Dias maximo: ")
    (bind ?resp (readline))
    (bind ?dmax (if (eq ?resp "") then 7 else (string-to-field ?resp)))
    (send ?u put-presupuesto_max (float ?pres))
    (send ?u put-dias_min (integer ?dmin))
    (send ?u put-dias_max (integer ?dmax))
    (modify ?f (fase CIUDADES))
)

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
    (send ?u put-ciudades_min (integer ?cmin))
    (send ?u put-ciudades_max (integer ?cmax))
    (modify ?f (fase PERFIL))
)

(defrule PREGUNTAS::solicitar-perfil
    ?f <- (fase-entrada (fase PERFIL))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- PERFIL --" crlf)
    (printout t "Nivel cultural (1.Bajo 2.Medio 3.Alto) [2]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 2 else (string-to-field ?resp)))
    (bind ?cultura (switch ?op
        (case 1 then "Bajo")
        (case 3 then "Alto")
        (default "Medio")
    ))
    (printout t "Grado explorador (1=ciudades conocidas, 5=destinos raros) [3]: ")
    (bind ?resp (readline))
    (bind ?expl (if (eq ?resp "") then 3 else (string-to-field ?resp)))
    (printout t "¿Movilidad reducida? (s/n) [n]: ")
    (bind ?resp (readline))
    (bind ?movil (if (member$ ?resp (create$ "s" "S" "si" "SI")) then TRUE else FALSE))
    (send ?u put-nivel_cultural ?cultura)
    (send ?u put-explorador (integer ?expl))
    (send ?u put-movilidad_reducida ?movil)
    (modify ?f (fase TRANSPORTE))
)

(defrule PREGUNTAS::solicitar-transporte
    ?f <- (fase-entrada (fase TRANSPORTE))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "-- TRANSPORTE --" crlf)
    (printout t "¿Algun transporte que quieras evitar? (1.ninguno 2.Avion 3.Tren 4.Autobus) [1]: ")
    (bind ?resp (readline))
    (bind ?op (if (eq ?resp "") then 1 else (string-to-field ?resp)))
    (bind ?transp (switch ?op
        (case 2 then "Avion")
        (case 3 then "Tren")
        (case 4 then "Autobus")
        (default "ninguno")
    ))
    (send ?u put-transporte_odiado ?transp)
    (modify ?f (fase FIN))
)

(defrule PREGUNTAS::finalizar
    ?f <- (fase-entrada (fase FIN))
    ?u <- (object (is-a Usuario) (name [usuario1]))
=>
    (printout t crlf "=== RESUMEN ===" crlf)
    (printout t "Motivo: "      (send ?u get-motivo_viaje)    crlf)
    (printout t "Acompañantes: "(send ?u get-acompanyants)    crlf)
    (printout t "Presupuesto: " (send ?u get-presupuesto_max) " euros" crlf)
    (printout t "Duracion: "    (send ?u get-dias_min) "-" (send ?u get-dias_max) " dias" crlf)
    (printout t "Ciudades: "    (send ?u get-ciudades_min) "-" (send ?u get-ciudades_max) crlf)
    (printout t "Cultura: "     (send ?u get-nivel_cultural)  crlf)
    (printout t "Explorador: "  (send ?u get-explorador)      crlf)
    (printout t "Transporte evitado: " (send ?u get-transporte_odiado) crlf)
    (printout t crlf "Buscando viaje..." crlf crlf)
    (retract ?f)
    (assert (entrada-completada))
)