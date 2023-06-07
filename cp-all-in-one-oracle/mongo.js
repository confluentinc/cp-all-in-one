pasos

password de sys 


ALTER USER SYS IDENTIFIED BY new_password;


/*** como conectarse**/
docker exec -it oracle "bash"
/*** Dentro del contenedor */ 
sqlplus 'sys / as sysdba'


alter session set "_ORACLE_SCRIPT"=true;  

/// mas cosas
alter session set "_ORACLE_SCRIPT"=true; 
CREATE USER super IDENTIFIED BY abcd1234;
GRANT ALL PRIVILEGES TO super;


/**1 - As SYSDBA, enter the following SQL commands to create the role and grant privileges to the role. See Step 3 if using a Database Vault and Step 4 for an Oracle 12c database. */
CREATE ROLE CDC_PRIVS3;
GRANT CREATE SESSION,
  EXECUTE_CATALOG_ROLE,
  SELECT ANY TRANSACTION,
  SELECT ANY DICTIONARY
  TO CDC_PRIVS3;
GRANT SELECT ON SYSTEM.LOGMNR_COL$ TO CDC_PRIVS3;
GRANT SELECT ON SYSTEM.LOGMNR_OBJ$ TO CDC_PRIVS3;
GRANT SELECT ON SYSTEM.LOGMNR_USER$ TO CDC_PRIVS3;
GRANT SELECT ON SYSTEM.LOGMNR_UID$ TO CDC_PRIVS3;


/**2- Create a username, password, and grant privileges for the user. You can use any username and password. */


CREATE USER myuser3 IDENTIFIED BY password DEFAULT TABLESPACE USERS;
GRANT CDC_PRIVS3 TO myuser3;
ALTER USER myuser3 QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO myuser3;
GRANT SELECT ON myuser3.customers TO myuser3;

///grant create table to myuser3;

GRANT SELECT ON myuser2.table2 TO myuser2;

/**(If using Oracle 12c) Enter the following command: */

GRANT LOGMINING TO CDC_PRIVS3;


//

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
ALTER TABLE myuser3.table1 ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;

//
curl -s -X POST -H 'Content-Type: application/json' --data @config1.json http://localhost:8083/connectors | jq

curl -s -X GET -H 'Content-Type: application/json' http://localhost:8083/connectors/OracleCDC_Mariposon2/status | jq


// test3 ---> descarto raro!!


CREATE ROLE C##CDC_PRIVS;
GRANT CREATE SESSION, EXECUTE_CATALOG_ROLE, SELECT ANY TRANSACTION, SELECT ANY DICTIONARY TO C##CDC_PRIVS;
GRANT SELECT ON SYSTEM.LOGMNR_COL$ TO C##CDC_PRIVS;
GRANT SELECT ON SYSTEM.LOGMNR_OBJ$ TO C##CDC_PRIVS;
GRANT SELECT ON SYSTEM.LOGMNR_USER$ TO C##CDC_PRIVS;
GRANT SELECT ON SYSTEM.LOGMNR_UID$ TO C##CDC_PRIVS;

CREATE USER C##myuser IDENTIFIED BY password CONTAINER=ALL;
GRANT C##CDC_PRIVS TO C##myuser CONTAINER=ALL;
ALTER USER C##myuser QUOTA UNLIMITED ON USERS;
ALTER USER C##myuser SET CONTAINER_DATA = (CDB$ROOT, <pdb name>) CONTAINER=CURRENT;

ALTER SESSION SET CONTAINER=CDB$ROOT;
GRANT CREATE SESSION, ALTER SESSION, SET CONTAINER, LOGMINING, EXECUTE_CATALOG_ROLE TO C##myuser CONTAINER=ALL;
GRANT SELECT ON GV_$DATABASE TO C##myuser CONTAINER=ALL;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO C##myuser CONTAINER=ALL;
GRANT SELECT ON GV_$ARCHIVED_LOG TO C##myuser CONTAINER=ALL;
GRANT CONNECT TO C##myuser CONTAINER=ALL;
GRANT SELECT ON <db>.<table> TO C##myuser;



confluent-hub install confluentinc/kafka-connect-oracle-cdc:1.1.1

kafka-topics --create --topic oracle-redo-log-topic \
--bootstrap-server broker:29092 --replication-factor 1 \
--partitions 1 --config cleanup.policy=delete \
--config retention.ms=120960000

///nueva version

CREATE ROLE CDC_PRIVS;
GRANT CREATE SESSION TO CDC_PRIVS;
GRANT EXECUTE ON SYS.DBMS_LOGMNR TO CDC_PRIVS;
GRANT LOGMINING TO CDC_PRIVS;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO CDC_PRIVS;
GRANT SELECT ON V_$DATABASE TO CDC_PRIVS;
GRANT SELECT ON V_$THREAD TO CDC_PRIVS;
GRANT SELECT ON V_$PARAMETER TO CDC_PRIVS;
GRANT SELECT ON V_$NLS_PARAMETERS TO CDC_PRIVS;
GRANT SELECT ON V_$TIMEZONE_NAMES TO CDC_PRIVS;
GRANT SELECT ON ALL_INDEXES TO CDC_PRIVS;
GRANT SELECT ON ALL_OBJECTS TO CDC_PRIVS;
GRANT SELECT ON ALL_USERS TO CDC_PRIVS;
GRANT SELECT ON ALL_CATALOG TO CDC_PRIVS;
GRANT SELECT ON ALL_CONSTRAINTS TO CDC_PRIVS;
GRANT SELECT ON ALL_CONS_COLUMNS TO CDC_PRIVS;
GRANT SELECT ON ALL_TAB_COLS TO CDC_PRIVS;
GRANT SELECT ON ALL_IND_COLUMNS TO CDC_PRIVS;
GRANT SELECT ON ALL_ENCRYPTED_COLUMNS TO CDC_PRIVS;
GRANT SELECT ON ALL_LOG_GROUPS TO CDC_PRIVS;
GRANT SELECT ON ALL_TAB_PARTITIONS TO CDC_PRIVS;
GRANT SELECT ON SYS.DBA_REGISTRY TO CDC_PRIVS;
GRANT SELECT ON SYS.OBJ$ TO CDC_PRIVS;
GRANT SELECT ON DBA_TABLESPACES TO CDC_PRIVS;
GRANT SELECT ON DBA_OBJECTS TO CDC_PRIVS;
GRANT SELECT ON SYS.ENC$ TO CDC_PRIVS;

GRANT SELECT ON super.table1 TO CDC_PRIVS;

GRANT SELECT ON myuser.table1 TO CDC_PRIVS3;


/**2- Create a username, password, and grant privileges for the user. You can use any username and password. */


CREATE USER MYUSER IDENTIFIED BY password DEFAULT TABLESPACE USERS;
ALTER USER MYUSER QUOTA UNLIMITED ON USERS;

GRANT CDC_PRIVS to MYUSER;



///otras configuaracions

docker exec -it oracle bash -c "source /home/oracle/.bashrc; sqlplus /nolog"

sqlplus '/ as sysdba'


SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

LTER DATABASE ARCHIVELOG;

ALTER DATABASE OPEN;


///Enable supplemental logging for all columns



ALTER SESSION SET CONTAINER=cdb$root;


ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;



ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

ALTER TABLE super.table1 ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;



Grant the user Flashback query privileges


GRANT FLASHBACK ANY TABLE TO myuser;

GRANT FLASHBACK ON super.table1 TO myuser;


//no estoy seguro

GRANT FLASHBACK ON super.table1 TO CDC_PRIVS;



/// comprobar redo https://www.dbasupport.com.mx/index.php/bases-de-datos/oracle/oracle-administracion/167-como-auditar-acciones-del-pasado-mediante-oracle-logminer

select name, SEQUENCE#, to_char(FIRST_TIME, 'DD-Mon-YY HH24:Mi:SS') as TIME_Changes
from v$archived_log



/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_23_jbpy9gkv_.arc
/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_24_jbpy9jog_.arc
/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_25_jbpylfcq_.arc


2) Ya hemos detectado que entre esos rangos de tiempo se generaron 4 archives. Pues vamos a revisar qué contienen.

Primero debemos de añadir, en nuestra sesión, los metadatos de esos archives que vamos a revisar:

SQL> exec DBMS_LOGMNR.ADD_LOGFILE('/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_23_jbpy9gkv_.arc');
SQL> exec DBMS_LOGMNR.ADD_LOGFILE('/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_24_jbpy9jog_.arc');
SQL> exec DBMS_LOGMNR.ADD_LOGFILE('/u03/app/oracle/fast_recovery_area/ORCLCDB/archivelog/2021_05_24/o1_mf_1_25_jbpylfcq_.arc');


3) Ahora arrancamos la sesión de LogMiner.

SQL> exec dbms_logmnr.start_logmnr();

PL/SQL procedure successfully completed.


4) Ahora ya puedes consultar la vista V$LOGMNR_CONTENTS, la cual tendrá comandos para rehacer cambios, comandos ejecutados, horario exacto, etc.

Por ejemplo, para ver las fechas a revisar:
select min(to_char(COMMIT_TIMESTAMP,'DD/Mon/YY HH24:Mi:SS')) from V$LOGMNR_CONTENTS;

select min(to_char(COMMIT_TIMESTAMP,'DD/Mon/YY HH24:Mi:SS')) MIN,
max(to_char(COMMIT_TIMESTAMP,'DD/Mon/YY HH24:Mi:SS')) MAX
from V$LOGMNR_CONTENTS;

MIN                      MAX
------------------------ ------------------------
03/Jun/08 14:48:03       03/Jun/08 16:14:46


6) Como podrás ver, no es tan fácil la lectura... Aparecen Object_IDs en lugar de Nombres de Tablas, números de columnas en lugar de sus nombres, etc... PERO para hacerlo fácil...

EXECUTE DBMS_LOGMNR.START_LOGMNR(OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);


7) Ahora ejecuta de nuevo tu select y ya verás completamente comprensibles, a simple vista, los resultados:

SQL> select USERNAME, SQL_REDO from V$LOGMNR_CONTENTS where rownum < 10;



//// otra opcion mas

kafka-topics --bootstrap-server broker:29092 --create --partitions 1 --replication-factor 1 --topic ORCLCDB.C__MYUSER.EMP
kafka-topics --bootstrap-server broker:29092 --create --partitions 1 --replication-factor 1 --topic SimpleOracleCDC-ORCLCDB-redo-log
