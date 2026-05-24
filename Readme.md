# Sistema Expert de Viatges en CLIPS

Aquest projecte implementa un sistema expert basat en regles utilitzant CLIPS per recomanar viatges personalitzats segons les preferències i restriccions de l'usuari.

## Requisits previs

- Tenir instal·lat **CLIPS**.
- Assegurar-se que l'executable de CLIPS està disponible al PATH del sistema, o bé modificar la variable `CLIPS` dins del `Makefile` apuntant a la ruta correcta de l'executable (per defecte està configurat com `CLIPS = clips`).
- Sistema Unix/Linux o utilitat `make` instal·lada per poder utilitzar les regles del `Makefile` inclòs.

## Com executar el codi

El projecte inclou un fitxer `Makefile` dissenyat per simplificar al màxim l'execució i proves del codi. Obre un terminal a la carpeta arrel del projecte i utilitza les següents comandes segons allò que necessitis fer.

### Execució normal (Interactiva)

Per iniciar el sistema expert de forma interactiva, on et farà preguntes directament per consola per esbrinar les teves preferències, utilitza:

```bash
make run