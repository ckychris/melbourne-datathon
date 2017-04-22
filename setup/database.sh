#!/bin/sh

# Set dir to this directory, regardless of where the script is running
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# cd to current directory for sql scripts to create in the correct directory
cd $DIR

DATA=../data
DB=../data/datasets.db

# Patients
echo "- patients"
sqlite3 $DB "
    CREATE TABLE patients
    (
    	Patient_ID	int
    ,	gender	varchar(1)
    ,	year_of_birth	smallint
    ,	postcode	varchar(4)
    )"

sqlite3 -separator $'\t' $DB ".import $DATA/raw/Lookups/patients.txt patients"
sqlite3 $DB "CREATE INDEX patients_PatientID_Index ON patients(Patient_ID);"

# Transactions
echo "- transactions"
sqlite3 $DB "
    CREATE TABLE transactions
    (
        Patient_ID  int
    ,   Store_ID    smallint
    ,   Prescriber_ID   int
    ,   Drug_ID smallint
    ,   SourceSystem_Code   varchar(1)
    ,   Prescription_Week   DATE
    ,   Dispense_Week   DATE
    ,   Drug_Code   varchar(37)
    ,   NHS_Code    varchar(6)
    ,   IsDeferredScript    tinyint
    ,   Script_Qty  smallint
    ,   Dispensed_Qty   smallint
    ,   MaxDispense_Qty smallint
    ,   PatientPrice_Amt    float
    ,   WholeSalePrice_Amt  float
    ,   GovernmentReclaim_Amt   float
    ,   RepeatsTotal_Qty    smallint
    ,   RepeatsLeft_Qty smallint
    ,   StreamlinedApproval_Code    smallint
    )"

for patient_transaction in $DATA/raw/Transactions/pat*
do
    echo $patient_transaction
    sqlite3 -separator $'\t' $DB ".import $patient_transaction transactions"
done

sqlite3 $DB "CREATE INDEX transactions_DrugID_Index ON transactions(Drug_ID);"
sqlite3 $DB "CREATE INDEX transactions_PatientID_Index ON transactions(Patient_ID);"

# ChronicIllness
echo "- chronic illness"
sqlite3 $DB "CREATE TABLE ChronicIllness_LookUp
(
    ChronicIllness  varchar(44)
,   MasterProductID smallint
,   MasterProductFullName   varchar(59)
)"

sqlite3 -separator $'\t' $DB ".import $DATA/raw/Lookups/ChronicIllness_LookUp.txt ChronicIllness_LookUp"
sqlite3 $DB "CREATE INDEX ChronicIllness_LookUp_MasterProductID_Index ON ChronicIllness_LookUp(MasterProductID);"

# stores
echo "- stores"
sqlite3 $DB "CREATE TABLE stores
(
	Store_ID	smallint
,	StateCode	varchar(3)
,	postcode	varchar(4)
,	IsBannerGroup	boolean
)"

sqlite3 -separator $'\t' $DB ".import $DATA/raw/Lookups/stores.txt stores"

# Drug_LookUp
echo "- drugs"
sqlite3 $DB "CREATE TABLE Drug_LookUp
(
    MasterProductID smallint
,   MasterProductCode   varchar(9)
,   MasterProductFullName   varchar(61)
,   BrandName   varchar(30)
,   FormCode    varchar(10)
,   StrengthCode    varchar(21)
,   PackSizeNumber  smallint
,   GenericIngredientName   varchar(30)
,   EthicalSubCategoryName  varchar(21)
,   EthicalCategoryName varchar(16)
,   ManufacturerCode    varchar(9)
,   ManufacturerName    varchar(27)
,   ManufacturerGroupID smallint
,   ManufacturerGroupCode   varchar(43)
,   ChemistListPrice    float
,   ATCLevel5Code   varchar(7)
,   ATCLevel4Code   varchar(5)
,   ATCLevel3Code   varchar(4)
,   ATCLevel2Code   varchar(3)
,   ATCLevel1Code   varchar(2)
)"

sqlite3 -separator $'\t' $DB ".import $DATA/raw/Lookups/Drug_LookUp.txt Drug_LookUp"
sqlite3 $DB "CREATE INDEX Drug_LookUp_MasterProductID_Index ON Drug_LookUp(MasterProductID);"

# ATC lookup
echo "- atc"
sqlite3 $DB "CREATE TABLE ATC_LookUp(
	ATCLevel1Code	varchar(2)
,	ATCLevel1Name	varchar(63)
,	ATCLevel2Code	varchar(3)
,	ATCLevel2Name	varchar(64)
,	ATCLevel3Code	varchar(4)
,	ATCLevel3Name	varchar(71)
,	ATCLevel4Code	varchar(5)
,	ATCLevel4Name	varchar(92)
,	ATCLevel5Code	varchar(7)
,	ATCLevel5Name	varchar(78)
)"

sqlite3 -separator $'\t' $DB ".import $DATA/raw/Lookups/ATC_LookUp.txt ATC_LookUp"

# Create socio economic table
echo "- social"
sqlite3 $DB "CREATE TABLE social
(
	postcode	smallint
,	advantage_score	smallint
,	disadvantage_score	smallint
,	economic_score	smallint
,	occupation_score	smallint
,   population smallint
)"

sqlite3 -separator $',' $DB ".import $DATA/extra/socio_mapping.csv social"

# classification table
echo "- classification (diabetes prescription in 2016)"
sqlite3 $DB "
    CREATE TABLE temp (Patient_ID  int);

    INSERT INTO temp SELECT * FROM (
    SELECT DISTINCT a.Patient_ID
    FROM transactions a
    INNER JOIN ChronicIllness_LookUp b
      ON a.Drug_ID = b.MasterProductID
    WHERE b.ChronicIllness = 'Diabetes'
      AND a.prescription_week >= '2016-01-01');


    CREATE TABLE classification (Patient_ID  int, Target int);

    INSERT INTO classification SELECT * FROM (
    	SELECT p.Patient_ID,
    	CASE WHEN res.Patient_ID IS NULL THEN 0 ELSE 1 END AS Target
    	FROM patients p
    	LEFT JOIN temp res
    	  ON p.Patient_ID=res.Patient_ID
    	);

    DROP TABLE temp;"
