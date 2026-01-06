
FROM epics-e3-2023:latest

ENV USERNAME gitlab-ci

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY . .

ENV PATH="/home/${USERNAME}/epics/base-7.0.7/require/5.0.0/bin:${PATH}"

WORKDIR /home/${USERNAME}/cmds

# RUN source ../epics/base-7.0.7/require/5.0.0/bin/setE3Env.bash

# RUN iocsh mainIOC.cmd
