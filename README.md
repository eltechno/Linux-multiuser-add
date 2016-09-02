# Linux-multiuser-add
Simple shell script that adds a users from a text file with 4 parameters into system users.

myaddusers.sh is the main file, also includes the userlist with sample inputs, and a delete script to remove the users in the same list -- does not remove groups that were created however.

##To use:

Default:
```
bash myaddusers.sh userlist.txt
```

To get basic information:
```
bash myaddusers.sh -h
```
