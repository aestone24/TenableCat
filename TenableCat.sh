#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Invalid number of arguments"
	echo "Example: sudo ./tenable-categories.sh input.xslx"
	exit
fi

if ! [[ -f "$1" && "$1" == *.xlsx ]]; then
	echo "Invalid file type or file does not exist"
	echo "Please only use existing XLSX files"
	exit 1
fi

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

if ! dpkg -s "xlsx2csv" >/dev/null 2>&1; then
	echo "xlsx2csv not installed, installing now"
	apt install xlsx2csv
	echo
fi

if ! dpkg -s "csvkit" >/dev/null 2>&1; then
	echo "csvkit not installed, installing now"
	apt install csvkit
	echo
fi

xlsx2csv $1 output.csv -d "tab" -n "Findings" >/dev/null 2>&1

cat output.csv | grep "#N/A" | cut -d$'\t' -f1,3,9 | grep -v $'#N/A\t\t' | uniq > tmp
echo -n '' > categories.csv
file="tmp"

cat $file | while IFS= read -r line
do
	clear
	category=""
	echo "_____  ____        ___   ___         ____  ____  ___  _____   "
	echo "  |   |     |\  | |   | |   ) |     |     |     |   |   |     "
	echo "  |   |--   | \ | |---| |--<  |     |--   |     |---|   |     "
	echo "  |   |____ |  \| |   | |___) |____ |____ |____ |   |   |     "
	echo
	echo "Categories:"
	echo "1. Configuration Issues"
	echo "2. Patching Issues"
	echo "3. Other Issues"
	echo
	echo -n "Vulnerability: "
	echo "$line" | cut -d$'\t' -f2
	echo
	echo -n "Recommendation: "
	echo "$line" | cut -d$'\t' -f3
	echo
	read -p "Enter Category (1-3): " choice < /dev/tty
	case "$choice" in
		1)
			echo
			echo "Subcategories:"
			echo "1. Apache Configuration Issues"
			echo "2. Linux Configuration Issues"
			echo "3. Microsoft Configuration Issues"
			echo "4. Palo Alto Configuration Issues"
			echo "5. SNMP Configuration Issues"
			echo "6. SSH Configuration Issues"
			echo "7. Web Server Configuration Issues"
			
			read -p "Enter Subcategory (1-7): " choice2 < /dev/tty
			
			case "$choice2" in
				1)
					category="Apache Configuration Issues"
					;;
				2)
					category="Linux Configuration Issues"
					;;
				3)
					category="Microsoft Configuration Issues"
					;;
				4)
					category="Palo Alto Configuration Issues"
					;;
				5)
					category="SNMP Configuration Issues"
					;;
				6)
					category="SSH Configuration Issues"
					;;
				7)
					category="Web Server Configuration Issues"
					;;
				*)
					echo "Invalid Choice"
					sleep 1
					;;
			esac
				
			;;
		2)
			echo
			echo "Subcategories"
			echo "1. Apache Patching Issues"
			echo "2. Cisco Patching Issues"
			echo "3. Linux Patching Issues"
			echo "4. Microsoft Patching Issues"
			echo "5. Oracle Patching Issues"
			echo "6. Palo Alto Patching Issues"
			echo "7. Third-party Patching Issues"
			echo "8. VMware Patching Issues"
			
			read -p "Enter Subcategory (1-8): " choice2 < /dev/tty
			
			case "$choice2" in
				1)
					category="Apache Patching Issues"
					;;
				2)
					category="Cisco Patching Issues"
					;;
				3)
					category="Linux Patching Issues"
					;;
				4)
					category="Microsoft Patching Issues"
					;;
				5)
					category="Oracle Patching Issues"
					;;
				6)
					category="SPalo Alto Patching Issues"
					;;
				7)
					category="Third-party Patching Issues"
					;;
				8)
					category="VMware Patching Issues"
					;;
				*)
					echo "Invalid Choice"
					sleep 1
					;;
			esac
				
			;;
		
		3)
			echo
			echo "Subcategories"
			echo "1. End-of-Life Software Issues"
			echo "2. Insecure Protocol Issues"
			echo "3. Password Issues"
			echo "4. SSL-TLS Certificate Issues"
			
			read -p "Enter Subcategory (1-4): " choice2 < /dev/tty
			
			case "$choice2" in
				1)
					category="End-of-Life Software Issues"
					;;
				2)
					category="Insecure Protocol Issues"
					;;
				3)
					category="Password Issues"
					;;
				4)
					category="SSL-TLS Certificate Issues"
					;;
				*)
					echo "Invalid Choice"
					sleep 1
					;;
			esac
			;;
		*)
			echo "Invalid Choice"
			sleep 1
			;;
	esac
			
	if [[ -n "$category" ]]; then	
		printf "$line\t$category" | cut -d$'\t' -f2,4 >> categories.csv
	fi

done
rm tmp
rm output.csv
