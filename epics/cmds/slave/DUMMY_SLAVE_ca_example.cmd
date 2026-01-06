epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "YES")
epicsEnvSet("EPICS_CA_ADDR_LIST", "192.168.0.106")

epicsEnvSet "TOP" "$(E3_CMD_TOP)/.."
epicsEnvSet "IOCNUMBER" "2"
# epicsEnvSet "PROTOCOL" "s7nodave"
epicsEnvSet "PROTOCOL" "s7plc"
# epicsEnvSet "PROTOCOL" "opcua"

dbLoadRecords("$(TOP)/../../db/slave/dummyproc/DUMMY_SLAVE_example.db", "P=$(IOCNUMBER),R=$(PROTOCOL)")
iocInit()
