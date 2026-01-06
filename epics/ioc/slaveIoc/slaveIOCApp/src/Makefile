TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# xxxRecord.h will be created from xxxRecord.dbd
DBDINC += xxxRecord

# Install xxxSupport.dbd into <top>/dbd
DBD += xxxSupport.dbd

# Build an IOC support library
LIBRARY_IOC += slaveIOCSupport

# Compile and add code to the support library
slaveIOCSupport_SRCS += xxxRecord.c
slaveIOCSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
slaveIOCSupport_SRCS += dbSubExample.c
slaveIOCSupport_SRCS += devslaveIOCVersion.c
slaveIOCSupport_SRCS += slaveIOCHello.c
slaveIOCSupport_SRCS += initTrace.c

slaveIOCSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = slaveIOCVersion.h
# Macro name
GENVERSIONMACRO = slaveIOCVERSION

# Build the IOC application
PROD_IOC = slaveIOC

# slaveIOC.dbd will be created and installed
DBD += slaveIOC.dbd

# slaveIOC.dbd will include these files:
slaveIOC_DBD += base.dbd
slaveIOC_DBD += xxxSupport.dbd
slaveIOC_DBD += dbSubExample.dbd
slaveIOC_DBD += devslaveIOCVersion.dbd
slaveIOC_DBD += slaveIOCHello.dbd
slaveIOC_DBD += initTrace.dbd

# slaveIOC_registerRecordDeviceDriver.cpp derives from slaveIOC.dbd
slaveIOC_SRCS += slaveIOC_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
slaveIOC_SRCS_DEFAULT += slaveIOCMain.cpp
slaveIOC_SRCS_vxWorks += -nil-

# Link in the code from our support library
slaveIOC_LIBS += slaveIOCSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into slaveIOCSupport
    sncExample_SNCFLAGS += +r
    slaveIOC_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    slaveIOCSupport_SRCS += sncExample.stt
    slaveIOCSupport_LIBS += seq pv
    slaveIOC_LIBS += seq pv

    # Build sncProgram as a standalone program
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    # A .st sequence program *is* pre-processed:
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    slaveIOC_LIBS += qsrv
    slaveIOC_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    slaveIOC_DBD += PVAServerRegister.dbd
    slaveIOC_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
slaveIOC_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devslaveIOCVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
