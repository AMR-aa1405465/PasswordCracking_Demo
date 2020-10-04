#!/usr/bin/env bash
RESULT_FILE="results.txt"
CREDS_FILE="output.txt"
greeting(){
  date=`date`
  echo "Hello $USER"
  echo "Greetings from Amr Aboeleneen!"
  echo "Script running @ $date"
  echo "Errors stored  @ error.log"
  echo "results stored @ $RESULT_FILE"
  echo "Timming saved  @ timming.log"
}

#first task
bruteForce(){
  a=`echo {a..z}`
  b=`echo {A..Z}`
  c=`echo {0..9}`
  charset="$a $b $c"
  extractedHash=`cat './passwd.txt' | grep aisha | cut -d : -f 2 | tr -d '\n' | tr -d ' '`
  echo "----------------------------------------------"
  echo "Welcome To brute-force made by Amr-aa1405465"
  echo "extracted hash of Aisha is $extractedHash"
  echo "results will be saved in $RESULT_FILE and timming.txt"
  echo "charset used is $charset "
  let "downTimer=7"

  for i in {1..5}
  do
    echo -ne "Starting in ..... $downTimer"'\r'
    let "downTimer=$downTimer-1"
    sleep 1
  done
  onePassMD5=`printf "$onePass" | md5sum | cut -d "-" -f 1 | tr -d '\n' | tr -d ' '`
  counter=0
  currentTime=`date +%s`
  for c1 in $charset
  do
    for c2 in $charset
    do
      for c3 in $charset
      do
        for c4 in $charset
        do
          rand="$c1$c2$c3$c4"
          onePassMD5=`printf "$rand" | md5sum | cut -d "-" -f 1 | tr -d '\n' | tr -d ' '`
          #echo $rand $onePassMD5
          echo "$onePassMD5 with $extractedHash"
          if [ "$onePassMD5" == "$extractedHash" ]
          then
            foundTime=`date +%s`
            echo "found the password !!" >> $RESULT_FILE
            echo "password is $rand" >> $RESULT_FILE
            let "diffe=$foundTime-$currentTime"
            #let "diffe=$diffe/3600.0" #convert into hours
            echo "it took about $diffe seconds to Get the password " | tee -a "timming.log"
            echo "Got the password ....$rand ...please see the result @ $RESULT_FILE"
            exit;
          fi
          let "counter=$counter+1"
          echo -ne "Testing ..... $counter passwords"'\r'
      done
    done
  done
done

}

#second task
dictAttack(){
  #make my hash table first
  #declare -A creds
  if [ -f "lookupTable.txt" ]; then
    rm "lookupTable.txt"
    cat $CREDS_FILE >> "Old_records.txt"
    rm $CREDS_FILE
    echo "****Removing old lookup table****"
  fi


creationLookupTime_=`date +%s`
  #read line by line & then add to map without duplication
  for val in `cat wordlist.txt | sort | uniq `
  do
    key=`echo -n  $val | md5sum | cut -d "-" -f 1 | cut -d " " -f 1`
    #creds["$key"]="$val"
    #echo "$key"
    pasted=`echo -n "$key:$val"`
    #pasted=${pasted%?};
    #echo "$key:$val" >> "lookupTable.txt"
    echo -n $pasted >> "lookupTable.txt"
    echo "" >> "lookupTable.txt"
  done
  creationLookupTimeEnd_=`date +%s`
  let "diffC=$creationLookupTime_-$creationLookupTimeEnd_"
  echo "Created lookup table in $diffC" >> "timing.log"


  startingTime=`date +%s`
  #Now , lets see who is comprmised
  cat passwd.txt | while read line
  do
    user=`echo $line | cut -d ":" -f 1 `
    keyz=`echo  $line | cut -d ":" -f 2 `
    results=`cat 'lookupTable.txt' | grep "$keyz*" `

    if [ ! -z "$results" ];then
      retrievedPassword=`echo $results | cut -d ":" -f 2`
      #echo "Found the password for USER = [$user] --> $retrievedPassword"
      echo "$user   $retrievedPassword" >> $CREDS_FILE
      endTime=`date +%s`
      let "diff=$endTime-$startingTime"
      echo "dict-password for $user : Time in seconds was $diff" >> "timing.log"
      startingTime=$endTime #resetting start time

    fi


  done
   echo "********************Output*********************"
   echo
   echo "User    Password"
   echo "-----------------"
   cat $CREDS_FILE | sed 's/\t/,|,/g' | column -s ' ' -t



}

#Third task
authenticateUser(){
  echo "Enter username please"
  read user
  echo "Enter password please"
  read password

  cat shadow.txt | while read line
  do
    #Password From shadow Users...
    _user=`echo -n $line | cut -d ":" -f 1`
    _salt=`echo -n $line | cut -d "$" -f 2 | cut -d ":" -f 1 | tr -d " " | tr -d "\n"`
    _password=`echo -n $line | cut -d "$" -f 3 | cut -d ":" -f 1 | tr -d " "| tr -d "\n"`

    #Password from User...
    _givenPass=`echo -n $password$_salt | md5sum | cut -d "-" -f 1 | tr -d " " | tr -d "\n"`

    if [ $user == $_user ] ;then
      if [ $_password == $_givenPass ]; then
        echo "Login Succeeded"
     else
        echo "Login Failed"
     fi


    fi

  done



}


#Checking number of arguments
if [ "$#" -ne 1 ]
then
  echo "Invalid number of arguments ..."
  printf "Please run with the following:\n1.BruteForce\n2.dictionary Attack\n3.Authenticate user\n"
  echo "example ./script.sh 1"
  exit 0
fi
if [ $1 -eq 1 ] ; then
  greeting
  bruteForce
elif [ $1 -eq 2 ] ; then
  dictAttack
elif [ $1 -eq 3 ] ; then
  authenticateUser
fi
