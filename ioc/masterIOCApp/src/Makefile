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
LIBRARY_IOC += masterIOCSupport

# Compile and add code to the support library
masterIOCSupport_SRCS += xxxRecord.c
masterIOCSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
masterIOCSupport_SRCS += dbSubExample.c
masterIOCSupport_SRCS += devmasterIOCVersion.c
masterIOCSupport_SRCS += masterIOCHello.c
masterIOCSupport_SRCS += initTrace.c

masterIOCSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = masterIOCVersion.h
# Macro name
GENVERSIONMACRO = masterIOCVERSION

# Build the IOC application
PROD_IOC = masterIOC

# masterIOC.dbd will be created and installed
DBD += masterIOC.dbd

# masterIOC.dbd will include these files:
masterIOC_DBD += base.dbd
masterIOC_DBD += xxxSupport.dbd
masterIOC_DBD += dbSubExample.dbd
masterIOC_DBD += devmasterIOCVersion.dbd
masterIOC_DBD += masterIOCHello.dbd
masterIOC_DBD += initTrace.dbd

# masterIOC_registerRecordDeviceDriver.cpp derives from masterIOC.dbd
masterIOC_SRCS += masterIOC_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
masterIOC_SRCS_DEFAULT += masterIOCMain.cpp
masterIOC_SRCS_vxWorks += -nil-

# Link in the code from our support library
masterIOC_LIBS += masterIOCSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into masterIOCSupport
    sncExample_SNCFLAGS += +r
    masterIOC_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    masterIOCSupport_SRCS += sncExample.stt
    masterIOCSupport_LIBS += seq pv
    masterIOC_LIBS += seq pv

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
    masterIOC_LIBS += qsrv
    masterIOC_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    masterIOC_DBD += PVAServerRegister.dbd
    masterIOC_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
masterIOC_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devmasterIOCVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
