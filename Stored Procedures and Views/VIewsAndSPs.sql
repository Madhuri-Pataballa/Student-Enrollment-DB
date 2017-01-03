CREATE VIEW dbo.VW_CourseGrades
AS
SELECT C.Course_Name, C.Course_Fee, G.Grade_Value, G.Grade_Code  
FROM Student.Course AS C
JOIN Student.Grades AS G
ON
C.Course_Min_GradeID = G.GradeID
GO

CREATE PROC dbo.usp_CourseGrades
AS
BEGIN
SELECT C.Course_Name, C.Course_Fee, G.Grade_Value, G.Grade_Code  
FROM Student.Course AS C
JOIN Student.Grades AS G
ON
C.Course_Min_GradeID = G.GradeID
END
GO