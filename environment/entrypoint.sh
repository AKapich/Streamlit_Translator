#!/bin/bash

. /opt/conda/etc/profile.d/conda.sh
conda activate prod

#!/bin/bash

APP_PID=
stopRunningProcess() {
    # Based on https://linuxconfig.org/how-to-propagate-a-signal-to-child-processes-from-a-bash-script
    if test ! "${APP_PID}" = '' && ps -p ${APP_PID} > /dev/null ; then
       > /proc/1/fd/1 echo "Stopping ${COMMAND_PATH} which is running with process ID ${APP_PID}"

       kill -TERM ${APP_PID}
       > /proc/1/fd/1 echo "Waiting for ${COMMAND_PATH} to process SIGTERM signal"

        wait ${APP_PID}
        > /proc/1/fd/1 echo "All processes have stopped running"
    else
        > /proc/1/fd/1 echo "${COMMAND_PATH} was not started when the signal was sent or it has already been stopped"
    fi
}

trap stopRunningProcess EXIT TERM

conda activate ${VIRTUAL_ENV}

streamlit run ${HOME}/app/mainapp.py &
APP_ID=${!}

wait ${APP_ID}