# Pràctica de Sistemes Basats en el Coneixement — Planificador de viatges

Implementació d'un sistema basat en el coneixement aplicat al problema de recomanació de viatges a un usuari amb preferencies i restriccions concretes. Pràctica de l'assignatura d'Intel·ligència Artificial.

## El Problema

L'objectiu del sistema és primer fer preguntes i obtenir deduccions que li permetin decidir quin tipus d'usuari té davant, les seves preferències i restriccions, i elaborar amb això el viatge més adequat.

La solució és la recomanació de dos plans de viatge no semblants a l'usuari. En aquesta recomanació es detallen tots els aspectes concrets del viatge:
- Preu total
- Durada del viatge
- Ciutats i dies per ciutat
- Punts d'interès a visitar a la ciutat
- Mitjans de transport entre ciutats
- Tipus d'allotjament

També s'inclou informació sobre les preferències de l'usuari que s'han complert en la solució.

## Requisits
- **CLIPS IDE** versió 6.4 o superior
- `loads.txt` dintre de la carpeta *src*

## Compilació i Execució

```CLIPSIDE
(batch "loads.txt")
```

```CLIPSIDE
(run)
```
