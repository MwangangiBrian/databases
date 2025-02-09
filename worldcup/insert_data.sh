#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    # ADD DATA TO TEAMS TABLE
    if [[ $WINNER != winner ]]
      then
        TEAM=$($PSQL "SELECT name FROM teams WHERE name=$WINNER;")
        if [[ -z $TEAM ]]
          then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_TEAM == "INSERT 1 0" ]]
              then 
                echo"Team added successfully!"
            fi
        fi
    fi

     if [[ $OPPONENT != opponent ]]
      then
        TEAM=$($PSQL "SELECT name FROM teams WHERE name=$OPPONENT;")
        if [[ -z $TEAM ]]
          then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_TEAM == "INSERT 1 0" ]]
              then 
                echo Team added successfully!
            fi
        fi
    fi

    # ADD DATA TO GAMES TABLE
    if [[ $YEAR != 'year' ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

        INSERT_GAME=$($PSQL "INSERT INTO games( year, round, winner_goals, opponent_goals, winner_id, opponent_id )
        VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID);")

        if [[ $INSERT_GAME == "INSERT 1 0" ]]
          then 
            echo Game added successfully!
        fi
    fi 
done