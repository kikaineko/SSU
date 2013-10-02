. ../../ssu/SSU.sh

SSU_JAVA_CMD=/usr/java/j2sdk1.4.2_19/bin/java

setUp(){
  u_db_delete "NUMBERS" >/dev/null
  u_db_delete "CHARS" >/dev/null
  u_db_delete "DATETIMES" >/dev/null
}

test_numbers() {
  h_make_file n
  echo "SMALLINT,INTEGER,BIGINT,REAL,DOUBLE,FLOAT,DECIMAL,NUMERIC" >n
  
  echo "1,,,,,,," >>n
  echo ",1,,,,,," >>n
  echo ",,1,,,,," >>n
  echo ",,,1.0,,,," >>n
  echo ",,,,1.0,,," >>n
  echo ",,,,,1.0,," >>n
  echo ",,,,,,10.0," >>n
  echo ",,,,,,,10.0" >>n

  echo "\"1\",,,,,,," >>n
  echo ",\"1\",,,,,," >>n
  echo ",,\"1\",,,,," >>n
  echo ",,,\"1.0\",,,," >>n
  echo ",,,,\"1.0\",,," >>n
  echo ",,,,,\"1.0\",," >>n
  echo ",,,,,,\"10.0\"," >>n
  echo ",,,,,,,\"10.0\"" >>n
  
  u_db_insert n "NUMBERS"
  assert_db n "NUMBERS"
}

test_chars() {
  h_make_file c  
  echo "CHAR,VARCHAR,LONGVARCHAR" >c
  
  echo ",," >>c
  echo "a,," >>c
  echo ",a," >>c
  echo ",,a" >>c

  echo ",'," >>c
  echo "\"a\",," >>c
  echo ",\"a\"," >>c
  echo ",,\"a\"" >>c
  
  u_db_insert c "CHARS"
  assert_db c "CHARS"
}

test_datetimes() {
  h_make_file d
  echo "DATE,TIME,TIMESTAMP" >d
  
  echo "2009-01-02,," >>d
  echo ",03:00:00," >>d
  echo ",03.00.01," >>d
  echo ",04:00 AM," >>d
  echo ",05:00 am," >>d
  echo ",06:00 PM," >>d
  echo ",07:00 pm," >>d
  echo ",,2009-05-15-00.01.02.333333" >>d
  echo ",,2009-05-15-00.01.02.444" >>d
  echo ",,2009-05-15 00:01:02.5" >>d
  
  u_db_insert d "DATETIMES"
  assert_db d "DATETIMES"
}

SSU_SELFPATH="../../ssu"

SSU_JDBC_JAR="/opt/ibm/db2/V9.1/java/db2jcc.jar"
SSU_JDBC_EXT_JAR="/opt/ibm/db2/V9.1/java/db2jcc_license_cu.jar"
SSU_JDBC_CLASS="com.ibm.db2.jcc.DB2Driver";
SSU_JDBC_URL="jdbc:db2://localhost:50010/SAMPLE";
SSU_JDBC_USER="db2inst1";
SSU_JDBC_PASSWORD="db2inst1";

date
#TARGET_TEST_PATTERN=""
#DEBUG_MODE=ON
startSSU;
date
