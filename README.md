# HomeMatic FRITZ!Box Internet Check Addon
Dieses Addon fragt den Status der Internetverbindung direkt bei der FRITZ!Box über UPnP ab und bildet den Status in einer Systemvariable (FRITZ!Box Status Internetverbindung) ab. Zusätzlich wird die Status-Datei `/var/status/hasInternetFritzBox` angelegt wenn eine Internetverbindung besteht. Die Datei wird wieder gelöscht, wenn keine Internetverbindung besteht. Das Addon legt dazu bei der Installation einen Cron-Job an, der das enthaltene Skript alle drei Minuten ausführt und die Systemvariable ggf. aktualisiert.
Für RaspberryMatic ist zusätzlich noch ein Monit-Check enthalten. Analog zur Originalkonfiguration wird die Datei `/var/status/hasInternetFritzBox` überwacht und bei fehlender Internetverbindnug wird eine Alarmmeldung erzeugt.

Ohne Benutzereingriff nimmt das Addon keine Veränderungen am System vor. Falls es vom Benutzer gewünscht ist, kann das Addon jedoch auch den eingebauten Internet-Check `/bin/checkInternet` vollständig ersetzten. Dazu muss eine leere Datei mit dem Namen `/etc/config/fbReplaceCheckInternet` angelegt werden und das Addon einmal neugestartet werden. Dabei wird dann das eingebaute `/bin/checkInternet` durch einen Symlink auf das im Addon enthaltene Skript ersetzt. Der periodischen Aufruf des Skripts übernimmt auf der CCU3/RaspberryMatic dann der Daemon hss_led. Der eingerichtete Cron-Job wird entfernt. Auf der CCU2 wird `/bin/checkInternet` nicht periodisch durch den Daemon hss_led ausgeführt. Daher bleibt der Cron-Job hier bestehen. Wenn das Addon den eingebauten Internet-Check `/bin/checkInternet` ersetzt, wird  die Status-Datei `/var/status/hasInternetFritzBox` nicht mehr gepflegt, sondern die Original-Datei `/var/status/hasInternet`. Die Datei `/var/status/hasInternetFritzBox` wird gelöscht.

## Voraussetzungen:
- FRITZ!Box mit aktiviertem UPnP ("Heimnetz" > "Netzwerk" > "Netzwerkeinstellungen": "Statusinformationen über UPnP übertragen")
- CCU2, CCU3 oder RaspberryMatic

## Installation:
- Addon [herunterladen](https://github.com/hotroot/fbcheckinternet/releases) und auf der CCU installieren.

## `/bin/checkInternet` ersetzten
- per SSH:
```
# touch /etc/config/fbReplaceCheckInternet
# /etc/config/rc.d/fbcheckinternet restart
```

- per Skript testen:
```
string stderr;
string stdout;
system.Exec("touch /etc/config/fbReplaceCheckInternet", &stdout, &stderr); 
```
Anschließend kann das Addon über den Punkt Zusatzsoftware in der Systemsteuerung neugestartet werden. Alternativ kann auch die CCU neugestartet werden.

## `/bin/checkInternet` wiederherstellen
- per SSH:
```
# rm /etc/config/fbReplaceCheckInternet
# /etc/config/rc.d/fbcheckinternet restart
```

- per Skript testen:
```
string stderr;
string stdout;
system.Exec("rm /etc/config/fbReplaceCheckInternet", &stdout, &stderr); 
```
Anschließend kann das Addon über den Punkt Zusatzsoftware in der Systemsteuerung neugestartet werden. Alternativ kann auch die CCU neugestartet werden.
