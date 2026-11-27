#Requires -Version 5.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Valideert de gezondheid en configuratie van de Familie Kuipers webfarm.

.DESCRIPTION
Controleert of één of meerdere webservers correct functioneren na een
deployment of configuratiewijziging.

De volgende onderdelen worden gecontroleerd:

- DNS-resolutie
- HTTPS-beschikbaarheid
- HTTP statuscodes
- MTA-STS beschikbaarheid
- Ping-connectiviteit
- Web Deploy connectiviteit
- IIS Sites
- IIS Application Pools

Alle resultaten worden vastgelegd in een logbestand onder:

C:\Deploy\Logs

Bij één of meer fouten wordt automatisch een waarschuwing verstuurd per
e-mail via de geconfigureerde interne SMTP-server. Het logbestand wordt als
bijlage meegestuurd.

Deze controle wordt normaal uitgevoerd na een deployment vanuit
FamWeb1 naar één of meerdere replica-webservers.

.PARAMETER None
Dit script accepteert momenteel geen parameters.

.LINK
https://github.com/familie-kuipers

.EXAMPLE
.\Verify-WebFarm.ps1

Voert alle controles uit en toont direct het resultaat op het scherm.

.EXAMPLE
powershell.exe -ExecutionPolicy Bypass `
    -File C:\Deploy\Scripts\Verify-WebFarm.ps1

Geschikt voor gebruik vanuit een Scheduled Task of deployment pipeline.
.INPUTS
[IISWebFarmSettings]

.OUTPUTS
[IISWebFarmResult]
Complete verification result for all servers,
sites, DNS checks and health probes.
.NOTES
Version: 1.0.0.0

Version History:

1: Major revision
   Eerste release van de WebFarm verificatieoplossing.

0: Minor revision
   Geen functionele uitbreidingen.

0: Bug fix release
   Eerste uitgave.

0: Build number
   Initiële build.

Features:

- DNS validatie
- HTTPS validatie
- IIS validatie
- Web Deploy validatie
- MTA-STS validatie
- Logging naar bestand
- E-mailnotificaties bij fouten
- Logbestand als bijlage

Author:
JP Kuipers

Project:
Familie Kuipers Web Platform

Log Location:
C:\Deploy\Logs

Configuration:
C:\Deploy\mailsettings.txt

Last Updated:
2026-11-25

License:
MIT License
#>
