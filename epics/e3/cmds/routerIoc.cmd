## Ustawienia środowiskowe
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.20.101 192.168.30.100")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.20.101")

## Ustawienia projektu - definiujemy zmienne przed użyciem
epicsEnvSet("IOC_NAME", "ROUTER")
epicsEnvSet("REMOTE_IOC", "MASTER")
epicsEnvSet("REMOTE_IP", "192.168.30.100")

## Ładowanie rekordów - używamy ścieżki względnej
dbLoadRecords("../db/router.db", "IOC=ROUTER,REMOTE=MASTER,REMOTE_IP=192.168.30.100")

iocInit()

dbpf "ROUTER:CONNECTION_STATUS", "1"