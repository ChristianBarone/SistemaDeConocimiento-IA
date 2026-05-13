;;; ---------------------------------------------------------
;;; ontologia_v2.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology ontologia_v2.ttl
;;; :Date 13/05/2026 17:51:02

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
    ;;; De moment ignorarem aquest atribut
    (slot hora_salida
        (type SYMBOL)
        (create-accessor read-write))
    (slot medio
        (type STRING)
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

(defclass TematicaViaje "Constitueix la tematica del viatge, especificada pel client"
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Aventura
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Cultural
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Descanso
    (is-a TematicaViaje)
    (role concrete)
    (pattern-match reactive)
)

(defclass Romantico
    (is-a TematicaViaje)
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
    (multislot precio_noche
        (type FLOAT)
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

(defclass PuntoDeInteres "Descriu els diferents punts d'interes que es poden visitar dins del viatge."
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    ;;; Evaluacion de accesibilidad (movilidad reducida): SI, NO, PARCIAL
    (slot accesibilidad_ok
        (type STRING)
        (create-accessor read-write))
    (multislot precio_PI
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
    (multislot clima_habitual
        (type STRING)
        (create-accessor read-write))
    (multislot cluster_tematico
        (type STRING)
        (create-accessor read-write))
    (multislot nivel_de_vida
        (type FLOAT)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
)

(defclass CiudadCandidata "Representa el com s'adecua una ciutat a les restriccions de l'usuari"
    (is-a Ciudad)
    (role concrete)
    (pattern-match reactive)
    (multislot desventajas
        (type STRING)
        (create-accessor read-write))
    (slot durada_estada
        (type INTEGER)
        (create-accessor read-write))
    (slot grado
        (type STRING)
        (create-accessor read-write))
    (slot motivo
        (type STRING)
        (create-accessor read-write))
    ;;; Evaluacion del nivel de vida vs presupuesto: SI, NO, PARCIAL
    (slot presupuesto_ok
        (type STRING)
        (create-accessor read-write))
    ;;; Evaluacion de compatibilidad con la tematica: SI, NO, PARCIAL
    (slot tematica_ok
        (type STRING)
        (create-accessor read-write))
    ;;; Evaluacion de transporte (no usa medio odiado): SI, NO
    (slot transporte_ok
        (type STRING)
        (create-accessor read-write))
    (multislot ventajas
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
    (multislot transporte_odiado
        (type STRING)
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
