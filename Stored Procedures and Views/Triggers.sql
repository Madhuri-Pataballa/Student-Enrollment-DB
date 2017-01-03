--Triggers

USE StudentEnrollmentDB
GO
--DML Triggers

CREATE TABLE dbo.Employee
(
	EmployeeId INT IDENTITY(1,1),
	EmployeeName VARCHAR(50),
	EmployeeSalary DECIMAL(10,2),
	EmployeePosition VARCHAR(20)
);

CREATE TABLE dbo.Employee_Audit
(
	EmployeeId INT,
	EmployeeName VARCHAR(50),
	EmployeeSalary DECIMAL(10,2),
	EmployeePosition VARCHAR(20),
	AuditAction VARCHAR(250),
	AuditActionTime DATETIME
);

INSERT INTO dbo.Employee (EmployeeName, EmployeeSalary, EmployeePosition)
VALUES ('Rekha', 100000.00, 'Engineer I'),
       ('Madhu', 110000.00, 'Engineer II')

-- Before Insert
CREATE TRIGGER dbo.trg_Employee_BeforeInsert ON dbo.Employee
INSTEAD OF INSERT -- this tells what kind of trigger this is
AS
BEGIN
	-- variable declaration
	DECLARE @EmployeeId INT,
			@EmployeeName VARCHAR(50),
			@EmployeeSalary DECIMAL(10,2),
			@EmployeePosition VARCHAR(20),
			@AuditAction VARCHAR(250),
			@AuditActionTime DATETIME 
	
	SELECT @EmployeeId = IDENT_CURRENT('Employee') + 1
	SELECT @EmployeeName = i.EmployeeName FROM inserted AS i
	SELECT @EmployeeSalary = i.EmployeeSalary FROM inserted AS i
	SELECT @EmployeePosition = i.EmployeePosition FROM inserted AS i

	SET @AuditAction = 'Before Insert'
	SET @AuditActionTime = GETDATE()

	INSERT INTO dbo.Employee (EmployeeName, EmployeeSalary, EmployeePosition)
	SELECT EmployeeName, EmployeeSalary, EmployeePosition
	FROM inserted

	INSERT INTO dbo.Employee_Audit (EmployeeId, EmployeeName, EmployeeSalary, EmployeePosition, AuditAction, AuditActionTime)
	SELECT E.EmployeeId, i.EmployeeName, i.EmployeeSalary, i.EmployeePosition, @AuditAction, @AuditActionTime
	FROM inserted i
	JOIN dbo.Employee E
		ON i.EmployeeName = E.EmployeeName

END





SELECT * FROM dbo.Employee
SELECT * FROM dbo.Employee_Audit



DROP TABLE Employee
DROP TABLE Employee_Audit


-- Before Update
ALTER TRIGGER dbo.trg_Employee_BeforeUpdate ON dbo.Employee
INSTEAD OF UPDATE -- this tells what kind of trigger this is
AS
BEGIN
	-- variable declaration
	DECLARE @EmployeeId INT,
			@EmployeeName VARCHAR(50),
			@EmployeeSalary DECIMAL(10,2),
			@EmployeePosition VARCHAR(20),
			@AuditAction VARCHAR(250),
			@AuditActionTime DATETIME 
	
	SELECT @EmployeeId = i.EmployeeId FROM inserted AS i
	SELECT @EmployeeName = i.EmployeeName FROM inserted AS i
	SELECT @EmployeeSalary = i.EmployeeSalary FROM inserted AS i
	SELECT @EmployeePosition = i.EmployeePosition FROM inserted AS i

	SET @AuditAction = 'Before Update'
	SET @AuditActionTime = GETDATE()


	INSERT INTO dbo.Employee_Audit (EmployeeId, EmployeeName, EmployeeSalary, EmployeePosition, AuditAction, AuditActionTime)
	SELECT i.EmployeeId, i.EmployeeName, i.EmployeeSalary, i.EmployeePosition, @AuditAction, @AuditActionTime
	FROM inserted i

	UPDATE E
	SET EmployeeName = @EmployeeName,
		EmployeeSalary = @EmployeeSalary,
		EmployeePosition = @EmployeePosition
	FROM Employee E
	WHERE E.EmployeeId = @EmployeeId


END


SELECT * FROM Employee
SELECT * FROM Employee_Audit

DELETE FROM Employee WHERE EmployeeId = 2 

UPDATE Employee
SET EmployeeSalary = 180000.00
WHERE EmployeeId = 1


-- Before Delete
CREATE TRIGGER dbo.trg_Employee_BeforeDelete ON dbo.Employee
INSTEAD OF DELETE -- this tells what kind of trigger this is
AS
BEGIN
	-- variable declaration
	DECLARE @EmployeeId INT,
			@EmployeeName VARCHAR(50),
			@EmployeeSalary DECIMAL(10,2),
			@EmployeePosition VARCHAR(20),
			@AuditAction VARCHAR(250),
			@AuditActionTime DATETIME 
	
	SELECT @EmployeeId = d.EmployeeId FROM deleted AS d
	SELECT @EmployeeName = d.EmployeeName FROM deleted AS d
	SELECT @EmployeeSalary = d.EmployeeSalary FROM deleted AS d
	SELECT @EmployeePosition = d.EmployeePosition FROM deleted AS d

	SET @AuditAction = 'Before Delete'
	SET @AuditActionTime = GETDATE()

	DELETE FROM dbo.Employee
	WHERE EmployeeId IN (SELECT EmployeeId FROM deleted)

	INSERT INTO dbo.Employee_Audit (EmployeeId, EmployeeName, EmployeeSalary, EmployeePosition, AuditAction, AuditActionTime)
	SELECT d.EmployeeId, d.EmployeeName, d.EmployeeSalary, d.EmployeePosition, @AuditAction, @AuditActionTime
	FROM deleted d

END

-- To disable triggers
ALTER TABLE dbo.Employee DISABLE TRIGGER ALL
ALTER TABLE dbo.Employee ENABLE TRIGGER trg_Employee_BeforeUpdate






ALTER TRIGGER dbo.trg_Employee_AfterInsert ON dbo.Employee
AFTER INSERT
AS
BEGIN
	-- variable declaration
	DECLARE @EmployeeId INT,
			@EmployeeName VARCHAR(50),
			@EmployeeSalary DECIMAL(10,2),
			@EmployeePosition VARCHAR(20),
			@AuditAction VARCHAR(250),
			@AuditActionTime DATETIME 
	
	--SELECT @EmployeeId = d.EmployeeId FROM inserted AS d
	--SELECT @EmployeeName = d.EmployeeName FROM inserted AS d
	--SELECT @EmployeeSalary = d.EmployeeSalary FROM inserted AS d
	--SELECT @EmployeePosition = d.EmployeePosition FROM inserted AS d
	
	SELECT @AuditAction = 'After Insert'
	SELECT @AuditActionTime = GETDATE()

	INSERT INTO Employee_Audit (EmployeeId, EmployeeName, EmployeeSalary, EmployeePosition, AuditAction, AuditActionTime)
	SELECT i.EmployeeId, i.EmployeeName, i.EmployeeSalary, i.EmployeePosition, @AuditAction, @AuditActionTime
	FROM inserted i
END

SELECT * FROM Employee WHERE EmployeeId = 3
SELECT * FROM Employee_Audit WHERE EmployeeId = 3

INSERT INTO dbo.Employee (EmployeeName, EmployeePosition, EmployeeSalary)
SELECT 'Saranya', 'Sr. Engineeer', 200000


CREATE TRIGGER dbo.trg_Employee_AfterDelete ON dbo.Employee
FOR DELETE
AS
BEGIN
	-- variable declaration
	DECLARE @EmployeeId INT,
			@EmployeeName VARCHAR(50),
			@EmployeeSalary DECIMAL(10,2),
			@EmployeePosition VARCHAR(20),
			@AuditAction VARCHAR(250),
			@AuditActionTime DATETIME 
	
	--SELECT @EmployeeId = d.EmployeeId FROM inserted AS d
	--SELECT @EmployeeName = d.EmployeeName FROM inserted AS d
	--SELECT @EmployeeSalary = d.EmployeeSalary FROM inserted AS d
	--SELECT @EmployeePosition = d.EmployeePosition FROM inserted AS d
	
	SELECT @AuditAction = 'After Delete'
	SELECT @AuditActionTime = GETDATE()

	INSERT INTO Employee_Audit (EmployeeId, EmployeeName, EmployeeSalary, EmployeePosition, AuditAction, AuditActionTime)
	SELECT d.EmployeeId, d.EmployeeName, d.EmployeeSalary, d.EmployeePosition, @AuditAction, @AuditActionTime
	FROM deleted d
END

SELECT * FROM Employee WHERE EmployeeId = 3
SELECT * FROM Employee_Audit WHERE EmployeeId = 3

UPDATE Employee
SET EmployeeSalary = 250000
WHERE EmployeeId = 3

DELETE FROM Employee WHERE EmployeeId = 3




