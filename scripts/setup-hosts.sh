#!/bin/bash

TOTAL_NODES=2

while getopts t: option
do
	case "${option}"
	in
		t) TOTAL_NODES=${OPTARG};;
	esac
done

function setupHosts {
	echo "modifying /etc/hosts file"
	for i in $(seq 1 $TOTAL_NODES)
	do 
		entry="10.211.55.10${i} node${i}"
		echo "adding ${entry}"
		echo "${entry}" >> /etc/nhosts
	done
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	#cat /etc/hosts >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}


echo "setup hosts file"
setupHosts