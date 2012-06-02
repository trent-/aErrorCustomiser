CREATE table "TS_ERROR_CODE" (
    "ERROR_CODE_ID" NUMBER NOT NULL,
    "CODE"          NUMBER NOT NULL,
    "DESCRIPTION"   VARCHAR2(4000) NOT NULL,
    "CAUSE"         VARCHAR2(4000) NOT NULL,
    "ACTION"        VARCHAR2(4000) NOT NULL,
    constraint  "TS_ERROR_CODE_PK" primary key ("ERROR_CODE_ID")
)
/

CREATE sequence "TS_ERROR_CODE_SEQ" 
/

CREATE trigger "BI_TS_ERROR_CODE"  
  before insert on "TS_ERROR_CODE"              
  for each row 
begin  
  if :NEW."ERROR_CODE_ID" is null then
    select "TS_ERROR_CODE_SEQ".nextval into :NEW."ERROR_CODE_ID" from dual;
  end if;
end;
/   

alter table "TS_ERROR_CODE" add
constraint "TS_ERROR_CODE_UK1" 
unique ("CODE")
/   

alter table "TS_ERROR_CODE" add
("SOURCE_URL" VARCHAR2(1000) NOT NULL)
/   