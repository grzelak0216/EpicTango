#!../../bin/linux-x86_64/masterIOC
< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/masterIOC.dbd"
masterIOC_registerRecordDeviceDriver pdbbase

# PVA server
pvaSrvStart

## Load record instances
dbLoadRecords "db/master.db" 
dbLoadRecords "db/masterIOCVersion.db", "user=glak"

cd "${TOP}/iocBoot/${IOC}"
iocInit

