# we are reading the project name
read -p "Enter your repository name: " repository
if [ ! -d ~/Documents/HTB/$repository ] 
then 
	mkdir ~/Documents/HTB/$repository
	#we are reading the input file for IPs to be scanned
	read -p "Enter the targets file and its location: " targets
	#start the initial scan with only SYN to do a fast check which ports are open
	if [ -f $targets ]
	then 
		if [ ! -s $targets ]
		then
			echo "The file exists, but it's empty"
		else
			echo "Starting scanning the targets..."
			#######################################
			cd ~/Documents
			for dir in $(cut -d" " -f2 "$targets"); do mkdir ~/Documents/HTB/$repository/$dir; done
			cd ~/Documents
			for dir in $(cut -d" " -f2 "$targets")
				do 
						cd ~/Documents/HTB/$repository/$dir 
						#scan all TCP ports, but do not establish a session, just check state
						nmap -Pn -sS -p 0- --reason "$dir" -oA initial-tcp-scan
						#scan top 1000 UCP ports, set timeout for speed
						nmap -Pn -sU --reason --host-timeout 100ms "$dir" -oA initial-udp-scan
						cat initial-tcp-scan.xml |grep -i 'open"' |grep -i "portid=" |cut -d '"' -f 4,5,6| grep -o '[0-9]*' |sort --unique |paste -s -d, > nmap_unique_tcp_ports.txt
						cat initial-udp-scan.xml |grep -i 'open"' |grep -i "portid=" |cut -d '"' -f 4,5,6| grep -o '[0-9]*' |sort --unique |paste -s -d, > nmap_unique_udp_ports.txt
				done
			cd ~/Documents
			for dir in $(cat $targets | cut -d" " -f2)
				do 
					cd ~/Documents/HTB/$repository/$dir
					if [ $(wc -c <nmap_unique_tcp_ports.txt) -gt 1 ] 
					then 
						#echo "Test point"
						nmap -sV -sC --reason -p $(cat nmap_unique_tcp_ports.txt) "$dir" -oA tcp-version-scan
						nmap --script vuln -p $(cat nmap_unique_tcp_ports.txt) "$dir" -oA tcp-vuln-scan
						#nmap --script default -p $(cat nmap_unique_tcp_ports.txt) $dir -oN tcp-script-scan.nmap 
					fi
					if [ $(wc -c <nmap_unique_udp_ports.txt) -gt 1 ] 
					then 
						nmap -sUV -A --reason -p $(cat nmap_unique_udp_ports.txt) "$dir" -oA udp-version-scan
					fi
				done
		fi
	else
		echo "This file doesn't exist."
	fi
else 
	echo "This directory is already populated with scans..."
fi
cd ~/Documents || exit
