#This file is not required by the Assignment, but I thought it would be wise to add a script to delete users easily instead of manually going through and doing it over and over.
#It takes a file, iterates through vertically and takes the username
#Uses the same file as the one used to create


#Get file
fileName=$1

while read p; do
	echo $p

	#define variables for easy usage
	username=$(echo "$p" | cut -d':' -f1) #username
	password=$(echo "$p" | cut -d':' -f2) #password
	groupname=$(echo "$p" | cut -d':' -f3) #groupname
	fullname=$(echo "$p" | cut -d':' -f4) #fullnamebash
	
	echo "Deleting user: $username"
	userdel -r $username
	echo "User and their files have been deleted"
	echo ""
done < $fileName
