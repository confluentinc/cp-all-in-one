#!/bin/bash

export ORACLE_HOME=/u01/app/oracle/product/12.2.0/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=${PATH}:${ORACLE_HOME}/bin
export TNS_ADMIN=${ORACLE_HOME}/admin/ORCLCDB

SQL_FILE=${1}

if [ -z "$SQL_FILE" ]; then
    sqlplus '/ as sysdba'
else
    sqlplus '/ as sysdba' @${SQL_FILE}
fi


