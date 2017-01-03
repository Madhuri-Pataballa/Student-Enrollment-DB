USE [StudentEnrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_CourseGrades]    Script Date: 11/29/2016 9:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_CourseGrades]
AS
BEGIN
SELECT C.Course_Name, C.Course_Fee, G.Grade_Value, G.Grade_Code  
FROM Student.Course AS C
JOIN Student.Grades AS G
ON
C.Course_Min_GradeID = G.GradeID
END

