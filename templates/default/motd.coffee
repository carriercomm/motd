#!/usr/bin/env bash
#######################################################################
# WARNING: This file automatically generated by Borg on <%=Date.create().format('{yyyy}-{MM}-{dd} {HH}:{mm}:{ss} {tz}')%>
#          If you need to edit this file, do so in the Borg repository.
#          Any change you make here WILL be overridden on assimilation.
#######################################################################

CPU_MODEL=`cat /proc/cpuinfo | grep "model name" | head -1 | cut -d':' -f2`
CPU_COUNT=`grep processor /proc/cpuinfo|sort -u|wc -l`
CORE_COUNT=`grep core\ id /proc/cpuinfo|sort -u|wc -l`
MEMORY_KB=`grep MemTotal: /proc/meminfo|awk '{ print $2 }'`
MEMORY_GB=`echo $MEMORY_KB / 1000000|bc`"GB RAM"
DISK_SPACE=`df -h / | tail -1 | awk '{print "Capacity:", $2 ", Used:", $3, "(" $5 ")" ", Free:", $4}'`
CPUTIME=$(ps -eo pcpu | awk 'NR>1' | awk '{tot=tot+$1} END {print tot}')
CPUCORES=$(cat /proc/cpuinfo | grep -c processor)
CPU_UTIL="CPU: `echo $CPUTIME / $CPUCORES | bc`%, Load: `cat /proc/loadavg`"
MEM_UTIL="Used: `free -m | head -n 3 | tail -n 1 | awk {'print $3'}`/`free -m | head -n 2 | tail -n 1 | awk {'print $2'}`MB, Free: `free -m | head -n 3 | tail -n 1 | awk {'print $4'}`MB, Swp: `free -m | tail -n 1 | awk {'print $3 "/" $2'}`MB"
PLATFORM=`uname -orpi`
OS_VER=`lsb_release -d | cut -f2`
UPTIME=`uptime | awk '{print $3, $4, $1}'`
PUBLIC_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
PRIVATE_IP=`ifconfig eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d':' -f2`
LAST3USERS=`last -3iw | head -3`

echo -e "\033[1;32m
<%=@server.motd.banner.replace(/(^[\r\n]+|[\r\n]+$)/g, '').replace(/\\/g,'\\\\\\').replace(/`/g, '\\\`').replace(/"/g, '\\\"') %>

<%=@server['datacenter']%> <%=@server['environment']%> <%=@server['tld']%> <%=@server['type']%><%=@server['instance']%>

\033[0;35m+++++++++++++++++: \033[0;37mSystem Data\033[0;35m :+++++++++++++++++++
\033[0;35m+ \033[0;37mProcessor \033[0;35m= \033[1;32m${CPU_COUNT}x${CORE_COUNT}${CPU_MODEL}
\033[0;35m+ \033[0;37mCompute   \033[0;35m= \033[1;32m${CPU_UTIL}
\033[0;35m+ \033[0;37mMemory    \033[0;35m= \033[1;32m${MEM_UTIL}
\033[0;35m+ \033[0;37mDisk      \033[0;35m= \033[1;32m${DISK_SPACE}
\033[0;35m+ \033[0;37mPlatform  \033[0;35m= \033[1;32m${OS_VER} ${PLATFORM}
\033[0;35m+ \033[0;37mUptime    \033[0;35m= \033[1;32m${UPTIME}
\033[0;35m+ \033[0;37mAddress   \033[0;35m= \033[1;32mPublic: ${PUBLIC_IP}, Private: ${PRIVATE_IP}
\033[0;35m+++++++++++++: \033[0;37mHelpful Information\033[0;35m :+++++++++++++++
\033[0;35m+\033[0;37m !!! NOTICE: ALL YOUR SYSTEM ARE BELONG TO CHEF !!!
\033[0;35m+\033[0;37m YOUR CHANGES WILL BE SUBJECT TO PERIODIC OVERRIDE
\033[0;35m+\033[0;37m   UPDATE THE CHEF REPO IF YOU WANT THEM TO STAY
\033[0;35m+\033[0;35m last run: \033[1;32m<%= Date.create().format('{yyyy}-{MM}-{dd} {HH}:{mm}:{ss} {tz}') %>
\033[0;35m++++++++++++++: \033[0;37mUser Login Roster\033[0;35m :++++++++++++++++
\033[0;37m`last -5iw | grep -v system | head -n+5 | tail -n+1`
\033[0;35m+++++++++++++++++++++++++++++++++++++++++++++++++++
\033[0;0m"
