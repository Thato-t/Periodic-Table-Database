#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

ARGUMENT=$1

if [[ -z $ARGUMENT ]]; then
  echo Please provide an element as an argument.
else
  if [[ ! $ARGUMENT =~ ^[0-9]+$ ]]; then
    SELECT_DATA=$($PSQL "SELECT elements.atomic_number, symbol, name, types, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE name = '$1' OR symbol = '$1'")
  else
    SELECT_DATA=$($PSQL "SELECT elements.atomic_number, symbol, name, types, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $1")
  fi
  if [[ -z $SELECT_DATA ]]; then
    echo I could not find that element in the database.
  else
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MPC BPC <<< "$SELECT_DATA"
    echo The element with atomic number $ATOMIC_NUMBER is $NAME "($SYMBOL)". "It's a $TYPE", with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius. 
  fi
fi
