# BulkScanHTB
A shell scripting learning project

I started this project with the intention to automate the initial scans for the machines I am testing at hackinthebox. But in the end it could apply to any other direct scans one might need.

The structure is as follows: script will run from /root/Documents in Kali (or other directory of ones choice). In this directory it assumes the existence of the HTB directory (since it's used for hackinthebox machine/s scanning). 
In the /Documents directory (whene we run the script from/ can be changed if someone is using another path) there should be a .txt file containing all the IP addresses to be scanned, one per line,  which will be given as input for the scanner. 
Beware: also 1 IP is ok :)

This is the example shown below: 

~/Documents# ./BulkScanHTB.sh 
Enter your repository name: 16April202023CET
Enter the targets file and its location: list1.txt

This will create a directory 16April202023CET in the HTB, and within this a directory per IP listed in the list1.txt

The main goal is to go further with the automation as for example more scans for ports 22 and 80 if open, start other tools which can be automated further in the scan etc.

Since both the input and execution are under the control of the pentester, so far very little attention has been given to error handling (the purpose of the exercise is not to attack the script, although this aspect might be subject of attention later on).

Ideas to grow this project to a better organized scan are welcome.
