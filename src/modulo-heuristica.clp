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
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_odiado ?transp))
    ?cand <- (object (is-a TransporteCandidato) (transporte ?t))
    (object (is-a Transporte) (name ?t) (tipo ?transp2))
    (test (eq ?transp ?transp2))
=>
    (send ?cand put-odiado SI)
)

(defrule HEURISTICA::restriccion-presupuesto-ciudad
    (declare (salience 5))
    (nivel-presupuesto ?nivel)
    (perfil-presupuesto ?perfil)
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
    (object (is-a Ciudad) (name ?ciu) (nivel_de_vida ?nv))
=>
    (bind ?ok NO)

    ; SACRIFICAR LOCALIZACION SI ES EXIGENTE
    (if (eq ?perfil EXIGENTE) then
        (switch ?nivel
            (case LUJO then (bind ?ok SI))

            (case ALTO then
                (if (<= ?nv 1.8) then (bind ?ok SI)
                 else (if (<= ?nv 2.5) then (bind ?ok PARCIAL))))

            (case MEDIO then
                (if (<= ?nv 1.4) then (bind ?ok SI)
                 else (if (<= ?nv 1.9) then (bind ?ok PARCIAL))))

            (case BAJO then
                (if (<= ?nv 1.1) then (bind ?ok SI)
                 else (if (<= ?nv 1.5) then (bind ?ok PARCIAL))))
        )
    else
        (switch ?nivel
            (case LUJO then (bind ?ok SI))

            (case ALTO then
                (if (<= ?nv 2.3) then (bind ?ok SI)
                 else (if (<= ?nv 3.0) then (bind ?ok PARCIAL))))

            (case MEDIO then
                (if (<= ?nv 1.9) then (bind ?ok SI)
                 else (if (<= ?nv 2.4) then (bind ?ok PARCIAL))))

            (case BAJO then
                (if (<= ?nv 1.4) then (bind ?ok SI)
                 else (if (<= ?nv 1.8) then (bind ?ok PARCIAL))))
        )
    )

    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-alojamiento
    (declare (salience 5))
    (nivel-presupuesto ?nivel)
    (perfil-presupuesto ?perfil)
    (ajuste-ahorro ?ajuste_ah)
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_preferido ?transp))
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?aloj))
    (object (is-a Alojamiento) (name ?aloj) (precio_noche ?precio))
=>
    (bind ?ajuste_tr 0)
    (switch ?transp
        ; Mucho presupuesto para transporte, reducir presupuesto alojamiento
        (case "Avion" then (bind ?ajuste_tr 15))
        ; Poco presupuesto transporte, aumentar presupuesto alojamiento
        (case "Autobus" then (bind ?ajuste_tr -15))
    )

    (bind ?precio-evaluado (+ ?precio ?ajuste_ah ?ajuste_tr))
    (bind ?ok NO)

    (switch ?nivel
        (case LUJO then
            (if (>= ?precio-evaluado 91) then (bind ?ok SI)))

        (case ALTO then
            (if (and (>= ?precio-evaluado 46) (<= ?precio-evaluado 130)) then (bind ?ok SI)
             else (if (and (>= ?precio-evaluado 131) (<= ?precio-evaluado 180)) then (bind ?ok PARCIAL))))

        (case MEDIO then
            (if (and (>= ?precio-evaluado 31) (<= ?precio-evaluado 75)) then (bind ?ok SI)
             else (if (or (<= ?precio-evaluado 30) (and (>= ?precio-evaluado 76) (<= ?precio-evaluado 110))) then (bind ?ok PARCIAL))))

        (case BAJO then
            (if (<= ?precio-evaluado 30) then (bind ?ok SI)
             else (if (<= ?precio-evaluado 60) then (bind ?ok PARCIAL))))
    )

    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::restriccion-presupuesto-transporte
    (declare (salience 5))
    (nivel-presupuesto ?nivel)
    ?cand <- (object (is-a TransporteCandidato) (transporte ?trans) (odiado NO))
    (object (is-a Transporte) (name ?trans) (precio ?precio))
=>
    (bind ?ok NO)

    (switch ?nivel
        (case LUJO then
            (if (>= ?precio 26) then (bind ?ok SI)))

        (case ALTO then
            (if (and (>= ?precio 16) (<= ?precio 55)) then (bind ?ok SI)
             else (if (or (<= ?precio 15) (>= ?precio 56)) then (bind ?ok PARCIAL))))

        (case MEDIO then
            (if (<= ?precio 40) then (bind ?ok SI)))

        (case BAJO then
            (if (<= ?precio 15) then (bind ?ok SI)
             else (if (<= ?precio 35) then (bind ?ok PARCIAL))))
    )

    (send ?cand put-presupuesto_ok ?ok)
)

(defrule HEURISTICA::validar-transporte-ciudad-exito
    (declare (salience 2))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (transporte_ok ~SI))

    (object (is-a Transporte) (name ?t) (tieneFin ?ciu))

    (object (is-a TransporteCandidato) (transporte ?t) (odiado NO))
=>
    (send ?cand put-transporte_ok SI)
)

(defrule HEURISTICA::validar-transporte-ciudad-fallo
    (declare (salience 1))
    ?cand <- (object (is-a CandidatoCiudad) (transporte_ok ~SI))
=>
    (send ?cand put-transporte_ok NO)
)

(defrule HEURISTICA::restriccion-accesibilidad
    (declare (salience 5))
    ?u <- (object (is-a Usuario) (name [usuario1]) (movilidad_reducida ?mov))
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu))
=>
    (if (eq ?mov FALSE)
        then (send ?cand put-accesibilidad_ok SI)
        else (send ?cand put-accesibilidad_ok PARCIAL)) 
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. EVALUAR PREFERENCIAS (OPCIONALES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction HEURISTICA::tema-instancia (?tema)
   (return (symbol-to-instance-name (sym-cat tema- (lowcase ?tema))))
)

(defrule HEURISTICA::preferencia-tematica
   (declare (salience 0))
   (tematica-deducida ?t)
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu))
   (object (is-a Ciudad)
           (name ?ciu)
           (cluster_tematico ?cluster))
   =>
   (if (eq ?cluster (HEURISTICA::tema-instancia ?t))
      then
         (send ?cand put-tematica_ok SI)
      else
         (send ?cand put-tematica_ok PARCIAL))
)

(defrule HEURISTICA::preferencia-transporte
    (declare (salience 10))
    ?u <- (object (is-a Usuario) (name [usuario1]) (transporte_preferido ?transp))
    ?cand <- (object (is-a TransporteCandidato) (transporte ?t))
    (object (is-a Transporte) (name ?t) (tipo ?transp))
=>
    (send ?cand put-preferido SI)
)

(defrule HEURISTICA::preferencia-explorador-ciudad
   ?u <- (object (is-a Usuario) (name [usuario1]) (explorador ?exp))
   ?cand <- (object (is-a CandidatoCiudad) (ciudad ?ciu) (grado nil))
   (object (is-a Ciudad) (name ?ciu) (popularidad ?pop))
=>
   (bind ?aj 0)

   (if (>= ?exp 4) then
      (if (<= ?pop 2) then (bind ?aj 8)
       else (if (= ?pop 3) then (bind ?aj 0)
       else (bind ?aj -8))))

   (if (<= ?exp 2) then
      (if (>= ?pop 4) then (bind ?aj 8)
       else (if (= ?pop 3) then (bind ?aj 0)
       else (bind ?aj -8))))

   (if (= ?exp 3) then
      (bind ?aj 0))

   (send ?cand put-ajuste_explorador ?aj)
)

(defrule HEURISTICA::preferencia-explorador-poi
   ?u <- (object (is-a Usuario) (name [usuario1]) (explorador ?exp))
   ?cand <- (object (is-a PuntoDeInteresCandidato) (puntodeinteres ?poi))
   (object (is-a PuntoDeInteres) (name ?poi) (popularidad ?pop))
=>
   (bind ?aj 0)

   (if (>= ?exp 4) then
      (if (<= ?pop 2) then (bind ?aj 2)
       else
       (if (>= ?pop 4) then (bind ?aj -2))))

   (if (<= ?exp 2) then
      (if (>= ?pop 4) then (bind ?aj 2)
       else
       (if (<= ?pop 2) then (bind ?aj -2))))

   (if (= ?exp 3) then
      (bind ?aj 0))

   (send ?cand put-ajuste_explorador ?aj)
)

(defrule HEURISTICA::preferencia-calidad-alojamiento-alta
    (declare (salience 0))
    (exigencia-alojamiento ALTA)
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?a))
    (object (is-a Alojamiento) (name ?a) (calidad ?c))
=>
    (if (>= ?c 4)
        then
            (send ?cand put-aptitud_alojamiento ALTA)
        else
            (if (= ?c 3)
                then (send ?cand put-aptitud_alojamiento MEDIA)
                else (send ?cand put-aptitud_alojamiento BAJA)))
)

(defrule HEURISTICA::preferencia-calidad-alojamiento-media
    (declare (salience 0))
    (exigencia-alojamiento MEDIA)
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?a))
    (object (is-a Alojamiento) (name ?a) (calidad ?c))
=>
    (if (>= ?c 4)
        then
            (send ?cand put-aptitud_alojamiento ALTA)
        else
            (if (>= ?c 2)
                then (send ?cand put-aptitud_alojamiento MEDIA)
                else (send ?cand put-aptitud_alojamiento BAJA)))
)

(defrule HEURISTICA::preferencia-calidad-alojamiento-baja
    (declare (salience 0))
    (exigencia-alojamiento BAJA)
    ?cand <- (object (is-a AlojamientoCandidato) (alojamiento ?a))
    (object (is-a Alojamiento) (name ?a) (calidad ?c))
=>
    (if (>= ?c 3)
        then
            (send ?cand put-aptitud_alojamiento ALTA)
        else
            (send ?cand put-aptitud_alojamiento MEDIA))
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

(defrule HEURISTICA::calcular-idoneidad-climatica
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (desventajas $?d) (grado nil))
    (ciudad-primavera ?c ?nivel-prim)
    (ciudad-verano ?c ?nivel-ver)
    (ciudad-otono ?c ?nivel-oto)
    (ciudad-invierno ?c ?nivel-inv)
    ?u <- (object (is-a Usuario) (name [usuario1]) (temporada_viaje ?temporada))
    (test (eq (member$ "Temporada ideal" ?v) FALSE))
    (test (eq (member$ "Temporada no optima" ?d) FALSE))
    (test (eq (member$ "Mala temporada" ?d) FALSE))
=>
    (bind ?etiqueta nil)
    (bind ?es-ventaja FALSE)
    (bind ?nivel-evaluado MEDIA)

    (switch ?temporada
        (case "PRIMAVERA" then (bind ?nivel-evaluado ?nivel-prim))
        (case "VERANO"    then (bind ?nivel-evaluado ?nivel-ver))
        (case "OTONO"     then (bind ?nivel-evaluado ?nivel-oto))
        (case "INVIERNO"  then (bind ?nivel-evaluado ?nivel-inv))
    )

    (switch ?nivel-evaluado
        (case BAJA  then (bind ?etiqueta "Mala temporada") (bind ?es-ventaja FALSE))
        (case MEDIA then (bind ?etiqueta "Temporada no optima") (bind ?es-ventaja FALSE))
        (case ALTA  then (bind ?etiqueta "Temporada ideal") (bind ?es-ventaja TRUE))
    )

    (if (eq ?es-ventaja TRUE)
        then
        (modify-instance ?cand (ventajas (insert$ ?v 1 ?etiqueta)))
        else
        (modify-instance ?cand (desventajas (insert$ ?d 1 ?etiqueta)))
    )
)

(defrule HEURISTICA::ventaja-clima-calido
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (clima_habitual "Calido"))
    (test (eq (member$ "Clima ideal" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Clima ideal")
)

(defrule HEURISTICA::ventaja-clima-templado
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (clima_habitual "Templado"))
    (test (eq (member$ "Clima agradable" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Clima agradable")
)

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

(defrule HEURISTICA::ventaja-hotel
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Alojamiento) (categoria HOTEL))
    (test (eq (member$ "Hotel de calidad disponible" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Hotel de calidad disponible")
)

(defrule HEURISTICA::ventaja-hostal
    ?cand <- (object (is-a CandidatoCiudad) (ciudad ?c) (ventajas $?v) (grado nil))
    (object (name ?c) (tieneAlojamiento $? ?aloj $?))
    (object (name ?aloj) (is-a Alojamiento) (categoria HOSTAL))
    (test (eq (member$ "Alojamiento economico disponible" ?v) FALSE))
=>
    (slot-insert$ ?cand ventajas 1 "Alojamiento economico disponible")
)

(defrule HEURISTICA::ventaja-transporte-ok
    ?cand <- (object (is-a CandidatoCiudad) (transporte_ok SI) (ventajas $?v) (grado nil))
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

;;; INCOMPATIBILIDADES TEMÁTICAS

(defrule HEURISTICA::incompatibilidad-descanso-aventura
   (declare (salience 1))
   (tematica-deducida Descanso)
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu)
                    (desventajas $?d)
                    (grado nil))
   (object (is-a Ciudad)
           (name ?ciu)
           (cluster_tematico ?tema))
   (test (eq ?tema [tema-aventura]))
   (test (eq (member$ "Incompatible: ciudad de aventura/riesgo" ?d) FALSE))
=>
   (slot-insert$ ?cand desventajas 1 "Incompatible: ciudad de aventura/riesgo")
   (send ?cand put-tematica_ok NO)
   (send ?cand put-incompatibilidad_especifica SI)
)

(defrule HEURISTICA::incompatibilidad-familiar-romantico
   (declare (salience 1))
   (tematica-deducida Familiar)
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu)
                    (desventajas $?d)
                    (grado nil))
   (object (is-a Ciudad)
           (name ?ciu)
           (cluster_tematico ?tema))
   (test (eq ?tema [tema-romantico]))
   (test (eq (member$ "Incompatible: ciudad orientada a parejas" ?d) FALSE))
=>
   (slot-insert$ ?cand desventajas 1 "Incompatible: ciudad orientada a parejas")
   (send ?cand put-tematica_ok NO)
   (send ?cand put-incompatibilidad_especifica SI)
)

(defrule HEURISTICA::incompatibilidad-cultural-descanso
   (declare (salience 1))
   (tematica-deducida Cultural)
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu)
                    (desventajas $?d)
                    (grado nil))
   (object (is-a Ciudad)
           (name ?ciu)
           (cluster_tematico ?tema))
   (test (eq ?tema [tema-descanso]))
   (test (eq (member$ "Oferta cultural limitada" ?d) FALSE))
=>
   (slot-insert$ ?cand desventajas 1 "Oferta cultural limitada")
   (send ?cand put-tematica_ok NO)
   (send ?cand put-incompatibilidad_especifica SI)
)

(defrule HEURISTICA::incompatibilidad-romantico-aventura
   (declare (salience 1))
   (tematica-deducida Romantico)
   ?cand <- (object (is-a CandidatoCiudad)
                    (ciudad ?ciu)
                    (desventajas $?d)
                    (grado nil))
   (object (is-a Ciudad)
           (name ?ciu)
           (cluster_tematico ?tema))
   (test (eq ?tema [tema-aventura]))
   (test (eq (member$ "Ambiente poco romantico" ?d) FALSE))
=>
   (slot-insert$ ?cand desventajas 1 "Ambiente poco romantico")
   (send ?cand put-tematica_ok NO)
   (send ?cand put-incompatibilidad_especifica SI)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. CLASIFICACIÓN FINAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule HEURISTICA::bloquear-presupuesto
   (declare (salience 0))
   ?cand <- (object (is-a CandidatoCiudad)
                    (presupuesto_ok NO)
                    (desventajas $?d)
                    (grado nil))
=>
   (send ?cand put-grado NO_RECOMENDABLE)
   (send ?cand put-motivo "RESTRICCION: Excede presupuesto maximo")
   (if (eq (member$ "RESTRICCION: Precio excesivo" ?d) FALSE)
      then
      (slot-insert$ ?cand desventajas 1 "RESTRICCION: Precio excesivo"))
)

(defrule HEURISTICA::bloquear-accesibilidad
   (declare (salience 0))
   ?cand <- (object (is-a CandidatoCiudad)
                    (accesibilidad_ok NO)
                    (desventajas $?d)
                    (grado nil))
=>
   (send ?cand put-grado NO_RECOMENDABLE)
   (send ?cand put-motivo "RESTRICCION: Sin accesibilidad adecuada")
   (if (eq (member$ "RESTRICCION: Sin accesibilidad" ?d) FALSE)
      then
      (slot-insert$ ?cand desventajas 1 "RESTRICCION: Sin accesibilidad"))
)

(defrule HEURISTICA::bloquear-transporte
   (declare (salience 0))
   ?cand <- (object (is-a CandidatoCiudad)
                    (transporte_ok NO)
                    (desventajas $?d)
                    (grado nil))
=>
   (send ?cand put-grado NO_RECOMENDABLE)
   (send ?cand put-motivo "RESTRICCION: Requiere transporte prohibido")
   (if (eq (member$ "RESTRICCION: Transporte prohibido" ?d) FALSE)
      then
      (slot-insert$ ?cand desventajas 1 "RESTRICCION: Transporte prohibido"))
)

(defrule HEURISTICA::clasificar-muy-recomendable
   (declare (salience -1))
   ?cand <- (object (is-a CandidatoCiudad)
                    (presupuesto_ok SI)
                    (transporte_ok SI)
                    (accesibilidad_ok SI)
                    (tematica_ok SI)
                    (ventajas $?v)
                    (desventajas $?d)
                    (grado nil))
   (test (>= (length$ ?v) 2))
   (test (= (length$ ?d) 0))
=>
   (send ?cand put-grado MUY_RECOMENDABLE)
   (send ?cand put-motivo "Encaje excelente con el perfil del viaje")
)

(defrule HEURISTICA::clasificar-recomendable
   (declare (salience -2))
   ?cand <- (object (is-a CandidatoCiudad)
                    (presupuesto_ok SI)
                    (transporte_ok SI)
                    (accesibilidad_ok ?acc)
                    (tematica_ok SI)
                    (ventajas $?v)
                    (desventajas $?d)
                    (grado nil))
   (test (or (eq ?acc SI) (eq ?acc PARCIAL)))
   (test (>= (length$ ?v) 3))
   (test (<= (length$ ?d) 1))
=>
   (send ?cand put-grado RECOMENDABLE)
   (send ?cand put-motivo "Muy buena opcion, con pocas pegas")
)

(defrule HEURISTICA::clasificar-adecuado
   (declare (salience -3))
   ?cand <- (object (is-a CandidatoCiudad)
                    (presupuesto_ok ?p)
                    (transporte_ok SI)
                    (accesibilidad_ok ?acc)
                    (tematica_ok ?tem)
                    (ventajas $?v)
                    (desventajas $?d)
                    (grado nil))
   (test (or (eq ?p SI) (eq ?p PARCIAL)))
   (test (or (eq ?acc SI) (eq ?acc PARCIAL)))
   (test (or (eq ?tem SI) (eq ?tem PARCIAL)))
   (test (> (length$ ?v) (length$ ?d)))
=>
   (send ?cand put-grado ADECUADO)
   (send ?cand put-motivo "Balance positivo entre ventajas e inconvenientes")
)

(defrule HEURISTICA::clasificar-poco-adecuado
   (declare (salience -4))
   ?cand <- (object (is-a CandidatoCiudad)
                    (presupuesto_ok ?p)
                    (transporte_ok SI)
                    (accesibilidad_ok ?acc)
                    (tematica_ok ?tem)
                    (ventajas $?v)
                    (desventajas $?d)
                    (grado nil))
   (test (or (eq ?p SI) (eq ?p PARCIAL)))
   (test (or (eq ?acc SI) (eq ?acc PARCIAL)))
   (test (or (eq ?tem SI) (eq ?tem PARCIAL) (eq ?tem NO)))
   (test (<= (length$ ?v) (length$ ?d)))
=>
   (send ?cand put-grado POCO_ADECUADO)
   (send ?cand put-motivo "Pesan tanto o mas los inconvenientes que las ventajas")
)

(defrule HEURISTICA::clasificar-resto-poco-adecuado
   (declare (salience -5))
   ?cand <- (object (is-a CandidatoCiudad)
                    (grado nil))
=>
   (send ?cand put-grado POCO_ADECUADO)
   (send ?cand put-motivo "No destaca y presenta un encaje debil")
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
