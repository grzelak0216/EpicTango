## Konfig PVA
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.20.101 192.168.30.100")
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

## Konfig CA
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.20.101")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_SERVER_PORT", "5064")
epicsEnvSet("EPICS_CA_REPEATER_PORT", "5065")

## Load record instances
dbLoadRecords "~/EpicTango/epics/e3/db//router.db"

iocInit

dbpf "CONNECTION_STATUS", "1"