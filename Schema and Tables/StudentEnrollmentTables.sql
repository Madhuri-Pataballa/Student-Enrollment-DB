CREATE DATABASE StudentEnrollment;

CREATE SCHEMA Student;

CREATE TABLE Student.Students
(
StudentID INT IDENTITY (10000001,1),
Student_First_Name VARCHAR(50),
Student_Last_Name VARCHAR(50),
DateOfBirth DATE,
Gender CHAR CONSTRAINT CK_Gender CHECK (Gender IN ('M', 'F', 'U')),
Phone_Number VARCHAR(15),
Email_Address NVARCHAR(50),
DepartmentID INT,
DegreeID INT,
Is_Active CHAR(01)
);

SELECT * FROM Student.Course;

CREATE TABLE Student.StudentAddress
(
StudentID INT,
Address_Line1 NVARCHAR(50),
Address_Line2 NVARCHAR(50),
City VARCHAR(20),
State CHAR CONSTRAINT CK_State CHECK (State LIKE '[A-Z][A-Z]' AND LEN(State)=2),
ZipCode INT CONSTRAINT CK_ZipCode CHECK (ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' AND LEN(ZipCode)=5),
);

CREATE TABLE Student.Calender
(
DateID INT,
Date DATETIME,
Day_Number INT,
Week_Day VARCHAR(10),
Week_Number INT,
Month_Name VARCHAR(20),
Month_Number INT,
Year INT
);

CREATE TABLE Student.Professor
(
Professor INT IDENTITY (1000001,1),
Professor_First_Name VARCHAR(50),
Professor_Last_Name VARCHAR(50),
DateOfBirth DATE,
Gender CHAR CONSTRAINT CK_PGender CHECK (Gender IN ('M', 'F', 'U')),
DepartmentID INT,
);

CREATE TABLE Student.StudentEnrollmentDetails
(
StudentEnrollmentDetailsID INT,
StudentID INT,
CourseID INT,
TermID INT,
ProfessorID INT,
StudentEventID INT,
GradeID INT
);

CREATE TABLE Student.StudentEvents
(
StudentEventID INT,
StudentID INT,
EventID INT,
Event_DateID INT,
IsCurrentEvent CHAR(1) CONSTRAINT CK_IsCurrentEvent CHECK (IsCurrentEvent IN ('Y', 'N')) 
);

CREATE TABLE Student.Events
(
EventID INT IDENTITY (1001,1),
Event_Name VARCHAR(50),
Event_Order INT,
);

CREATE TABLE Student.Course
(
CourseID INT IDENTITY (101,1),
Course_Name VARCHAR(50),
Course_Fee INT,
Course_Min_GradeID INT,
);

CREATE TABLE Student.Grades
(
GradeID INT IDENTITY (11,1),
Grade_Code NCHAR CONSTRAINT CK_Grade_Code CHECK (Grade_Code IN ('A','A+','B','B+','C','C+','D','D+')),
Grade_Value DECIMAL(3,2)
);

CREATE TABLE Student.Department
(
DepartmentID INT IDENTITY (100001,1),
Department_Name VARCHAR(50)
);

CREATE TABLE Student.Term
(
TermID INT IDENTITY (1,1),
Term_Name VARCHAR(10)
);

CREATE TABLE Student.Degree
(
DegreeID INT IDENTITY (10001,1),
Degree_Name VARCHAR(30)
);