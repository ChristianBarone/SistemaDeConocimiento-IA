;;; ============================================================
;;; INSTANCIAS.CLP
;;; Compatible con ontologia_test1.clp (CLIPS COOL / defclass)
;;; ============================================================

(definstances instancias-viaje

;;; ------------------------------------------------------------
;;; CIUDADES
;;; ------------------------------------------------------------

    ([Barcelona] of Ciudad
        (nombre          "Barcelona")
        (cluster_tematico "Mediterranea")
        (nivel_de_vida   1.1)
        (clima_habitual  "Templado")
        (tieneAlojamiento [HotelW_Bcn] [HostalGotic_Bcn] [AptoEixample_Bcn])
        (tienePOI        [SagradaFamilia_Bcn] [ParqueGuell_Bcn] [MuseoPicasso_Bcn])
        (conectaCon      [Madrid] [Paris])
    )

    ([Madrid] of Ciudad
        (nombre          "Madrid")
        (cluster_tematico "Metropolis")
        (nivel_de_vida   1.0)
        (clima_habitual  "Templado")
        (tieneAlojamiento [HotelRitz_Mad] [HostalSol_Mad] [AptoRetiro_Mad])
        (tienePOI        [MuseoPrado_Mad] [ParqueRetiro_Mad] [PalacioReal_Mad])
        (conectaCon      [Barcelona] [Berlin])
    )

    ([Paris] of Ciudad
        (nombre          "Paris")
        (cluster_tematico "Metropolis")
        (nivel_de_vida   1.4)
        (clima_habitual  "Templado")
        (tieneAlojamiento [HotelRitz_Paris] [HostalMontmartre_Paris] [AptoMarais_Paris])
        (tienePOI        [TorreEiffel_Paris] [MuseoLouvre_Paris] [ArcoTriunfo_Paris])
        (conectaCon      [Barcelona] [Niza] [Roma])
    )

    ([Niza] of Ciudad
        (nombre          "Niza")
        (cluster_tematico "Costa")
        (nivel_de_vida   1.2)
        (clima_habitual  "Calido")
        (tieneAlojamiento [HotelNegresco_Niz] [HostalVieux_Niz] [AptoPromenade_Niz])
        (tienePOI        [PaseoIngleses_Niz] [ParqueColline_Niz] [MuseoMatisse_Niz])
        (conectaCon      [Paris] [Florencia])
    )

    ([Roma] of Ciudad
        (nombre          "Roma")
        (cluster_tematico "Historica")
        (nivel_de_vida   1.2)
        (clima_habitual  "Templado")
        (tieneAlojamiento [HotelEden_Roma] [HostalTrastevere_Roma] [AptoVaticano_Roma])
        (tienePOI        [Coliseo_Roma] [VillaBorghese_Roma] [MuseosVaticanos_Roma])
        (conectaCon      [Paris] [Florencia])
    )

    ([Florencia] of Ciudad
        (nombre          "Florencia")
        (cluster_tematico "Artistica")
        (nivel_de_vida   1.1)
        (clima_habitual  "Templado")
        (tieneAlojamiento [HotelBrunelleschi_Flo] [HostalArno_Flo] [AptoDuomo_Flo])
        (tienePOI        [Duomo_Flo] [JardinBoboli_Flo] [GaleriaUffizi_Flo])
        (conectaCon      [Roma] [Niza] [Munich])
    )

    ([Berlin] of Ciudad
        (nombre          "Berlin")
        (cluster_tematico "Cultura_Urb")
        (nivel_de_vida   1.3)
        (clima_habitual  "Frio")
        (tieneAlojamiento [HotelAdlon_Ber] [HostalMitte_Ber] [AptoKreuzberg_Ber])
        (tienePOI        [PuertaBrandeburgo_Ber] [Tiergarten_Ber] [MuseoPergamo_Ber])
        (conectaCon      [Madrid] [Munich])
    )

    ([Munich] of Ciudad
        (nombre          "Munich")
        (cluster_tematico "Tradicional")
        (nivel_de_vida   1.4)
        (clima_habitual  "Frio")
        (tieneAlojamiento [HotelBayerischer_Mun] [HostalIsar_Mun] [AptoMarienplatz_Mun])
        (tienePOI        [Ayuntamiento_Mun] [EnglishGarden_Mun] [MuseoBMW_Mun])
        (conectaCon      [Berlin] [Florencia])
    )

;;; ------------------------------------------------------------
;;; ALOJAMIENTOS — Barcelona
;;; ------------------------------------------------------------

    ([HotelW_Bcn] of Hotel
        (nombre         "Hotel W")
        (categoria      "5 Estrellas")
        (precio_noche   250.0)
    )
    ([HostalGotic_Bcn] of Hostal
        (nombre         "Hostal Gotic")
        (categoria      "2 Estrellas")
        (precio_noche   40.0)
    )
    ([AptoEixample_Bcn] of Apartamento
        (nombre         "Apto Eixample")
        (categoria      "Estandar")
        (precio_noche   85.0)
    )

;;; Madrid
    ([HotelRitz_Mad] of Hotel
        (nombre         "Hotel Ritz")
        (categoria      "5 Estrellas")
        (precio_noche   300.0)
    )
    ([HostalSol_Mad] of Hostal
        (nombre         "Hostal Sol")
        (categoria      "2 Estrellas")
        (precio_noche   35.0)
    )
    ([AptoRetiro_Mad] of Apartamento
        (nombre         "Apto Retiro")
        (categoria      "Premium")
        (precio_noche   100.0)
    )

;;; Paris
    ([HotelRitz_Paris] of Hotel
        (nombre         "Ritz Paris")
        (categoria      "5 Estrellas")
        (precio_noche   400.0)
    )
    ([HostalMontmartre_Paris] of Hostal
        (nombre         "Montmartre Inn")
        (categoria      "3 Estrellas")
        (precio_noche   60.0)
    )
    ([AptoMarais_Paris] of Apartamento
        (nombre         "Marais Studio")
        (categoria      "Estandar")
        (precio_noche   110.0)
    )

;;; Niza
    ([HotelNegresco_Niz] of Hotel
        (nombre         "Hotel Negresco")
        (categoria      "5 Estrellas")
        (precio_noche   280.0)
    )
    ([HostalVieux_Niz] of Hostal
        (nombre         "Vieux Nice Hostel")
        (categoria      "2 Estrellas")
        (precio_noche   45.0)
    )
    ([AptoPromenade_Niz] of Apartamento
        (nombre         "Promenade Apto")
        (categoria      "Estandar")
        (precio_noche   95.0)
    )

;;; Roma
    ([HotelEden_Roma] of Hotel
        (nombre         "Hotel Eden")
        (categoria      "5 Estrellas")
        (precio_noche   320.0)
    )
    ([HostalTrastevere_Roma] of Hostal
        (nombre         "Trastevere Hostel")
        (categoria      "3 Estrellas")
        (precio_noche   50.0)
    )
    ([AptoVaticano_Roma] of Apartamento
        (nombre         "Vatican Flat")
        (categoria      "Estandar")
        (precio_noche   90.0)
    )

;;; Florencia
    ([HotelBrunelleschi_Flo] of Hotel
        (nombre         "Brunelleschi")
        (categoria      "5 Estrellas")
        (precio_noche   290.0)
    )
    ([HostalArno_Flo] of Hostal
        (nombre         "Arno Hostel")
        (categoria      "2 Estrellas")
        (precio_noche   40.0)
    )
    ([AptoDuomo_Flo] of Apartamento
        (nombre         "Duomo View Flat")
        (categoria      "Premium")
        (precio_noche   120.0)
    )

;;; Berlin
    ([HotelAdlon_Ber] of Hotel
        (nombre         "Hotel Adlon")
        (categoria      "5 Estrellas")
        (precio_noche   350.0)
    )
    ([HostalMitte_Ber] of Hostal
        (nombre         "Mitte Hostel")
        (categoria      "3 Estrellas")
        (precio_noche   55.0)
    )
    ([AptoKreuzberg_Ber] of Apartamento
        (nombre         "Kreuzberg Loft")
        (categoria      "Estandar")
        (precio_noche   80.0)
    )

;;; Munich
    ([HotelBayerischer_Mun] of Hotel
        (nombre         "Bayerischer Hof")
        (categoria      "5 Estrellas")
        (precio_noche   330.0)
    )
    ([HostalIsar_Mun] of Hostal
        (nombre         "Isar Hostel")
        (categoria      "2 Estrellas")
        (precio_noche   45.0)
    )
    ([AptoMarienplatz_Mun] of Apartamento
        (nombre         "Marienplatz Flat")
        (categoria      "Premium")
        (precio_noche   110.0)
    )

;;; ------------------------------------------------------------
;;; PUNTOS DE INTERES
;;; ------------------------------------------------------------

;;; Barcelona
    ([SagradaFamilia_Bcn] of Monumento)
    ([ParqueGuell_Bcn]    of Parque)
    ([MuseoPicasso_Bcn]   of Museo)

;;; Madrid
    ([MuseoPrado_Mad]     of Museo)
    ([ParqueRetiro_Mad]   of Parque)
    ([PalacioReal_Mad]    of Monumento)

;;; Paris
    ([TorreEiffel_Paris]  of Monumento)
    ([MuseoLouvre_Paris]  of Museo)
    ([ArcoTriunfo_Paris]  of Monumento)

;;; Niza
    ([PaseoIngleses_Niz]  of Ocio)
    ([ParqueColline_Niz]  of Parque)
    ([MuseoMatisse_Niz]   of Museo)

;;; Roma
    ([Coliseo_Roma]       of Monumento)
    ([VillaBorghese_Roma] of Parque)
    ([MuseosVaticanos_Roma] of Museo)

;;; Florencia
    ([Duomo_Flo]          of Monumento)
    ([JardinBoboli_Flo]   of Parque)
    ([GaleriaUffizi_Flo]  of Museo)

;;; Berlin
    ([PuertaBrandeburgo_Ber] of Monumento)
    ([Tiergarten_Ber]        of Parque)
    ([MuseoPergamo_Ber]      of Museo)

;;; Munich
    ([Ayuntamiento_Mun]   of Monumento)
    ([EnglishGarden_Mun]  of Parque)
    ([MuseoBMW_Mun]       of Museo)

;;; ------------------------------------------------------------
;;; TRANSPORTES (conexiones entre ciudades)
;;; ------------------------------------------------------------

    ([Tren_Bcn_Mad] of Tren
        (medio          "Tren")
        (precio         35.0)
        (duracion_horas 2.5)
    )
    ([Tren_Mad_Ber] of Tren
        (medio          "Tren")
        (precio         90.0)
        (duracion_horas 10.0)
    )
    ([Avion_Bcn_Par] of Avion
        (medio          "Avion")
        (precio         80.0)
        (duracion_horas 1.5)
    )
    ([Tren_Bcn_Par] of Tren
        (medio          "Tren Alta Velocidad")
        (precio         60.0)
        (duracion_horas 6.5)
    )
    ([Avion_Par_Rom] of Avion
        (medio          "Avion")
        (precio         90.0)
        (duracion_horas 2.0)
    )
    ([Tren_Par_Niz] of Tren
        (medio          "Tren")
        (precio         50.0)
        (duracion_horas 5.5)
    )
    ([Tren_Niz_Flo] of Tren
        (medio          "Tren")
        (precio         45.0)
        (duracion_horas 3.5)
    )
    ([Tren_Rom_Flo] of Tren
        (medio          "Tren")
        (precio         40.0)
        (duracion_horas 1.5)
    )
    ([Tren_Flo_Mun] of Tren
        (medio          "Tren")
        (precio         65.0)
        (duracion_horas 4.0)
    )
    ([Tren_Ber_Mun] of Tren
        (medio          "Tren")
        (precio         55.0)
        (duracion_horas 4.5)
    )
    ([Avion_Mad_Ber] of Avion
        (medio          "Avion")
        (precio         100.0)
        (duracion_horas 2.5)
    )

;;; ------------------------------------------------------------
;;; USUARIO DE EJEMPLO
;;; ------------------------------------------------------------

    ([UsuarioEjemplo] of Usuario
        (nombre_usuario     "Javier")
        (edad               35)
        (nivel_cultural     "Medio")
        (acompanyants       "Pareja")
        (motivo_viaje       "Bodas")
        (presupuesto_max    2000.0)
        (dias_min           5)
        (dias_max           10)
        (ciudades_min       2)
        (ciudades_max       4)
        (transporte_odiado  "ninguno")
        (movilidad_reducida FALSE)
        (explorador         5)
    )

)