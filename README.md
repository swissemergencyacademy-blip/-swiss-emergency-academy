# Swiss Emergency Academy by Courvoisier – App v0.8

Auf Basis des gespeicherten Flutter-Prototyps v0.7.

Neu in v0.8:
- Themen im Wissen A–Z und in Favoriten öffnen das jeweilige Prototyp-Modul.
- Checklisten werden lokal gespeichert, mit Fehlerbehandlung beim Laden und Speichern.
- Vollständiger Markenname im App-Titel.

Bereits in v0.7:
- Offline-Suche nach Themennamen im Wissen A–Z, mit Löschtaste und Anzeige bei fehlenden Treffern.
- Telefonfunktion behandelt Fehler und zeigt die Nummer zum manuellen Wählen.

## Projekt vorbereiten
Dieses Archiv enthält Flutter-Quellcode. Android- und iOS-Projektordner sind noch nicht enthalten.
Auf einem Rechner mit Flutter im Projektordner ausführen:

```sh
flutter create --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
flutter run
```

## Prüfstatus
Quellcodeänderungen und ZIP-Struktur geprüft. Flutter und Dart stehen in der Bearbeitungsumgebung nicht zur Verfügung; daher kein Build, keine Flutter-Analyse und kein Gerätetest durchgeführt.

Für iPhone-Tests ohne eigenen Mac ist weiterhin ein macOS-Cloud-Build mit Apple-Signierung und TestFlight erforderlich. Es wurde noch kein iOS-Build erstellt.

Medizinische Inhalte und Entscheidungswege sind unveränderte Prototypen und müssen vor realer Nutzung fachlich geprüft und freigegeben werden.


## Bestätigte Apple-Zuordnung (4. Oktober 2026)
- Bundle-ID: `ch.swissemergencyacademybycourvoisier.app`
- App Store Connect App-ID: `6818960059`
- SKU: `SEA-COURVOISIER-001`

`apple_app_config.json` dokumentiert diese Zuordnung. Sie wird von Flutter
nicht automatisch übernommen. Beim Erstellen des iOS-Projekts muss die
Bundle-ID für das Runner-Target in allen Build-Konfigurationen exakt gesetzt
werden. Die bestehende App in App Store Connect weiterverwenden.

Nächster technischer Schritt: iOS-Projekt mit Flutter erzeugen, Bundle-ID
setzen, Apple-Team und Signierung in einer macOS-Build-Umgebung konfigurieren,
Flutter-Analyse und Build durchführen und den signierten Build zu TestFlight
hochladen. Diese Schritte wurden noch nicht ausgeführt.
