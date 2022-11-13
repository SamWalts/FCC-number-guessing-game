#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
# echo $($PSQL "TRUNCATE users, games")

function LOGIN() {
echo -e "\nEnter your username: "
  read USERNAME
CHECK_USERNAME "$USERNAME"
}
#function to generate random numbers 1-50

function CHECK_USERNAME() {
CHECK_USER=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
if [[ -z $CHECK_USER ]]
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
ADD_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
#need user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
# get games played
  GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id = $USER_ID";)
# (min) guesses for games played
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $USER_ID";)
echo -e "\nWelcome back, $USERNAME! You have played $(echo $GAMES_PLAYED | sed -E 's/^ *| *$//g') games, and your best game took $(echo $BEST_GAME | sed -E 's/^ *| *$//g') guesses."
fi
GAME $USERNAME $GAMES_PLAYED $USER_ID $BESTGAME
}

#function to generate random numbers 1-50
GAME() {

  NUMBER_TO_GUESS=$(( $RANDOM % 1000 + 1 ))
  echo -e "\nGuess the secret number between 1 and 1000:"
  #while loop
  while :
  do
  #count the number of guesses
    let "GUESSES++"
  #if not a number
  read NUMBER
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
  echo -e "\n That is not an integer, guess again:"

  continue
  fi

  if [[ $NUMBER -gt $NUMBER_TO_GUESS ]]
    then
    echo -e "\nIt's lower than that, guess again:"
    continue
  fi

  if [[ $NUMBER -lt $NUMBER_TO_GUESS ]]
  then
    echo -e "\nIt's higher than that, guess again:"
  continue
  fi
  
  #Congratulations and exit loop
  echo -e "\nYou guessed it in $GUESSES tries. $USER_ID The secret number was $NUMBER_TO_GUESS. Nice job!"
  #add to games table

  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(guesses, user_id) VALUES($GUESSES, $USER_ID)")
  break
done
}

LOGIN
