CREATE TABLE "TS_CONSRAINT_TYPE"
(
"TYPE" VARCHAR2(1 BYTE) NOT NULL ENABLE,
"DESCRIPTION"     VARCHAR2(50 BYTE) NOT NULL ENABLE,
CONSTRAINT "TS_CONSRAINT_TYPE_PK" PRIMARY KEY ("TYPE"));

/

REM INSERTING into TS_REF_INTEGRITY
REM NOTE:Not currently used
REM Based on information:  http://docs.oracle.com/cd/E11882_01/server.112/e25513/statviews_1046.htm#i1576022
SET DEFINE OFF;
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('C','Check constraint on a table');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('P','Primary key');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('U','Unique key');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('R','Referential integrity');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('V','With check option, on a view');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('O','With read only, on a view');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('H','Hash expression');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('F','Constraint that involves a REF column');
Insert into TS_CONSRAINT_TYPE (TYPE,DESCRIPTION) values ('S','Supplemental logging');


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


REM INSERTING into TS_CONSTRAINT_ERROR
SET DEFINE OFF;
Insert into TS_CONSTRAINT_ERROR (CONSTRAINT_NAME,ERROR_MESSAGE) values ('TS_PERSON_TS_PET_FK1','You must specify a valid reference ID to the pet table');
Insert into TS_CONSTRAINT_ERROR (CONSTRAINT_NAME,ERROR_MESSAGE) values ('TS_PERSON_UK1','Each person must have a unique name and age.');
Insert into TS_CONSTRAINT_ERROR (CONSTRAINT_NAME,ERROR_MESSAGE) values ('TS_PERSON_CHK1','We don''t allow young children in here. Please specify an age greater than 10.');
Insert into TS_CONSTRAINT_ERROR (CONSTRAINT_NAME,ERROR_MESSAGE) values ('TS_PERSON_PK','Please ensure the ID you entered doesn''t already exist.');

CREATE TABLE TS_PET 
(
ID NUMBER NOT NULL 
, TYPE VARCHAR2(20) NOT NULL 
, NAME VARCHAR2(200) NOT NULL 
, CONSTRAINT TS_PET_PK PRIMARY KEY 
(
ID 
)
ENABLE 
);


REM INSERTING into TS_PET
SET DEFINE OFF;
Insert into TS_PET (ID,TYPE,NAME) values (1,'Dog','Roger');
Insert into TS_PET (ID,TYPE,NAME) values (2,'Cat','Michelle');


CREATE TABLE TS_PERSON 
(
ID NUMBER NOT NULL 
, NAME VARCHAR2(50 BYTE) 
, AGE NUMBER NOT NULL 
, PET_ID NUMBER 
, CONSTRAINT TS_PERSON_PK PRIMARY KEY 
(
ID 
)
ENABLE 
);

ALTER TABLE TS_PERSON
ADD CONSTRAINT TS_PERSON_UK1 UNIQUE 
(
NAME 
, AGE 
)
ENABLE;

ALTER TABLE TS_PERSON
ADD CONSTRAINT TS_PERSON_TS_PET_FK1 FOREIGN KEY
(
PET_ID 
)
REFERENCES TS_PET
(
ID 
)
ENABLE;

ALTER TABLE TS_PERSON
ADD CONSTRAINT TS_PERSON_CHK1 CHECK 
(AGE > 10)
ENABLE;

REM INSERTING into TS_PERSON
SET DEFINE OFF;
Insert into TS_PERSON (ID,NAME,AGE,PET_ID) values (1,'John',12,null);

