epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")

cd "${TOP}"

## Fixed: Added local IP to PVA address list
epicsEnvSet("EPICS_PVA_ADDR_LIST", "192.168.20.101 
                                    192.168.30.100 
                                    192.168.10.100 
                                    192.168.10.101 
                                    192.168.10.102")
epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_PVA_BROADCAST_PORT", "5076")
epicsEnvSet("EPICS_PVA_SERVER_PORT", "5075")

## Konfig CA
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.20.101")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_SERVER_PORT", "5064")
epicsEnvSet("EPICS_CA_REPEATER_PORT", "5065")

# ## PVA server start
# pvaSrvStart

## Load record instances
dbLoadRecords "db/router.db" 
dbLoadRecords "db/versionIOC.db", "user=glak"

## Fixed: Correct IP address (was 192.168.30.121, should be 192.168.30.100)
dbLoadRecords "db/remoteConnections.db", "REMOTE_IP=192.168.30.100"
dbLoadRecords "db/pvaBridge.db", "REMOTE_IOC_IP=192.168.30.100"

cd "${TOP}/iocBoot/${IOC}"
iocInit

# pvaLinkConnect("IOC_V2:version")
# pvaLinkConnect("IOC_V2:status")

dbpf "CONNECTION_STATUS", "Connected to 192.168.30.100"