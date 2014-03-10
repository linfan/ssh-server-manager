#!/bin/bash

# BEGIN_OF_IP_LIST
SERVER_server1_IP="22 demo@${SERVER1_IP}"
SERVER_server2_IP="22 demo@${SERVER2_IP}"
# END_OF_IP_LIST

echo $(eval echo \${SERVER_${1}_IP})
