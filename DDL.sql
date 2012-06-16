CREATE TABLE "TS_REF_INTEGRITY"
  (
    "CONSTRAINT_TYPE" VARCHAR2(1 BYTE) NOT NULL ENABLE,
    "DESCRIPTION"     VARCHAR2(50 BYTE) NOT NULL ENABLE,
    CONSTRAINT "TS_REF_INTEGRITY_PK" PRIMARY KEY ("CONSTRAINT_TYPE"));

/

REM INSERTING into TS_REF_INTEGRITY
REM NOTE:Not currently used
REM Based on information:  http://docs.oracle.com/cd/E11882_01/server.112/e25513/statviews_1046.htm#i1576022
SET DEFINE OFF;
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('C','Check constraint on a table');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('P','Primary key');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('U','Unique key');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('R','Referential integrity');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('V','With check option, on a view');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('O','With read only, on a view');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('H','Hash expression');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('F','Constraint that involves a REF column');
Insert into TS_REF_INTEGRITY (CONSTRAINT_TYPE,DESCRIPTION) values ('S','Supplemental logging');


CREATE TABLE TS_CONSTRAINT_ERROR
(
  ID NUMBER NOT NULL 
, CONSTRAINT_NAME VARCHAR2(30) NOT NULL 
, ERROR_MESSAGE VARCHAR2(400) NOT NULL 
, CONSTRAINT TS_CONSTRAINT_ERRORS_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

create sequence seq_TS_CONSTRAINT_ERROR;
/


  CREATE OR REPLACE TRIGGER "BI_TS_CONSTAINT_ERROR" 
   before insert on "TS_CONSTRAINT_ERROR" 
   for each row 
begin  
         select seq_TS_CONSTRAINT_ERROR.nextval into :NEW."ID" from dual; 
end;

/
ALTER TRIGGER "BI_TS_CONSTAINT_ERROR" ENABLE;
/

ALTER TABLE TS_CONSTRAINT_ERROR
ADD CONSTRAINT TS_CONSTRAINT_ERROR_UK1 UNIQUE 
(
  CONSTRAINT_NAME 
)
ENABLE;