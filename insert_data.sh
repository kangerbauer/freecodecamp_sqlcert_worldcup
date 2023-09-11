#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#delete any existing data
echo $($PSQL "TRUNCATE teams, games")

#print the csv contents
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
#populate the teams table with winners and opponents
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
         echo Inserted into teams, $OPPONENT
        fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
#populate the games table
  if [[ $YEAR != "year" ]]
  then
    #get winner and opponent team_ids
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id='$WINNER_ID' AND opponent_id='$OPPONENT_ID'")
    #if not found
    if [[ -z $GAME_ID ]]
    then      
      #insert game year, round, winner_id, opponent_id, winner_goals, opponent_goals
      INSERT_GAME_DATA_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
        if [[ $INSERT_GAME_DATA_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into games, $YEAR  $ROUND  $WINNER_ID  $OPPONENT_ID  $WINNER_GOALS  $OPPONENT_GOALS
        fi
    fi
  fi
done


