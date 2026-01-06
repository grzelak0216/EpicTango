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
LIBRARY_IOC += connectorIOCSupport

# Compile and add code to the support library
connectorIOCSupport_SRCS += xxxRecord.c
connectorIOCSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
connectorIOCSupport_SRCS += dbSubExample.c
connectorIOCSupport_SRCS += devconnectorIOCVersion.c
connectorIOCSupport_SRCS += connectorIOCHello.c
connectorIOCSupport_SRCS += initTrace.c

connectorIOCSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = connectorIOCVersion.h
# Macro name
GENVERSIONMACRO = connectorIOCVERSION

# Build the IOC application
PROD_IOC = connectorIOC

# connectorIOC.dbd will be created and installed
DBD += connectorIOC.dbd

# connectorIOC.dbd will include these files:
connectorIOC_DBD += base.dbd
connectorIOC_DBD += xxxSupport.dbd
connectorIOC_DBD += dbSubExample.dbd
connectorIOC_DBD += devconnectorIOCVersion.dbd
connectorIOC_DBD += connectorIOCHello.dbd
connectorIOC_DBD += initTrace.dbd

# connectorIOC_registerRecordDeviceDriver.cpp derives from connectorIOC.dbd
connectorIOC_SRCS += connectorIOC_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
connectorIOC_SRCS_DEFAULT += connectorIOCMain.cpp
connectorIOC_SRCS_vxWorks += -nil-

# Link in the code from our support library
connectorIOC_LIBS += connectorIOCSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into connectorIOCSupport
    sncExample_SNCFLAGS += +r
    connectorIOC_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    connectorIOCSupport_SRCS += sncExample.stt
    connectorIOCSupport_LIBS += seq pv
    connectorIOC_LIBS += seq pv

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
    connectorIOC_LIBS += qsrv
    connectorIOC_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    connectorIOC_DBD += PVAServerRegister.dbd
    connectorIOC_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
connectorIOC_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devconnectorIOCVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
