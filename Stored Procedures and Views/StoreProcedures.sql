--Store Procedures

--DDL For Store Procedures

CREATE PROCEDURE dbo.usp_name(@Parameter1, @Parameter2)
AS
BEGIN
	SELECT * FROM dbo.Table
	WHERE Col1 = @Parameter1
	AND
	Col2 = @Parameter2
END;


SELECT * FROM Student.StudentAddress;

--Example

CREATE PROCEDURE dbo.USP_GetStudents(@City VARCHAR(50), @State  CHAR(2))
AS
BEGIN
	SELECT TotalStudents = COUNT(*)
	FROM Student.StudentAddress
	WHERE  City = @City
	AND State = @State
END;

EXEC dbo.USP_GetStudents
@City = 'Redmond',
@State = 'WA';

--Creating Table inside A StoreProcedure
CREATE PROCEDURE dbo.USP_GetStudentDetails(@City VARCHAR(50), @State  CHAR(2))
AS
BEGIN
	INSERT INTO dbo.Table (State, Gender, LowerAgeLimit, UpperrAgeLimit)
	VALUES (@State, @Gender, @LowerAgeLimit, @UpperrAgeLimit)
END;

--StoreProcedure without Input Parameter
ALTER PROCEDURE dbo.USP_GetStudents
AS
BEGIN
	SELECT * FROM dbo.Table
	JOIN dbo.Table
	ON ----

END;

--Create StoreProcedure by taking Student Name as an Input Parameter and get Student Age as OUTPUT, By declaring output Parameter
CREATE PROC dbo.USP_GetAgeOfStudent(@StudentName VARCHAR(50), @StudentAge INT OUTPUT)
AS
BEGIN
	SELECT @StudentAge = dbo.ufnGetStudentAge(StudentID)
	FROM Student.Students
	WHERE Student_First_Name+' '+Student_Last_Name = @StudentName
END

DECLARE @Age INT
EXEC dbo.USP_GetAgeOfStudent
@StudentName = 'Srinivas Munjuluri', @StudentAge = @Age OUTPUT
SELECT @Age

SELECT * FROM Student.Students;

--Using OUTPUT of an 1 Store Procedure into another Store Procedure
ALTER PROC dbo.USP_StudentDetails(@StudentFullName VARCHAR(50))
AS
BEGIN
	DECLARE @Age INT
	EXEC dbo.USP_GetAgeOfStudent
	@StudentName = @StudentFullName,
	@StudentAge = @Age OUTPUT

	SELECT StudentID, @StudentFullName AS StudentName, @Age AS StudentAge
	FROM Student.Students
	WHERE Student_First_Name+' '+Student_Last_Name = @StudentFullName
END

EXEC dbo.USP_StudentDetails
@StudentFullName = 'Madhu Ayyagari'


--Default Parameters

SELECT YEAR(GetDate()); --to get year from the datetime value.

CREATE PROC dbo.usp_GetData
(
@YearOfBirth INT = NULL,
@Gender VARCHAR(30) = NULL
)
AS
BEGIN
	SELECT * FROM Student.Students
	WHERE (YEAR(DateOfBirth) = @YearOfBirth OR @YearOfBirth IS NULL)
	AND (Gender = @Gender OR @Gender IS NULL)
END

EXEC dbo.usp_GetData
@Gender = 'F',
@YearOfBirth = 1988

--Error Handing
--It is used to enforced the code to run sucessfuly withut throughing any errors. It is mainly used in StoreProcecdures

--Without Error Handling
ALTER PROC dbo.usp_NoErrorHandling
(
@Value1 INT,
@Value2 INT
)
AS
BEGIN
	SELECT @Value1/@Value2 AS DesiredOutput
END

EXEC dbo.usp_NoErrorHandling
235, 0


--With Error Handling
CREATE PROC dbo.usp_WithErrorHandling
(
@Value1 INT,
@Value2 INT
)
AS
BEGIN
	BEGIN TRY
		SELECT @Value1/@Value2 AS DesiredOutput
	END TRY
	BEGIN CATCH
		SELECT Error_Number() AS ErrorNumber,
			Error_Message() AS ErrorMessage
	END CATCH
END

EXEC dbo.usp_WithErrorHandling
234, NULL


--RealTime Senario

CREATE PROC dbo.usp_MoveData 
(
@BatchID INT
)
AS
BEGIN
	WHILE (Loop_condition)
BEGIN
	BEGIN TRY
		INSERT INTO LogBatch(BatchID, TableName, StartTime, EndTime, ErrorMessage, ErrorNumber, TableStatus)
		VALUES (@BatchID, @TableName, GETDATE(), NULL, NULL, NULL, NULL)

		INSERT INTO @TableName
		SELECT * FROM @SourceTableName

		UPDATE LogBatch
		SET EndDate = GETDATE(),
		TableStatus = 'Success'
	WHERE BatchID = @BatchID
	AND TableName = 'Table1'
	END TRY
		BEGIN CATCH
			UPDATE LogBatch
			SET ErrorMessage = Error_Message(),
				ErrorNumber = Error_Number(),
				TableStatus = 'Failure',
				EndDate = GETDATE()
			WHERE(BatchID = @BatchID
			AND TableName = @Table)
		END CATCH
	END
END


SELECT * FROM Student.StudentEnrollmentDetails;
SELECT * FROM Student.StudentEvents;

--Creating Store Procedure for assigning values in the parameters from the tables

CREATE PROC dbo.usp_InsertStudentDetailsNew
(
@StudentFirstName VARCHAR(100),
@StudentLastName VARCHAR(100),
@ProfessorFirstName VARCHAR(100),
@ProfessorLastName VARCHAR(100),
@CourseName VARCHAR(50),
@TermName VARCHAR(10),
@EventName VARCHAR(50)
)
AS
BEGIN

--Declaration of variables
	DECLARE @StudentID INT,
			@CourseID INT,
			@TermID INT,
			@ProfessorID INT,
			@EventID INT

--Derive StudentID Using FirstName and LastNme Input parameters
		SELECT @StudentID = StudentID
		FROM Student.Students
		WHERE Student_First_Name = @StudentFirstName
		AND Student_Last_Name = @StudentLastName

--Derive CourseID From CourseNAme Input parameter
		SELECT @CourseID = CourseID
		FROM Student.Course
		WHERE Course_Name = @CourseName

--Derive ProessorID From ProfessorName Input parameter
		SELECT @ProfessorID = ProfessorID
		FROM Student.Professor
		WHERE Professor_First_Name = @ProfessorFirstName
		AND Professor_Last_Name = @ProfessorLastName

--Derive TermID From TermName Input parameter
		SELECT @TermID = TermID
		FROM Student.Term
		WHERE Term_Name = @TermName

--Derive EventID From EventName Input parameter
		SELECT @EventID = SE.StudentEventID
		FROM Student.Students AS S
		JOIN Student.StudentEvents AS SE
		ON S.StudentID = SE.StudentID
		JOIN Student.Events AS E
		ON SE.EventID = E.EventID
		WHERE S.StudentID = @StudentID
		AND E.Event_Name = @EventName

IF
	(SELECT COUNT(1)
	FROM Student.StudentEnrollmentDetails
	WHERE StudentID = @StudentID
	AND CourseID = @CourseID
	AND TermID = @TermID
	AND ProfessorID = @ProfessorID
	AND StudentEventID = @EventID
	) = 1

	BEGIN
		PRINT 'Data already exists int he table Student.StudentEnrollmentDetails';
		PRINT 'Below are the ID values for the given input parametrs'
		PRINT '@StudentID : ' + CAST(@StudentID AS VARCHAR(20))
		PRINT '@ProfessorID : ' + CAST(@ProfessorID AS VARCHAR(20))
		PRINT '@CourseID : ' + CAST(@CourseID AS VARCHAR(20))
		PRINT '@TermID : ' + CAST(@TermID AS VARCHAR(20))
		PRINT '@EventID : ' + CAST(@EventID AS VARCHAR(20))
	END

ELSE
	BEGIN
		IF(@StudentID is NOT NULL AND @TermID is NOT NULL)
			INSERT INTO Student.StudentEnrollmentDetails
			(StudentID, CourseID, ProfessorID, TermID, StudentEventID)
			VALUES (@StudentID, @CourseID, @ProfessorID, @TermID, @EventID)

			PRINT 'Below are the ID values inserted into Student.StudentEnrollmentDetails'
			PRINT '@StudentID : ' + CAST(@StudentID AS VARCHAR(20))
			PRINT '@ProfessorID : ' + CAST(@ProfessorID AS VARCHAR(20))
			PRINT '@CourseID : ' + CAST(@CourseID AS VARCHAR(20))
			PRINT '@TermID : ' + CAST(@TermID AS VARCHAR(20))
			PRINT '@EventID : ' + CAST(@EventID AS VARCHAR(20))
		END
		ELSE 'One of the Input Parameter value is wrongly inserted'
	END
END

EXEC dbo.usp_InsertStudentDetailsNew



SELECT * FROM Student.StudentEnrollmentDetails;


--Creating VIEW to get StudentNames for tthe studentID in StudentEnrollmentDetails

CREATE VIEW dbo.vw_GetStudentEnrollmentDetails
AS
	SELECT SED.StudentID, S.Student_First_Name, S.Student_Last_Name,
	P.ProfessorID, P.Professor_First_Name, P.Professor_Last_Name,
	C.CourseID, C.Course_Name,
	T.TermID, T.Term_Name,
	G.GradeID, G.Grade_Value, G.Grade_Code,
	SE.StudentEventID, E.EventID, E.Event_Name
	 
	FROM Student.StudentEnrollmentDetails AS SED
	LEFT JOIN Student.Students AS S
	ON SED.StudentID = S.StudentID
	LEFT JOIN Student.Course AS C
	ON SED.CourseID = C.CourseID
	LEFT JOIN Student.Professor AS P
	ON SED.ProfessorID = P.ProfessorID
	LEFT JOIN Student.Term AS T
	ON SED.TermID = T.TermID
	LEFT JOIN Student.Grades AS G
	ON SED.GradeID = G.GradeID
	LEFT JOIN Student.StudentEvents AS SE
	ON SED.StudentID = SE.StudentID
	AND SED.StudentEventID = SE.StudentEventID
	LEFT JOIN Student.Events AS E
	ON SE.EventID = E.EventID

	SELECT * FROM dbo.vw_GetStudentEnrollmentDetails;

	
	








