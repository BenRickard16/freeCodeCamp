#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# search by atomic number OR symbol OR name
ELEMENT=$($PSQL "
SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius,
boiling_point_celsius, types.type
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE atomic_number::text = '$1'
OR symbol = '$1'
OR name = '$1'
")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo "$ELEMENT" | while IFS="|" read AT_NUM NAME SYMBOL MASS MELT BOIL TYPE
do
  echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
