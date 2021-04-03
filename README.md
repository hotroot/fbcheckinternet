# HomeMatic FRITZ!Box Internet Check Addon
Dieses Addon ersetzt das Skript `/bin/checkInternet` in der CCU2/CCU3/RaspberryMatic. Das Originalskript fragt verschiedene öffentliche Endpunkte ab um zu entscheiden, ob eine Verbindung zum Internet besteht oder nicht. Das in diesem Addon enthaltene Skript fragt den Status der Internetverbindung per UPnP von der FRITZ!Box ab. Besteht eine Internetverbindung wird die Status-Datei `/var/status/hasInternet` angelegt, besteht keine Internet-Verbindung wird die Status-Datei gelöscht, genau wie beim Original-Skript.

Zusätzlich wird die Systemvariable "FRITZ!Box Status Internetverbindung" angelegt und auf den entsprechenden Status gesetzt, sodass der Status der Internetverbindung auch in Programmen genutzt werden kann.

Auf der CCU3/RaspberryMatic wird das Skript durch den Daemon hss_led automatisch alle 3 Minuten aufgerufen. Auf der CCU2 wird durch das Addon ein entsprechende Cron-Job angelegt

## Voraussetzungen:
- FRITZ!Box mit aktiviertem UPnP ("Heimnetz" > "Netzwerk" > "Netzwerkeinstellungen": "Statusinformationen über UPnP übertragen")
- CCU2, CCU3 oder RaspberryMatic

## Installation:
- Addon herunterladen und auf der CCU installieren.
