#!../../bin/linux-x86_64/connectorIOC
< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/connectorIOC.dbd"
connectorIOC_registerRecordDeviceDriver pdbbase

# PVA server
pvaSrvStart

## Load record instances
dbLoadRecords "db/router.db" 
dbLoadRecords "db/connectorIOCVersion.db", "user=glak"

cd "${TOP}/iocBoot/${IOC}"
iocInit

