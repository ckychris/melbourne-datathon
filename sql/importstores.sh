#!/bin/bash
# Creates stores table
# Imports all store data into sqlite db

DATA=~/Desktop/Datathon/MelbDatathon2017
DB=datasci.db

# Create Patients database
sqlite3 $DB "CREATE TABLE stores
(
	Store_ID	smallint
,	StateCode	varchar(3)
,	postcode	varchar(4) 
,	IsBannerGroup	boolean
)"

sqlite3 -separator $'\t' $DB ".import $DATA/Lookups/stores.txt stores"
