#!/bin/bash

function usage()
{
    cat << EOUSAGE
Usage: ssh-to.sh [-u <SERVER_USER>] [-p <SERVER_PORT>] <SERVER_NAME>
       -u specify server user
       -p specify server port
EOUSAGE
}

# Name-to-ip mapping file
THIS_FOLDER="${0%/*}"
IP_MAP_FILE="${THIS_FOLDER}/map-name-to-ip.sh"

SERVER_USER=""
SERVER_PORT=""

while getopts ":u:p:" opt
do
    case ${opt} in
        u ) SERVER_USER="${OPTARG}"
            ;;
        p ) SERVER_PORT="${OPTARG}"
            ;;
        ? ) usage
            exit 1
            ;;
    esac
done
shift $((${OPTIND} - 1))

SERVER_NAME=${1}
shift 1

# Get server user name and IP
SERVER_META=`${IP_MAP_FILE} ${SERVER_NAME}`
if [ "${SERVER_META}" = "" ]; then
    echo "[ERROR] Unknown server or wrong parameters."
    usage
    exit 1
fi

# If user or port specifed, modify SERVER_META
if [ "${SERVER_USER}" != "" ]; then
    SERVER_META="${SERVER_META%\ *} ${SERVER_USER}@${SERVER_META#*@}"
fi
if [ "${SERVER_PORT}" != "" ]; then
    SERVER_META="${SERVER_PORT} ${SERVER_META#*\ }"
fi

# Login to server
ssh -p ${SERVER_META}

