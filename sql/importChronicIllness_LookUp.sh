#!/bin/bash
# Creates ChronicIllness_Lookup
# Imports all ChronicIllness_LookUp data into sqlite db

DATA=~/Projects/datasci/data
DB=datasci.db

# Create ATC_LookUp Table in database
sqlite3 $DB "CREATE TABLE ChronicIllness_LookUp
(
    ChronicIllness  varchar(44)
,   MasterProductID smallint
,   MasterProductFullName   varchar(59)
)"

sqlite3 -separator $'\t' $DB ".import $DATA/Lookups/ChronicIllness_LookUp.txt ChronicIllness_LookUp"
