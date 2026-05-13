(definstances instances
    ([AptoDuomo_Flo] of Apartamento
         (categoria  "Premium")
         (nombre  "Duomo View Flat")
         (precio_noche  120.0)
    )

    ([AptoEixample_Bcn] of Apartamento
         (categoria  "Estandar")
         (nombre  "Apto Eixample")
         (precio_noche  85.0)
    )

    ([AptoKreuzberg_Ber] of Apartamento
         (categoria  "Estandar")
         (nombre  "Kreuzberg Loft")
         (precio_noche  80.0)
    )

    ([AptoMarais_Paris] of Apartamento
         (categoria  "Estandar")
         (nombre  "Marais Studio")
         (precio_noche  110.0)
    )

    ([AptoMarienplatz_Mun] of Apartamento
         (categoria  "Premium")
         (nombre  "Marienplatz Flat")
         (precio_noche  110.0)
    )

    ([AptoPromenade_Niz] of Apartamento
         (categoria  "Estandar")
         (nombre  "Promenade Apto")
         (precio_noche  95.0)
    )

    ([AptoRetiro_Mad] of Apartamento
         (categoria  "Premium")
         (nombre  "Apto Retiro")
         (precio_noche  100.0)
    )

    ([AptoVaticano_Roma] of Apartamento
         (categoria  "Estandar")
         (nombre  "Vatican Flat")
         (precio_noche  90.0)
    )

    ([ArcoTriunfo_Paris] of Monumento
    )

    ([Avion_Bcn_Par] of Avion
         (tieneFin  [Paris])
         (tieneOrigen  [Barcelona])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  100)
    )

    ([Avion_Mad_Ber] of Avion
         (tieneFin  [Berlin])
         (tieneOrigen  [Madrid])
         (duracion_horas  2.5)
         (medio  "Avion")
         (precio  100.0)
    )

    ([Avion_Par_Rom] of Avion
         (tieneFin  [Roma])
         (tieneOrigen  [Paris])
         (duracion_horas  2.0)
         (medio  "Avion")
         (precio  90.0)
    )

    ([Ayuntamiento_Mun] of Monumento
    )

    ([Barcelona] of Ciudad
         (conectaCon  [Madrid] [Paris])
         (tieneAlojamiento  [AptoEixample_Bcn] [HostalGotic_Bcn] [HotelW_Bcn])
         (tienePOI  [MuseoPicasso_Bcn] [ParqueGuell_Bcn] [SagradaFamilia_Bcn])
         (clima_habitual  "Templado")
         (cluster_tematico  "Mediterranea")
         (nivel_de_vida  1.1)
         (nombre  "Barcelona")
    )

    ([Berlin] of Ciudad
         (conectaCon  [Madrid] [Munich])
         (tieneAlojamiento  [AptoKreuzberg_Ber] [HostalMitte_Ber] [HotelAdlon_Ber])
         (tienePOI  [MuseoPergamo_Ber] [PuertaBrandeburgo_Ber] [Tiergarten_Ber])
         (clima_habitual  "Frio")
         (cluster_tematico  "Cultura Urb")
         (nivel_de_vida  1.3)
         (nombre  "Berlin")
    )

    ([Coliseo_Roma] of Monumento
    )

    ([Duomo_Flo] of Monumento
    )

    ([EnglishGarden_Mun] of Parque
    )

    ([Florencia] of Ciudad
         (conectaCon  [Munich] [Niza] [Roma])
         (tieneAlojamiento  [AptoDuomo_Flo] [HostalArno_Flo] [HotelBrunelleschi_Flo])
         (tienePOI  [Duomo_Flo] [GaleriaUffizi_Flo] [JardinBoboli_Flo])
         (clima_habitual  "Templado")
         (cluster_tematico  "Artistica")
         (nivel_de_vida  1.1)
         (nombre  "Florencia")
    )

    ([GaleriaUffizi_Flo] of Museo
    )

    ([HostalArno_Flo] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Arno Hostel")
         (precio_noche  40.0)
    )

    ([HostalGotic_Bcn] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Gotic")
         (precio_noche  40.0)
    )

    ([HostalIsar_Mun] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Isar Hostel")
         (precio_noche  45.0)
    )

    ([HostalMitte_Ber] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Mitte Hostel")
         (precio_noche  55.0)
    )

    ([HostalMontmartre_Paris] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Montmartre Inn")
         (precio_noche  60.0)
    )

    ([HostalSol_Mad] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Hostal Sol")
         (precio_noche  35.0)
    )

    ([HostalTrastevere_Roma] of Hostal
         (categoria  "3 Estrellas")
         (nombre  "Trastevere Hostel")
         (precio_noche  50.0)
    )

    ([HostalVieux_Niz] of Hostal
         (categoria  "2 Estrellas")
         (nombre  "Vieux Nice Hostel")
         (precio_noche  45.0)
    )

    ([HotelAdlon_Ber] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Adlon")
         (precio_noche  350.0)
    )

    ([HotelBayerischer_Mun] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Bayerischer Hof")
         (precio_noche  330.0)
    )

    ([HotelBrunelleschi_Flo] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Brunelleschi")
         (precio_noche  290.0)
    )

    ([HotelEden_Roma] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Eden")
         (precio_noche  320.0)
    )

    ([HotelNegresco_Niz] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Negresco")
         (precio_noche  280.0)
    )

    ([HotelRitz_Mad] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel Ritz")
         (precio_noche  300.0)
    )

    ([HotelRitz_Paris] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Ritz Paris")
         (precio_noche  400.0)
    )

    ([HotelW_Bcn] of Hotel
         (categoria  "5 Estrellas")
         (nombre  "Hotel W")
         (precio_noche  250.0)
    )

    ([JardinBoboli_Flo] of Parque
    )

    ([Madrid] of Ciudad
         (conectaCon  [Barcelona] [Berlin])
         (tieneAlojamiento  [AptoRetiro_Mad] [HostalSol_Mad] [HotelRitz_Mad])
         (tienePOI  [MuseoPrado_Mad] [PalacioReal_Mad] [ParqueRetiro_Mad])
         (clima_habitual  "Templado")
         (cluster_tematico  "Metropolis")
         (nivel_de_vida  1.0)
         (nombre  "Madrid")
    )

    ([Munich] of Ciudad
         (conectaCon  [Berlin] [Florencia])
         (tieneAlojamiento  [AptoMarienplatz_Mun] [HostalIsar_Mun] [HotelBayerischer_Mun])
         (tienePOI  [Ayuntamiento_Mun] [EnglishGarden_Mun] [MuseoBMW_Mun])
         (clima_habitual  "Frio")
         (cluster_tematico  "Tradicional")
         (nivel_de_vida  1.4)
         (nombre  "Munich")
    )

    ([MuseoBMW_Mun] of Museo
    )

    ([MuseoLouvre_Paris] of Museo
    )

    ([MuseoMatisse_Niz] of Museo
    )

    ([MuseoPergamo_Ber] of Museo
    )

    ([MuseoPicasso_Bcn] of Museo
    )

    ([MuseoPrado_Mad] of Museo
    )

    ([MuseosVaticanos_Roma] of Museo
    )

    ([Niza] of Ciudad
         (conectaCon  [Florencia] [Paris])
         (tieneAlojamiento  [AptoPromenade_Niz] [HostalVieux_Niz] [HotelNegresco_Niz])
         (tienePOI  [MuseoMatisse_Niz] [ParqueColline_Niz] [PaseoIngleses_Niz])
         (clima_habitual  "Calido")
         (cluster_tematico  "Costa")
         (nivel_de_vida  1.2)
         (nombre  "Niza")
    )

    ([PalacioReal_Mad] of Monumento
    )

    ([Paris] of Ciudad
         (conectaCon  [Barcelona] [Niza] [Roma])
         (tieneAlojamiento  [AptoMarais_Paris] [HostalMontmartre_Paris] [HotelRitz_Paris])
         (tienePOI  [ArcoTriunfo_Paris] [MuseoLouvre_Paris] [TorreEiffel_Paris])
         (clima_habitual  "Templado")
         (cluster_tematico  "Metropolis")
         (nivel_de_vida  1.4)
         (nombre  "Paris")
    )

    ([ParqueColline_Niz] of Parque
    )

    ([ParqueGuell_Bcn] of Parque
    )

    ([ParqueRetiro_Mad] of Parque
    )

    ([PaseoIngleses_Niz] of Ocio
    )

    ([PuertaBrandeburgo_Ber] of Monumento
    )

    ([Roma] of Ciudad
         (conectaCon  [Florencia] [Paris])
         (tieneAlojamiento  [AptoVaticano_Roma] [HostalTrastevere_Roma] [HotelEden_Roma])
         (tienePOI  [Coliseo_Roma] [MuseosVaticanos_Roma] [VillaBorghese_Roma])
         (clima_habitual  "Templado")
         (cluster_tematico  "Historica")
         (nivel_de_vida  1.2)
         (nombre  "Roma")
    )

    ([SagradaFamilia_Bcn] of Monumento
    )

    ([Tiergarten_Ber] of Parque
    )

    ([TorreEiffel_Paris] of Monumento
    )

    ([Tren_Bcn_Mad] of Tren
         (tieneFin  [Madrid])
         (tieneOrigen  [Barcelona])
         (duracion_horas  2.5)
         (medio  "AVE")
         (precio  35.0)
    )

    ([Tren_Bcn_Par] of Tren
         (tieneFin  [Paris])
         (tieneOrigen  [Barcelona])
         (duracion_horas  6.5)
         (medio  "Tren")
         (precio  60)
    )

    ([Tren_Ber_Mun] of Tren
         (tieneFin  [Munich])
         (tieneOrigen  [Berlin])
         (duracion_horas  4.5)
         (medio  "Tren")
         (precio  55.0)
    )

    ([Tren_Flo_Mun] of Tren
         (tieneFin  [Munich])
         (tieneOrigen  [Florencia])
         (duracion_horas  4.0)
         (medio  "Tren")
         (precio  65.0)
    )

    ([Tren_Mad_Ber] of Tren
         (tieneFin  [Berlin])
         (tieneOrigen  [Madrid])
         (duracion_horas  10.0)
         (medio  "Tren")
         (precio  90.0)
    )

    ([Tren_Niz_Flo] of Tren
         (tieneFin  [Florencia])
         (tieneOrigen  [Niza])
         (duracion_horas  3.5)
         (medio  "Tren")
         (precio  45.0)
    )

    ([Tren_Par_Niz] of Tren
         (tieneFin  [Niza])
         (tieneOrigen  [Paris])
         (duracion_horas  5.5)
         (medio  "Tren")
         (precio  50.0)
    )

    ([Tren_Rom_Flo] of Tren
         (tieneFin  [Florencia])
         (tieneOrigen  [Roma])
         (duracion_horas  1.5)
         (medio  "Tren")
         (precio  40.0)
    )

    ([VillaBorghese_Roma] of Parque
    )

)
