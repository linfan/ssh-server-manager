#!/bin/bash

function usage()
{
cat << EOUSAGE
Usage: ssh-target.sh add <SERVER_NAME> <SERVER_USER> <SERVER_IP> [<SERVER_PORT>]
       ssh-target.sh del <SERVER_NAME>
       ssh-target.sh list
EOUSAGE
}

# Name-to-ip mapping file
THIS_FOLDER="${0%/*}"
IP_MAP_FILE="${THIS_FOLDER}/map-name-to-ip.sh"

# Add a server into server mapping file
function ssh-target-add
{
    if [ ${#} -lt 3 ]; then
        usage
        exit 1
    fi
    SERVER_NAME=${1}
    SERVER_USER=${2}
    SERVER_IP=${3}
    SERVER_PORT=${4}
    if [ "${SERVER_PORT}" == "" ]; then
        SERVER_PORT="22"
    fi
    declare -i EXIST=0

    # Check if record aleady exist
    RES=`grep "SERVER_${SERVER_NAME}_IP" "${IP_MAP_FILE}"`
    if [ "${RES}" != "" ]; then
        EXIST=1
        sed -i "/SERVER_${SERVER_NAME}_IP/d" "${IP_MAP_FILE}"
    fi

    # Add record
    sed -i '/BEGIN_OF_IP_LIST/a'"SERVER_${SERVER_NAME}_IP=\"${SERVER_PORT} ${SERVER_USER}@${SERVER_IP}\"" "${IP_MAP_FILE}"

    # Check result
    RES=`grep "SERVER_${SERVER_NAME}_IP" "${IP_MAP_FILE}" | grep "${SERVER_IP}"`
    if [ "${RES}" == "" ]; then
        echo "[Error] Server add failed!"
    elif [ ${EXIST} -eq 1 ]; then
        echo "[Done] Server ${SERVER_NAME} modified => [${SERVER_USER}] ${SERVER_IP} : ${SERVER_PORT} succeeful."
    else
        echo "[Done] Server ${SERVER_NAME} => [${SERVER_USER}] ${SERVER_IP} : ${SERVER_PORT} added successful."
    fi
}

# Remove a server from server mapping file
function ssh-target-remove
{
    if [ ${#} -lt 1 ]; then
        usage
        exit 1
    fi
    SERVER_NAME=${1}

    # check if record exist
    RES=`grep "SERVER_${SERVER_NAME}_IP" "${IP_MAP_FILE}"`
    if [ "${RES}" == "" ]; then
        echo "[INFO] Server ${SERVER_NAME} not exist."
    else
        # remove record
        sed -i "/SERVER_${SERVER_NAME}_IP/d" "${IP_MAP_FILE}"
        # check result
        RES=`grep "SERVER_${SERVER_NAME}_IP" "${IP_MAP_FILE}"`
        if [ "${RES}" == "" ]; then
            echo "[Done] Server ${SERVER_NAME} removed successful."
        else
            echo "[ERROR] Server remove failed!"
        fi
    fi
}

# List all server record
function ssh-target-list
{
    grep -P "SERVER_[^_]+_IP=" "${IP_MAP_FILE}" | sed -r -e 's/SERVER_([^_]+)_IP=([^ ]+) ([^@]+)@(.+)/\1 \t=> [\3] \t\4 \t: \2/g' -e 's/"//g'
}

if [ ${#} -lt 1 ]; then
    usage
    exit 1
fi
case ${1} in
    add|modify) shift
        ssh-target-add ${*}
        ;;
    remove|delete|del) shift
        ssh-target-remove ${*}
        ;;
    list) ssh-target-list
        ;;
    *) usage
        ;;
esac

