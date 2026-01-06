FROM epics-e3-2023:latest

ENV USERNAME gitlab-ci

USER ${USERNAME}
WORKDIR /home/${USERNAME} 

ENV PATH="/home/${USERNAME}/epics/base-7.0.7/require/5.0.0/bin:${PATH}"

WORKDIR /home/${USERNAME}/cmds/virtual

ENV IOC_NUMBER 1
ENV EPICS_CA_ADDRESS 192.168.0.108

RUN cp ./DUMMYIOC_ca_example.cmd /tmp/DUMMYIOC_ca_example.cmd && \
    sed -i "s/{{EPICS_CA_ADDRESS}}/$EPICS_CA_ADDRESS/g" /tmp/DUMMYIOC_ca_example.cmd && \
    sed -i "s/{{IOC_NUMBER}}/$IOC_NUMBER/g" /tmp/DUMMYIOC_ca_example.cmd && \
    cp /tmp/DUMMYIOC_ca_example.cmd .

RUN echo 'root:Docker!' | chpasswd

# RUN source ../epics/base-7.0.7/require/5.0.0/bin/setE3Env.bash

# RUN iocsh dummyIOC.cmd
