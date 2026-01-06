# FROM centos:7.7.1908
FROM registry.esss.lu.se/ics-docker/centos-e3
# RUN yum-config-manager --add-repo=https://artifactory.esss.lu.se/artifactory/rpm-ics/centos/7/x86_64/

# RUN echo "gpgcheck = 0" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo \
#   && echo "gpgkey = https://artifactory.esss.lu.se/artifactory/rpm-ics/RPM-GPG-KEY-ICS" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo \
#   && echo "repo_gpgcheck = 1" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo

# RUN yum-config-manager --add-repo=https://artifactory.esss.lu.se/artifactory/epel-mirror/7/x86_64/

# RUN echo "gpgcheck = 1" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo \
#   && echo "gpgkey = https://artifactory.esss.lu.se/artifactory/epel-mirror/RPM-GPG-KEY-EPEL-7" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo \
#   && echo "repo_gpgcheck = 0" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo


# RUN yum update -y \
#   # Use IUS repository to install recent version of git (git2u)
#     && yum -y install  https://repo.ius.io/ius-release-el7.rpm \
#   && yum install -y \
#  file \
#     patch \
#     tree \
#     vim \
#     m4 \
#     gcc-c++ \
#     make \
#     git \
#     git224-all \
#     expectk \
#     tclx \
#     graphviz \
#     libtirpc-devel \
#     re2c \
#     readline-devel \
#     hdf5-devel \
#     libxml2-devel \
#     libjpeg-turbo-devel \
#     libtiff-devel \
#     blosc-devel \
#     netcdf-devel \
#     opencv-devel \
#     wget \
#     sudo \
#     python-devel \
#     python3-devel \
#     patchelf \
#     boost-devel \
#     glib2-devel \
#     libXt-devel \
#     libXp-devel \
#     libXmu-devel \
#     libXpm-devel \
#     libXp-devel \
#     libpng12-devel \
#     #lesstiff-devel \ Package does not exist, this line is to be deleted.
#     libzip-devel \
#     libusb-devel \
#     libusbx-devel \
#     libudev-devel \
#     gsl-devel \
#     unzip \
#     libtool \
#     popt-devel \
#     net-snmp-devel \
#     faketime \
#     libraw1394 \
#     bzip2-devel \
#     freetype-devel \
#     lcms2-devel \
#     ethercat-generic-dkms-1.5.2.ESS1-1 \
#   && yum clean all

# # cross-compiler version
# ENV E3_CROSS_COMPILER_VERSION=v0.0.25 \
#     E3_CROSS_COMPILER_KERNEL=2.6-4.14 \
#     E3_CROSS_COMPILER_SHORT_SHA=a905a95a

# # Install ifc14xx toolchain
# ENV IFC14XX_TOOLCHAIN_SCRIPT ifc14xx-glibc-x86_64-ifc14xx-toolchain-ppc64e6500-toolchain-${E3_CROSS_COMPILER_KERNEL}-${E3_CROSS_COMPILER_SHORT_SHA}.sh
# RUN wget --quiet -P /tmp https://artifactory.esss.lu.se/artifactory/yocto/toolchain/${E3_CROSS_COMPILER_VERSION}/${IFC14XX_TOOLCHAIN_SCRIPT} \
#   && chmod a+x /tmp/${IFC14XX_TOOLCHAIN_SCRIPT} \
#   && /tmp/${IFC14XX_TOOLCHAIN_SCRIPT} -y \
#   && rm -f /tmp/${IFC14XX_TOOLCHAIN_SCRIPT}

# # Install cct toolchain
# ENV CCT_TOOLCHAIN_SCRIPT cct-glibc-x86_64-cct-toolchain-corei7-64-toolchain-${E3_CROSS_COMPILER_KERNEL}-${E3_CROSS_COMPILER_SHORT_SHA}.sh
# RUN wget --quiet -P /tmp https://artifactory.esss.lu.se/artifactory/yocto/toolchain/${E3_CROSS_COMPILER_VERSION}/${CCT_TOOLCHAIN_SCRIPT} \
#   && chmod a+x /tmp/${CCT_TOOLCHAIN_SCRIPT} \
#   && /tmp/${CCT_TOOLCHAIN_SCRIPT} -y \
#   && rm -f /tmp/${CCT_TOOLCHAIN_SCRIPT}


# # Install google git repo
# RUN wget -O /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
#   && chmod a+x /usr/local/bin/repo

ENV USERNAME gitlab-ci
RUN git --version

# RUN git config --global user.name ${USERNAME} \
#   && git config --global user.email ${USERNAME}@localhost.localdomain \
#   && git config --global color.ui auto

# # Install python packages
# RUN python3 -m pip install --no-cache-dir --upgrade pip && \
#     python3 -m pip install --no-cache-dir pyyaml && \
#     python3 -m pip install --no-cache-dir e3 -i https://artifactory.esss.lu.se/artifactory/api/pypi/pypi-virtual/simple && \
#     python3 -m pip install --no-cache-dir run-iocsh -i https://artifactory.esss.lu.se/artifactory/api/pypi/pypi-virtual/simple && \
#     python3 -m pip install --no-cache-dir pytest && \
#     python3 -m pip install --no-cache-dir pyepics==3.5.0 && \
#     python3 -m pip install --no-cache-dir opcua && \
#     python3 -m pip install --no-cache-dir pymodbus

# Add user that will be used by gitlab-ci to compile
# This user shall have the proper uid to have write access on E3 NFS share
# It shall match the uid and gid of the user defined in LDAP
# RUN groupadd -r -g 100000 ${USERNAME} \
#   && useradd --no-log-init -r -m -g ${USERNAME} -u 10043 ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN pip3 install --user e3 -i https://artifactory.esss.lu.se/artifactory/api/pypi/pypi-virtual/simple
RUN git clone https://gitlab.esss.lu.se/e3/specifications.git
RUN e3-build -t /home/${USERNAME}/epics ./specifications/specifications/2023q1.yml -y

COPY . .

#RUN source /epics/base-7.0.6.1/require/4.0.0/bin/setE3Env.bash
#RUN iocsh -r s7plc
