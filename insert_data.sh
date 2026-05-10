#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#! /bin/bash

# clear existing data
echo "$($PSQL "TRUNCATE TABLE games, teams")"

# read the csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip header row
  if [[ $YEAR != "year" ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if winner not found, insert team
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Inserted team: $WINNER

      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if opponent not found, insert team
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo Inserted team: $OPPONENT

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert game
    INSERT_GAME=$($PSQL "
      INSERT INTO games(
        year,
        round,
        winner_id,
        opponent_id,
        winner_goals,
        opponent_goals
      ) VALUES(
        $YEAR,
        '$ROUND',
        $WINNER_ID,
        $OPPONENT_ID,
        $WINNER_GOALS,
        $OPPONENT_GOALS
      )
    ")

    echo Inserted game: $YEAR $ROUND
  fi
done