#!../../bin/linux-x86_64/connectorIOC
< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/connectorIOC.dbd"
connectorIOC_registerRecordDeviceDriver pdbbase

## Konfiguracja PVA dla komunikacji z IOC_v2 (192.168.30.121)
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.30.121")
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

## Konfiguracja dla IOC_v1 (lokalny adres)
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.10.105 192.168.30.121")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_SERVER_PORT", "5064")
epicsEnvSet("EPICS_CA_REPEATER_PORT", "5065")

## PVA server start
pvaSrvStart

## Load record instances
dbLoadRecords "db/router.db" 
dbLoadRecords "db/versionIOC.db", "user=glak"

## Konfiguracja channel access client dla komunikacji z IOC_v2
dbLoadRecords "db/remoteConnections.db", "REMOTE_IP=192.168.30.121"

## Definicje PV dla komunikacji PVA
dbLoadRecords "db/pvaBridge.db", "IOC_V2=192.168.30.121"

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Po inicjalizacji - ustawienia dodatkowe
# Utworzenie połączeń PVA z IOC_v2
pvaLinkConnect("IOC_V2:version")
pvaLinkConnect("IOC_V2:status")

## Monitorowanie połączeń
dbpf "CONNECTION_STATUS", "Connected to 192.168.30.121"