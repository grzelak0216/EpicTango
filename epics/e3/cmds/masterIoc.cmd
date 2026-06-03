## Ustawienia środowiskowe
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.20.101 192.168.30.100")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.30.100")

## Ustawienia projektu
epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("IOC_NAME", "MASTER")
epicsEnvSet("REMOTE_IOC", "ROUTER")
epicsEnvSet("REMOTE_IP", "192.168.20.101")

## Ładowanie rekordów
dbLoadRecords("$(TOP)/db/master.db", "IOC=$(IOC_NAME),REMOTE=$(REMOTE_IOC),REMOTE_IP=$(REMOTE_IP)")

iocInit()

dbpf "$(IOC):CONNECTION_STATUS", "1"