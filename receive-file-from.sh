#!/bin/bash

function usage()
{
    cat << EOUSAGE
Usage: receive-file-from.sh [-f <FOLDER_TO_STORE>] [-u <SERVER_USER>] [-p <SERVER_PORT>] [-d] <SERVER_NAME> FILE1 [FILE2 ..]
       -f specify local folder to receive files
       -u specify server user
       -p specify server port
       -d delete files on server after transfer finish
EOUSAGE
}

# Name-to-ip mapping file
THIS_FOLDER="${0%/*}"
IP_MAP_FILE="${THIS_FOLDER}/map-name-to-ip.sh"

TARGET_PATH="./"
SERVER_USER=""
SERVER_PORT=""
declare -i DELETE_AFTER_CP=0

while getopts ":f:u:p:d" opt
do
    case ${opt} in
        f ) TARGET_PATH="${OPTARG}"
            ;;
        u ) SERVER_USER="${OPTARG}"
            ;;
        p ) SERVER_PORT="${OPTARG}"
            ;;
        d ) DELETE_AFTER_CP=1
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
if [ "${SERVER_META}" == "" ]; then
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

# Check parameters
if [ ${#} -eq 0 ]; then
    echo "[ERROR] Please specify file to transfer."
    exit -1
fi

# Generate file list
FILE_DEL_LIST=""
FILE_LIST="${SERVER_META%%\ *}" # put server port first
for FILE in $@; do
    FILE_DEL_LIST="${FILE} ${FILE_DEL_LIST}"
    FILE_LIST="${FILE_LIST} ${SERVER_META#*\ }:${FILE}"
done

# If TARGET_PATH is not end with a '/', attach one
TARGET_PATH="${TARGET_PATH%/}/"

# Receive file from server
echo ">> Receiving files from server ${SERVER_NAME} .."
scp -P ${FILE_LIST} ${TARGET_PATH}

# Delete tranfered files from server
if [ ${DELETE_AFTER_CP} -eq 1 ]; then
    echo ">> Deleting files after received.. ${FILE_DEL_LIST}"
    ssh -p ${SERVER_META} "rm -f ${FILE_DEL_LIST}"
fi

