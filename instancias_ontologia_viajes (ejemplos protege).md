# Instancias de ejemplo — Ontología de Viajes SBC

Estas instancias son las que se introducen en Protégé como **Individuals** para documentar la ontología. Representan un ejemplo de cada cluster y subclase.

---

## Clase: Ciudad

| Individual | `nombre` | `cluster_tematico` | `nivel_de_vida` | `clima_habitual` |
|---|---|---|---|---|
| `Paris` | "Paris" | "Metropolis_Europea" | 1.4 | "Templado" |
| `Barcelona` | "Barcelona" | "Mediterranea" | 1.1 | "Templado" |
| `BuenosAires` | "BuenosAires" | "Sudamerica" | 0.7 | "Templado" |
| `Tokio` | "Tokio" | "Asiatica" | 1.3 | "Templado" |

---

## Clase: Alojamiento

| Individual | `nombre` | `ciudad` | `categoria` | `precio_noche` | `tipo` |
|---|---|---|---|---|---|
| `HotelLumiereParis` | "Hotel Lumiere Paris" | "Paris" | 4 | 180.0 | "Hotel" |
| `HotelMontmartreParis` | "Hotel Montmartre Paris" | "Paris" | 3 | 110.0 | "Hotel" |
| `AppSeineParis` | "Appart Seine Paris" | "Paris" | 2 | 70.0 | "Apartamento" |
| `HotelEixampleBCN` | "Hotel Eixample BCN" | "Barcelona" | 3 | 95.0 | "Hotel" |
| `HotelRecoletaBA` | "Hotel Recoleta BA" | "BuenosAires" | 3 | 70.0 | "Hotel" |
| `HostalPalermoBA` | "Hostal Palermo BA" | "BuenosAires" | 2 | 30.0 | "Hostal" |
| `HotelShinjukuTokio` | "Hotel Shinjuku Tokio" | "Tokio" | 4 | 175.0 | "Hotel" |

> **Nota:** El campo `tipo` puede asignarse también como subclase directa (`Hotel`, `Hostal`, `Apartamento`) desde el panel **Types** en Protégé, además del valor string en la data property.

---

## Clase: PuntoDeInteres

| Individual | `nombre` | `ciudad` | `tipo` (subclase) | `importancia` |
|---|---|---|---|---|
| `Louvre` | "Louvre" | "Paris" | `Museo` | 10 |
| `TorreEiffel` | "Torre Eiffel" | "Paris" | `Monumento` | 10 |
| `MontmartreBarrio` | "Montmartre" | "Paris" | `Ocio` | 7 |
| `SagradaFamilia` | "Sagrada Familia" | "Barcelona" | `Monumento` | 10 |
| `ParkGuell` | "Park Guell" | "Barcelona" | `Parque` | 9 |
| `LaBoca` | "La Boca" | "BuenosAires" | `Ocio` | 9 |
| `TemploSensoji` | "Templo Senso-ji" | "Tokio" | `Monumento` | 10 |
| `ShibuyaCrossing` | "Shibuya Crossing" | "Tokio" | `Ocio` | 9 |

> **Nota:** Asigna la subclase (`Museo`, `Monumento`, `Ocio`, `Parque`) en el panel **Types** del individual además de la clase padre `PuntoDeInteres`.

---

## Clase: Transporte

| Individual | `origen` | `destino` | `medio` (subclase) | `precio` | `horas` |
|---|---|---|---|---|---|
| `AvionParisLondres` | "Paris" | "Londres" | `Avion` | 120.0 | 1.5 |
| `TrenParisBarcelona` | "Paris" | "Barcelona" | `Tren` | 60.0 | 6.5 |
| `AvionParisBarcelona` | "Paris" | "Barcelona" | `Avion` | 80.0 | 1.5 |
| `TrenBerlinViena` | "Berlin" | "Viena" | `Tren` | 70.0 | 4.0 |
| `AvionMadridBuenosAires` | "Madrid" | "BuenosAires" | `Avion` | 650.0 | 13.0 |
| `AvionMadridTokio` | "Madrid" | "Tokio" | `Avion` | 750.0 | 14.0 |

> **Nota:** Asigna la subclase (`Avion`, `Tren`, `Autobus`, `Barco`) en el panel **Types** del individual además de la clase padre `Transporte`.

---

## Clase: Usuario (individual de ejemplo)

| Individual | `edad` | `acompaniantes` | `motivo_viaje` | `presupuesto_max` | `dias_min` | `dias_max` | `transporte_odiado` |
|---|---|---|---|---|---|---|---|
| `UsuarioEjemplo` | 35 | "Pareja" | "Boda" | 2000.0 | 5 | 10 | "ninguno" |

---

## Resumen de valores permitidos por propiedad

| Propiedad | Valores posibles |
|---|---|
| `cluster_tematico` | Metropolis_Europea, Mediterranea, Sudamerica, Asiatica |
| `clima_habitual` | Frio, Templado, Tropical |
| `tipo` (Alojamiento) | Hotel, Hostal, Apartamento |
| `tipo` (PuntoDeInteres) | Cultural, Monumento, Ocio, Parque, Museo |
| `medio` (Transporte) | Avion, Tren, Autobus, Barco |
| `acompaniantes` | Solo, Pareja, Familia_con_ninos, Grupo_amigos |
| `motivo_viaje` | Boda, Fin_curso, Vacaciones_estandar, Trabajo |
