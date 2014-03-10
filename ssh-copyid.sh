#!/bin/bash

function usage()
{
    cat << EOUSAGE
Usage: ssh-copy-id-to.sh [-i <IDENTITY_FILE>] [-u <SERVER_USER>] [-p <SERVER_PORT>] <SERVER_NAME>
       -i specify ssh identity file
       -u specify server user
       -p specify server port
EOUSAGE
}

# Name-to-ip mapping file
THIS_FOLDER="${0%/*}"
IP_MAP_FILE="${THIS_FOLDER}/map-name-to-ip.sh"

IDENTITY_FILE=`ls ${HOME}/.ssh/id_[rd]sa.pub | head -1`
SERVER_USER=""
SERVER_PORT=""

while getopts ":i:u:p:" opt
do
    case ${opt} in
        i ) IDENTITY_FILE=${OPTARG}
            ;;
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

# Check identify file exist and not empty
if [ "${IDENTITY_FILE}" == "" ]; then
    echo "[ERROR] Cannot find identity file."
    usage
    exit 1
fi
PUB_CREDENCE=`cat ${IDENTITY_FILE}`
if [ "${PUB_CREDENCE}" == "" ]; then
    echo "[ERROR] No identities found in ${IDENTITY_FILE}"
    exit 1
fi

# Copy identity key to server
echo ${PUB_CREDENCE} | ssh -p ${SERVER_META} "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys" || exit 1

# Done
echo "[Done] Now try login into the machine with \"ssh-to.sh ${SERVER_NAME}\""

