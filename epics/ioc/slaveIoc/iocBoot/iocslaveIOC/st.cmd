#!../../bin/linux-x86_64/slaveIOC
< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/slaveIOC.dbd"
slaveIOC_registerRecordDeviceDriver pdbbase

# PVA server
pvaSrvStart

## Load record instances
dbLoadRecords "db/slave.template", "P=IOC3,ID=3"
dbLoadRecords "db/slaveIOCVersion.db", "user=glak"

cd "${TOP}/iocBoot/${IOC}"
iocInit

