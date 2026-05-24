;;; ---------------------------------------------------------
;;; ontologia_v2.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology ontologia_v2.ttl
;;; :Date 13/05/2026 19:03:57

(defclass Transporte "Descriu el tipus de transport utilitzat per realitzar un desplaçament dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot tieneFin
        (type INSTANCE)
        (create-accessor read-write))
    (slot tieneOrigen
        (type INSTANCE)
        (create-accessor read-write))
    (slot duracion_horas
        (type FLOAT)
        (create-accessor read-write))
    (slot medio
        (type STRING)
        (create-accessor read-write))
    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO
    (slot accesible
        (type SYMBOL)
        (create-accessor read-write))
    (slot precio
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Autobus
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass Avion
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass CocheAlquiler
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass Tren
    (is-a Transporte)
    (role concrete)
    (pattern-match reactive)
)

(defclass PuntoDeInteres "Descriu els diferents punts d'interes que es poden visitar dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO, PARCIAL (no visitable en su totalidad)
    (slot accesible
        (type SYMBOL)
        (create-accessor read-write))
    (slot precio_PI
        (type FLOAT)
        (create-accessor read-write))
)

(defclass Monumento
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Museo
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Ocio
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)

(defclass Parque
    (is-a PuntoDeInteres)
    (role concrete)
    (pattern-match reactive)
)


(defclass Alojamiento "Descriu el tipus d'allotjament utilitzat al viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot categoria
        (type STRING)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
    (slot precio_noche
        (type FLOAT)
        (create-accessor read-write))
    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO
    (slot accesible
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Apartamento
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Hostal
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Hotel
    (is-a Alojamiento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Ciudad "Representa les ciutats que es poden visitar a un viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot conectaCon
        (type INSTANCE)
        (create-accessor read-write))
    (multislot tieneAlojamiento
        (type INSTANCE)
        (create-accessor read-write))
    (multislot tienePOI
        (type INSTANCE)
        (create-accessor read-write))
    (slot clima_habitual
        (type STRING)
        (create-accessor read-write))
    (slot cluster_tematico
        (type SYMBOL)
        (create-accessor read-write))
    (slot nivel_de_vida
        (type FLOAT)
        (create-accessor read-write))
    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, PARCIAL
    (slot accesible
        (type SYMBOL)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
)

(defclass Usuario "Representa l'usuari client que es beneficiara de la planificació del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot recibeViaje
        (type INSTANCE)
        (create-accessor read-write))
    (multislot acompanyants
        (type STRING)
        (create-accessor read-write))
    (slot ciudades_max
        (type INTEGER)
        (create-accessor read-write))
    (slot ciudades_min
        (type INTEGER)
        (create-accessor read-write))
    (slot dias_max
        (type INTEGER)
        (create-accessor read-write))
    (slot dias_min
        (type INTEGER)
        (create-accessor read-write))
    (slot edad
        (type INTEGER)
        (create-accessor read-write))
    (slot explorador
        (type INTEGER)
        (create-accessor read-write))
    (slot motivo_viaje
        (type STRING)
        (create-accessor read-write))
    (slot movilidad_reducida
        (type SYMBOL)
        (create-accessor read-write))
    (slot nivel_cultural
        (type STRING)
        (create-accessor read-write))
    (slot presupuesto_max
        (type FLOAT)
        (create-accessor read-write))
    (slot transporte_odiado
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Viaje "Representa l'objecte del viatge final proposat."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot incluyeCiudad
        (type INSTANCE)
        (create-accessor read-write))
    (multislot incluyePI
        (type INSTANCE)
        (create-accessor read-write))
    (slot tieneTema
        (type INSTANCE)
        (create-accessor read-write))
    (multislot viajaCon
        (type INSTANCE)
        (create-accessor read-write))
    (slot durada_dias
        (type INTEGER)
        (create-accessor read-write))
    (slot precio_total
        (type INTEGER)
        (create-accessor read-write))
)

(defclass ViajeCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot incluyeCiudad
        (type INSTANCE)
        (create-accessor read-write))
    (multislot incluyeAlojamiento
        (type INSTANCE)
        (create-accessor read-write))
    (slot n_ciudades
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot durada_dias
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot precio_total
        (type FLOAT)
        (default 0.0)
        (create-accessor read-write))
    (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    (slot valido
        (type SYMBOL)
        (default FALSE)
        (create-accessor read-write))
    (slot seleccionado
        (type SYMBOL)
        (default FALSE)
        (create-accessor read-write))
)

(defclass CandidatoCiudad "Representa el com s'adecua una ciutat a les restriccions de l'usuari"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot ciudad
        (type INSTANCE)
        (create-accessor read-write))
    (multislot desventajas
        (type STRING)
        (create-accessor read-write))
    (slot durada_estada
        (type INTEGER)
        (create-accessor read-write))
    (slot grado
        (type SYMBOL)
        (create-accessor read-write))
    (slot motivo
        (type STRING)
        (create-accessor read-write))
    ;;; Evaluacion del nivel de vida vs presupuesto: SI, NO, PARCIAL
    (slot presupuesto_ok
        (type SYMBOL)
        (create-accessor read-write))
    ;;; Evaluacion de compatibilidad con la tematica: SI, NO, PARCIAL
    (slot tematica_ok
        (type SYMBOL)
        (create-accessor read-write))
    (slot accesibilidad_ok ;; SI, PARCIAL
        (type SYMBOL)
        (create-accessor read-write))
    (multislot ventajas
        (type STRING)
        (create-accessor read-write))
    (slot incompatibilidad_especifica
        (type SYMBOL)
        (default NO)
        (create-accessor read-write))
)

(defclass AlojamientoCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot alojamiento
        (type INSTANCE)
        (create-accessor read-write))
    ; (slot categoria ;; PREMIUM, ESTANDARD, BARATO
    ;     (type SYMBOL)
    ;     (create-accessor read-write))
    (slot accesibilidad_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
     (multislot desventajas
        (type STRING)
        (create-accessor read-write))
    (multislot ventajas
        (type STRING)
        (create-accessor read-write))
   (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    ; (slot seleccionado
    ;     (type SYMBOL)
    ;     (default FALSE)
    ;     (create-accessor read-write))
)

(defclass TransporteCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot transporte
        (type SYMBOL) ;; Tipo de transporte (Avion, Tren, Autobus, CocheAlquiler)
        (create-accessor read-write))
    ; (slot categoria ;; PREMIUM, ESTANDARD, BARATO
    ;     (type SYMBOL)
    ;     (create-accessor read-write))
    (slot accesibilidad_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
    (slot odiado
        (type SYMBOL) ;; SI, NO
        (create-accessor read-write))
   (multislot desventajas
        (type STRING)
        (create-accessor read-write))
    (multislot ventajas
        (type STRING)
        (create-accessor read-write))
   (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    ; (slot seleccionado
    ;     (type SYMBOL)
    ;     (default FALSE)
    ;     (create-accessor read-write))
)

(defclass PuntoDeInteresCandidato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot puntodeinteres
        (type INSTANCE)
        (create-accessor read-write))
    ; (slot categoria ;; CARO, BARATO, GRATIS
    ;     (type SYMBOL)
    ;     (create-accessor read-write))
    (slot accesibilidad_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
    (slot precio_ok
        (type SYMBOL) ;; SI, NO
        (default FALSE)
        (create-accessor read-write))
    (multislot desventajas
        (type STRING)
        (create-accessor read-write))
    (multislot ventajas
        (type STRING)
        (create-accessor read-write))
   (slot puntuacion
        (type INTEGER)
        (default 0)
        (create-accessor read-write))
    ; (slot seleccionado
    ;     (type SYMBOL)
    ;     (default FALSE)
    ;     (create-accessor read-write))
)
