# we are reading the project name
read -p "Enter your repository name: " repository
if [ ! -d ~/Documents/HTB/$repository ] 
then 
	mkdir ~/Documents/HTB/$repository
	#we are reading the input file for IPs to be scanned
	read -p "Enter the targets file and its location: " targets
	#start the initial scan with only SYN to do a fast check which ports are open
	cd ~/Documents/HTB
	for dir in $(cat $targets | cut -d" " -f2); do mkdir ~/Documents/HTB/$repository/$dir; done
	cd ~/Documents/HTB
	for dir in $(cat $targets | cut -d" " -f2)
		do 
				cd ~/Documents/HTB/$repository/$dir 
				#scan all TCP ports, but do not establish a session, just check state
				nmap -Pn -sS -p 0- --reason $dir -oA initial-tcp-scan
				#scan top 1000 UCP ports, set timeout for speed
				nmap -Pn -sU --reason --host-timeout 100ms $dir -oA initial-udp-scan
				cat initial-tcp-scan.xml |grep -i 'open"' |grep -i "portid=" |cut -d '"' -f 4,5,6| grep -o '[0-9]*' |sort --unique |paste -s -d, > nmap_unique_tcp_ports.txt
				cat initial-udp-scan.xml |grep -i 'open"' |grep -i "portid=" |cut -d '"' -f 4,5,6| grep -o '[0-9]*' |sort --unique |paste -s -d, > nmap_unique_udp_ports.txt
		done
	cd ~/Documents/HTB
	for dir in $(cat $targets | cut -d" " -f2)
		do 
			cd ~/Documents/HTB/$repository/$dir
			if [ $(wc -c <nmap_unique_tcp_ports.txt) -gt 1 ] 
			then 
				nmap -sV -sC --reason -p $(cat nmap_unique_tcp_ports.txt) $dir -oN tcp-version-scan.nmap
				nmap --script vuln -p $(cat nmap_unique_tcp_ports.txt) $dir -oN tcp-vuln-scan.nmap 
				#nmap --script default -p $(cat nmap_unique_tcp_ports.txt) $dir -oN tcp-script-scan.nmap 
			fi
			if [ $(wc -c <nmap_unique_udp_ports.txt) -gt 1 ] 
			then 
				nmap -sUV -A --reason -p $(cat nmap_unique_udp_ports.txt) $dir -oN udp-version-scan.nmap
			fi
		done
else 
	echo "this is already scanned..."
fi
cd ~/Documents/HTB
