#bin/bash
#cyberpatriot ubuntu script: h0dl3 

#color variables

RED='\033[0;31m'
LightBlue='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "${RED}------------------------------------------------------------"
echo -e "${GREEN}Cyberpatriot Ubuntu Script: h0dl3"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}FORESNIC README"
echo "PASSWORD"
echo "SCREENSAVER"
echo -e "${RED}-------------------------------------------------------------"



#check if you are running as root
if [ $USER != root ]; then 
  #not root
	echo -e "${GREEN}Retry as root: sudo su"
	exit
else
	#root
	echo -e "${GREEN}Yay, you are root!"
fi



#Updates
updates(){
	#open software and updates through gui
	software-properties-gtk	
 	echo -e "${NC}"	
	read -p "$(echo -e ${GREEN}'Ready to apt-get (update, upgrade, dist-upgrade)? y/n: '${NC})" yorn

	#update all at once in a seperate terminal
	if [ $yorn == y ]; then
    gnome-terminal -e "bash -c \"(apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y)\"" & disown; sleep 2; 
	fi
}



#Users/Groups/sudoers
#users first
users(){
	echo -e "${LightBlue}Opening /etc/passwd ..."
	sleep 3s
	#open /etc/passwd
	vim /etc/passwd
}

#groups next
groups(){
	echo -e "${LightBlue}Opening /etc/group ..."
	sleep 3s
	#open /etc/group
	vim /etc/group
}

#sudoers last
sudoers(){
	echo -e "${LightBlue}Opening sudo visudo ..."
	sleep 3s
	#open /etc/sudoers
	sudo visudo
}



#Password Requirements
logindefs(){
	echo -e "${LightBlue}Opening /etc/login.defs ..."
	sleep 3s
	#open /etc/login.defs
	vim /etc/login.defs
}

#PAM
#common-password
common-password(){
	echo -e "${LightBlue}Installing cracklib ...${NC}"
	sleep 3s
	
	apt-get install libpam-cracklib -y
	
	echo -e "${LightBlue}Opening /etc/pam.d/common-password ..."
	sleep 3s
	#open /etc/pam.d/common-password
	vim /etc/pam.d/common-password	
}

#common-auth
common-auth(){
	echo -e "${LightBlue}Opening /etc/pam.d/common-auth ..."
	sleep 3s
	#open /etc/pam.d/common-auth
	vim /etc/pam.d/common-auth
}



#Guest Access
#lightdm
lightdm(){
	echo -e "${LightBlue}Opening /etc/lightdm/lightdm.conf ..."
	sleep 3s
	#open /etc/lightdm/lightdm.conf
	vim /etc/lightdm/lightdm.conf
	
	#replace guest file
	read -p "$(echo -e ${LightBlue}'Replace guest file? y/n: ')" yorn
	if [ $yorn == y ]; then
		echo -e "[SeatDefaults]\nautologin-guest=false\nautologin-user=none\nautologin-user-timeout=0\nautologin-session=lightdm-autologin\nallow-guest=false\ngreeter-hide-users=true" >> /etc/lightdm/lightdm.conf
	fi

	#reopen guest file?
	read -p "$(echo -e ${LightBlue}'Reopen /etc/lightdm/lightdm.conf? y/n: ')" yorn
	if [ $yorn == y ]; then
		#reopen /etc/lightdm/lightdm.conf
		vim /etc/lightdm/lightdm.conf
	fi
}



#Media/Malware
#media
media(){
	#find media files
	find /home -type f \( -name "*.mp3" -o -name "*.txt" -o -name "*.xlsx" -o -name "*.mov" -o -name "*.mp4" -o -name "*.avi" -o -name 			"*.mpg" -o -name "*.mpeg" -o -name "*.flac" -o -name "*.m4a" -o -name "*.flv" -o -name "*.ogg" -o -name "*.gif" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) > find_results.txt
	
	#open find_results.txt
	less find_results.txt
}

#malware
malware(){
	#array of malware
	mal=(minetest nmap aircrack-ng ophcrack john logkeys hydra fakeroot crack medusa nikto tightvnc bind9 avahi cupsd postfix nginx frostwire wireshark vuze weplab pyrit mysql php5 proftpd-basic filezilla postgresql irssi telnet telnetd samba apache2 ftp vsftpd netcat* openssh-server)
	
	#loop through each application
	for i in ${mal[*]}; do
		echo -e "${RED}---------------------------------------------------------"
		echo -e "${LightBlue}Removing $i ...${NC}"
		apt-get autoremove --purge $i
	done
}

#good programs
goodprograms(){
	#install a variety of "good programs"
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing some good programs ...${NC}"
	sleep 3s
	apt-get install clamav lynis rkhunter chkrootkit -y
	#install git then linenum and linpeas
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing git${NC}"
	sleep 2s
	apt-get install git
	echo -e "${RED}--------------------------------------------------------"
	echo -e "${LightBlue}Installing LinEnum & LinPEAS${NC}"
	#install LinEnum
	git clone https://github.com/rebootuser/LinEnum
	#install LinPeas
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite
}
#treet
treet(){
	echo -e "${RED}----------------------------------------------------------------"
	read -p "$(echo -e ${LightBlue}'Run tree -a? y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		tree / -f -a -o tree.txt
		less -r tree.txt
		tree /home -f -a -o treehome.txt
		less -r treehome.txt
	fi

	echo -e "${RED}--------------------------------------------------------------- "
	echo -e "${LightBlue}Moving to Malware ..."
	sleep 3s
}



#File Permissions
fileperms(){
	echo -e "${NC}"
	chown root:root /etc/securetty
	chmod 0600 /etc/securetty
	chmod 644 /etc/crontab
	chmod 640 /etc/ftpusers
	chmod 440 /etc/inetd.conf
	chmod 440 /etc/xinted.conf
	chmod 400 /etc/inetd.d
	chmod 644 /etc/hosts.allow
	chmod 440 /etc/sudoers
	chmod 640 /etc/shadow
	chown root:root /etc/shadow
}



#Firewall
firewall(){
	echo -e "${LightBlue}Installing Firewall ...${NC}"
	sleep 3s
	#install firewall
	apt-get install ufw

	ufw enable
	ufw allow ssh
	ufw allow http
	ufw allow https
	ufw deny 23
	ufw deny 2049
	ufw deny 515
	ufw deny 111
	ufw logging high
	ufw status verbose
}



#Cron
crontab1(){
	echo -e "${LightBlue}Opening crontab ..."
	sleep 3s
	#view crontabs
	sudo crontab -e
	
	#view /etc/cron.(d)(daily)(hourly)(weekly)(monthly)
	read -p "$(echo -e 'View cron.d y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.d
	fi

	read -p "$(echo -e ${LightBlue}'View cron.daily y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.daily
	fi

  read -p "$(echo -e ${LightBlue}'View cron.hourly y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.hourly
	fi

	read -p "$(echo -e ${LightBlue}'View cron.weekly y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.weekly
	fi

	read -p "$(echo -e ${LightBlue}'View cron.monthly y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		ls -a /etc/cron.monthly
	fi
	
	read -p "$(echo -e ${LightBlue}'View /etc/rc.local y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		vim /etc/rc.local
	fi

}

#cron of everyone (cron1)
cron1(){
	for user in $(getent passwd | cut -f1 -d: ); do
		echo -e "${LightBlue}$user${NC}"
		crontab -u $user -l
	done
}


#SSH
ssh(){
	#is ssh a critical service?
	read -p "$(echo -e ${LightBlue}'Is SSH a critical service? y/n: '${NC})" yorn
	if [ $yorn == y ]; then
		#install ssh
		apt-get install ssh -y
		apt-get install openssh-server -y
		
		echo -e "${LightBlue}Opening /etc/ssh/sshd_config ..."
		sleep 3s
		#open /etc/ssh/sshd_config
		vim /etc/ssh/sshd_config

		#Restart SSH
		echo -e "${LightBlue}Restarting SSH"
		sleep 3s
		service ssh restart
	elif [ $yorn == n ]; then
		#uninstall ssh
		apt-get autoremove --purge ssh
		apt-get autoremove --purge openssh-server
	fi
}



#sysctl
sysctl1(){
	cp /etc/sysctl.conf /etc/sysctlorig.conf
	cp -f sysctl.conf /etc/sysctl.conf
	sysctl -e -p /etc/sysctl.conf
}



#Starting the actual checklist, slowly calling all the functions above
echo -e "${GREEN}Starting Checklist"
echo -e "${RED}-------------------------------------------------------------"

#install vim
echo -e "${LightBlue}Installing Useful & Necessary Stuff ...${NC}"
sleep 1s
apt-get install vim debsums tree -y

#run debsums
echo -e "${LightBlue}Running a quick debsums check ...${NC}"
debsums -ce

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Starting with Updates? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	updates
else
	#s, skip
	echo -e "Skipped"
fi

echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Users/Groups, Move on? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	users
	groups
	sudoers
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Password Requirements? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	logindefs
	common-password
	common-auth
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Disabling Guest? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	lightdm
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Media/Programs? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	media
	treet
	malware
	goodprograms
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to File Permissions? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	fileperms
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Firewall? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	firewall
else
	#s, skip
	echo -e "Skipped"
fi

#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Cron? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	crontab1
	cron1
else
	#s, skip
	echo -e "Skipped"
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to SSH? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	ssh
else
	#s, skip
	echo -e "Skipped"
fi



#yorn: yes or no, ask to move on to the next task
echo -e "${RED}-------------------------------------------------------------"
read -p "$(echo -e $GREEN'Move on to Sysctl? y/n/s (skip): ')" yorn

#check the value of yorn
if [ $yorn == n ]; then
	#n, stop script
	echo -e "Stopping Script :("
	exit
elif [ $yorn == y ]; then
	#y, call the functions
	sysctl1
else
	#s, skip
	echo -e "Skipped"
fi







#end of script
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}Done with script! :)"
echo -e "${RED}-------------------------------------------------------------"
echo -e "${GREEN}REMINDERS"
echo -e "${GREEN}NONE YET${NC}"




































