#!/bin/bash
#----------------------------------------------------------------------
# Script to make a single concatenated text file
#
# Should be called from the .../MelbDatathon2017/Transactions/
#   directory
#----------------------------------------------------------------------

head -1 patients_1.txt > all_patients.txt

for f in patients_*.txt ; do
    echo ${f}
    grep -v ^Patient_ID ${f} >> all_patients.txt
done

#----------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------
