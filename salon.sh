#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
#Initial output of services menu


NUM_SERVICES=$($PSQL "SELECT COUNT(*) FROM services")
MAIN_MENU () {
  for (( i = 1; i <= $NUM_SERVICES; i ++ ))  
  do
    echo -e "$i) $($PSQL "SELECT name FROM services WHERE service_id = $i")"
  done
  #Getting input
  echo Select number of your service, please!
  read SERVICE_ID_SELECTED
  #Adding the check to see if correct service picked
  if [[ $SERVICE_ID_SELECTED != 1 && $SERVICE_ID_SELECTED != 2 && $SERVICE_ID_SELECTED != 3 ]]
  then
    MAIN_MENU
  fi
}
MAIN_MENU


#getting phone
echo -e "\nYour phone number please."
read CUSTOMER_PHONE
#check if phone in table
PHONE_IN_TABLE=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $PHONE_IN_TABLE ]] 
then
  echo -e "\nYour name Please."
  read CUSTOMER_NAME
  INSERT_INTO_CUSTOMERS=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
echo -e "\nTime of Service Please"
read SERVICE_TIME

#Insert into appointments table
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
INSERT_INTO_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

#output customer statement
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."