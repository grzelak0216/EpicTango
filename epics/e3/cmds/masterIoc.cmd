cd "${TOP}"

## Konfig PVA
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.20.101 192.168.30.100")
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

## Konfig CA (local)
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.30.100")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_SERVER_PORT", "5064")
epicsEnvSet("EPICS_CA_REPEATER_PORT", "5065")

## PVA server start - should be after environment setup
pvaSrvStart

## Load record instances
dbLoadRecords "db/router.db" 
dbLoadRecords "db/versionIOC.db", "user=glak"

## Fixed: Correct IP addresses and record names
dbLoadRecords "db/remoteConnections.db", "REMOTE_IP=192.168.20.101"
dbLoadRecords "db/pvaBridge.db", "REMOTE_IOC_IP=192.168.20.101"

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Fixed: Use correct PV names based on your database
pvaLinkConnect("IOC_V2:version")
pvaLinkConnect("IOC_V2:status")

dbpf "CONNECTION_STATUS", "Connected to 192.168.20.101"