--DDL Triggers

--CREATE ALTER DROP
--Introduced in 2010

/*We create DDL Triggers on Databases or Servers
If we create a Trigger at database level it will fire only in the database level
And if we create a Trigger ar server level it will fire for the objects in the Server level*/


--Creating Trigger on Database

USE StudentEnrollment
GO

CREATE TRIGGER trg_IdentifyTableSchemaChanges
ON Database
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE, CREATE_PROCEDURE

AS
BEGIN
		PRINT 'A Table/Procedure is being modified or created'
END

--Creating Table

CREATE TABLE Station
(
Id INT,
City VARCHAR(50)
);
--A Table/Procedure is being modified or created

--Altering Trigger

ALTER TRIGGER trg_IdentifyTableSchemaChanges
ON Database
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE, CREATE_PROCEDURE

AS
BEGIN
	ROLLBACK
		PRINT 'A Table/Procedure is being modified or created'
END

ALTER TABLE Station
ADD CONSTRAINT UK_Id UNIQUE (Id)

/*A Table/Procedure is being modified or created
Msg 3609, Level 16, State 2, Line 46
The transaction ended in the trigger. The batch has been aborted.*/

DISABLE TRIGGER trg_IdentifyTableSchemaChanges ON Database
