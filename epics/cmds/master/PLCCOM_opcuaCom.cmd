require opcua
require s7nodave

# epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "YES")
# epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.0.108")

epicsEnvSet "TOP" "$(E3_CMD_TOP)/.."
epicsEnvSet "PROTOCOL", "opcua"

s7nodaveConfigureIsoTcpPort("PLC_COM", "192.168.0.40", 0, 0, 0)
s7nodaveConfigurePollGroup("PLC_COM", "default", 0, 0)

opcuaSession PLC_COM opc.tcp://192.168.0.40:4840
opcuaSubscription FAST PLC_COM 200

dbLoadRecords("$(TOP)/../db/master/MASTER_ADAPTER.db", "P=$(PROTOCOL)")    
dbLoadRecords("$(TOP)/../db/master/PLCCOM_opcuaData.db", "P=$(PROTOCOL)")
iocInit()

