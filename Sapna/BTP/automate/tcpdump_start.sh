#!/bin/sh
rm -f nohup.out

set -x

pcapfile=$1; shift
nohup /usr/sbin/tcpdump -ni eno1 -s 65535 -w "$pcapfile".pcap &

# Write tcpdump's PID to a file
# echo $! > ./tcpdump.pid
echo $! > /var/run/tcpdump.pid