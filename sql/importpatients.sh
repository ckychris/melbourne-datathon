#!/bin/bash
# Creates patients table
# Imports all patients data into sqlite db

DATA=~/Desktop/Datathon/MelbDatathon2017
DB=datasci.db

# Create Patients database
sqlite3 $DB "CREATE TABLE patients
(
	Patient_ID	int
,	gender	varchar(1)
,	year_of_birth	smallint
,	postcode	varchar(4) 
)"

sqlite3 -separator $'\t' $DB ".import $DATA/Lookups/patients.txt patients"
