# Objective:
Explore different password storage schemes and experience how an attacker can crack password files

1. Brute-force attack : the wordlist used is a-zA-Z0-9 to find a hidden password
2. Dictionary Attack : using a dictionary , we try decrypt passwords in passwd file 
3. Verfication Attack : We introduce the concept of H(Passwd+Salt) where H is MD5 

# 1. Brute force attack
Suppose you know that the user aisha has a password consisting of 4 characters. Passwords consist
of upper case letters ```A-Z```, lower case letters ```a-z``` and numbers ```0-9```. You are able to see
aisha’s password hash in the publically readable /etc/passwd file (assuming an old Unix
system). Your program will read aisha’s password hash in hexadecimal as input and should find her
password.


# 2. Performing a dictionary attack
The file wordlist.txt has a list of dictionary words containing commonly used passwords. Your
job is to recover as many passwords as you can from the provided password file (passwd.txt).
You should do this in two steps. In the first step, you find and store the hashes for all words in the
dictionary. In the second step, you try to find the passwords for as many users as you can in the
passwd.txt file. For every user with a compromised password, your program should display the
users and his/her password.
Notice that the rainbow table (containing pre-computed hashes) will be searched many times.
Moreover, it can grow in size. Therefore, two issues are taken into account when generating and
storing this table; table size and ability to quickly search the table by hash value. Therefore, this table
is typically indexed by the hash value. You may or may not do this in your program (since your files
are small). However, if you do it, your attack will be much faster, which will enable you to crack
bigger password files.


# 3. Authenticating users
Newer systems use a salt when hashing password and store the salted passwords hashes in a file that is
only accessible to root (e.g. /etc/shadow). The provided file shadow.txt contains salted hashes
of users. The password hashes in this file are computed as ```H(password||salt)```, where H is the MD5 hash
function and || is the string concatenation operator.
Write a login program that accepts a user name and a password and then authenticates the user by
using the data stored in the shadow.txt file. The program will output “Login Succeeded” if the user
is authenticated and will output “Login Failed” otherwise.
You can test your program with any of the cracked passwords. In addition, you can test it with the
following valid login name and password:
```Login name: sarahitmi , Password: CMPT642-2020```


# File formats
The files shadow.txt and passwd.txt have formats similar to the Unix files (with a bit of
simplification). The different fields of a user record are separated by “:”. The following explains the
format of each record in these files. Some of these fields can be empty (“::” indicates an empty field).
Record format of file passwd.txt:
 ```login_name:password_hash:user_number:user_group_number:comment:home_directory:command_shell```
The flowing is a record example:
```jsmith:x:1001:1000:Joe Smith,Room 1007,Phone(234)555-0044:/home/jsmith:/bin/sh```
x in the password_hash field indicates that the password hash is stored separately in a shadow file.

Record format of file shadow.txt:
 ```login_name:$salt$password_hash:other_colon_separated_fields```
The following is a record example
```jsmith:$AQKDPc5E$SWlkjRWexrXYgc98F.:17555:3:30:5:30:17889:```



# Soloutions 
1. Provided in the files 
2. [Youtube video](https://youtu.be/VeJv7RJmVV8)



