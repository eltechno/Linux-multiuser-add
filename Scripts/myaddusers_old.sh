#Created by Conor Sinclair - ID 27000128
#Created for Waiariki Institute of Technology, Network Operating Systems COMP.6103

#Assigns username to check for group privs
currentUser="$USER"

#-----

#Performs a check to see if user is root or admin, otherwise it tells the user to try again and exits execution

#Check for root first.
if [ $(echo id -u) -ne "0" ]
then
	rootUser=false
else
	rootUser=true	
fi

#check if admin
if [ $(echo id -Gn $currentUser | grep '\badm\b') ] && [ "$rootUser" == false ]
then
	adminUser=true
else
	adminUser=false
fi

#check if sudo access
if [ $(echo id -Gn $currentUser | grep '\bsudo\b') ] && [ "$rootUser" == false ]
then
	sudoUser=true
else
	sudoUser=false
fi


userId=$(echo "$EUID")

#if current executor is not a member of any of the groups then fail and exit
if [ $($rootUser == false ) ] && [ $($sudoUser == false) ] && [ $($adminUser == false) ]
	then echo  
	echo "Please run this script as root user, admin or with sudo access."
	echo 
	exit
fi

#-----

funcCheckValid() {
	
	#define variables for easy usage
	username=$1
	password=$2
	groupname=$3
	fullname=$4
}

#User is one of allowed groups
echo 
echo "Root user?: $rootUser"
echo "Admin user?: $adminUser"
echo "Sudo user?: $sudoUser"
echo
echo "----"

#Checks if args are passed

#Check for filepath
if [ "$1" == "" ]
	then
	echo ""
	echo "Arguments not supplied, please provide a filename to read from."
	echo "An example may be: 'myaddusers.sh userlist.txt'" 
	echo "or 'myaddusers.sh userlist.txt -sh'"
	echo ""
exit
else
	echo "First param: $1"
	fi

#Check for -h parameter for detailed information. The parameter can be used as either the first or second arguments
if [ "$2" == "-h" ] || [ "$1" == "-h" ]
	then
	echo -e "\n-----------\nDetailed Information:\n\nThis folder contains a script that can be used to create additional users easily based on a .txt (or similar) using the notation of Username:password:groupname:fullname .\n\nThe files are all located in the working directory. If you would like to use the script efficiently or plan on using a lot of files, you can add a Directory inside which can contain all data files -- to execute you simply need to include the Directory in the request.\n\nExample of script:\n\nbash myaddusers.sh userlist.txt \nOR\nbash myaddusers.sh Data\\userlist.txt"
	exit
	fi


#read each line of the file
while read p; do
	echo $p

	#define variables for easy usage
	username=$(echo "$p" | cut -d':' -f1) #username
	password=$(echo "$p" | cut -d':' -f2) #password
	groupname=$(echo "$p" | cut -d':' -f3) #groupname
	fullname=$(echo "$p" | cut -d':' -f4) #fullnamebash
	
#---
	#Error checking
	if [ -z "$username" ]
	then
		echo "Username was not detected, please run ensure that the file contains appropriate parameters -- in this case the Username argument. Format should be Username:password:groupname:fullname"
		
		echo $(date +%Y-%m-%d) >> error_log.txt
		echo "Username not detected" >> error_log.txt
		echo "" >> error_log.txt

		exit

	elif [ -z "$password" ]
	then
	
		echo "Password was not detected, please run ensure that the file contains appropriate parameters -- in this case the Password argument. Format should be Username:password:groupname:fullname"

		
		
		echo $(date +%Y-%m-%d) >> error_log.txt
		echo "Username not detected" >> error_log.txt
		echo "" >> error_log.txt
		
		exit

	elif [ -z "$groupname" ]
	then
		echo "Groupname was not detected, please run ensure that the file contains appropriate parameters -- in this case the Groupname argument. Format should be Username:password:groupname:fullname"
		
		echo $(date +%Y-%m-%d) >> error_log.txt
		echo "Username not detected" >> error_log.txt
		echo "" >> error_log.txt
		
		exit


	elif [ -z "$fullname" ]
	then
		echo "Fullname was not detected, please run ensure that the file contains appropriate parameters -- in this case the Fullname argument. Format should be Username:password:groupname:fullname"
		
		echo $(date +%Y-%m-%d) >> error_log.txt
		echo "Username not detected" >> error_log.txt
		echo "" >> error_log.txt
		
		exit

	fi
#---
	
	#check if group exists
	if [ $(getent group $groupname) ]
	then
		echo "Group exists, using the existing group now"
	else
		echo "Group doesn't exist, creating $groupname now"
		groupadd "$groupname" 
	fi
	
	#adds user with specified parameters. Encrypts input password and saves it.
	useradd -c "$fullname" -p $(echo "$password" | openssl passwd -1 -stdin) -g "$groupname" $username -m

	groupId=$(getent group $groupname | cut -d':' -f3)
	echo "Group: $groupId"
	fileCreationDate=$(ls -ld /home/$username | awk '{ print $6,$7,$8 }')
	echo "Created at: $fileCreationDate"
	
	echo "$username:"$(id -u $username)":$groupname:$groupId:$fileCreationDate:$fullname" >> report.txt
	echo 
done < $1

echo "" >> report.txt #Just to show visible spaces where multiple users have been added by one script

