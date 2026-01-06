#!../../bin/linux-x86_64/slaveIOC

#- You may have to change slaveIOC to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/slaveIOC.dbd"
slaveIOC_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/slaveIOCVersion.db", "user=glak"
dbLoadRecords "db/dbSubExample.db", "user=glak"

#- Set this to see messages from mySub
#-var mySubDebug 1

#- Run this to trace the stages of iocInit
#-traceIocInit

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncExample, "user=glak"
