# Linux-multiuser-add
Simple shell script that adds one or many users from a text file with 4 parameters into system users. Created as part of my COMP.6103 Network Operating Systems Management class at Waiariki Institute of Technology as part of the Bachelors of Computing.

myaddusers.sh is the main file, also includes the userlist with sample inputs, and a delete script to remove the users in the same list -- does not remove groups that were created however.

##To use:

Username:Password:Groupname:Full Name

Default:
```
bash myaddusers.sh userlist.txt
```

To get basic information:
```
bash myaddusers.sh -h
```
