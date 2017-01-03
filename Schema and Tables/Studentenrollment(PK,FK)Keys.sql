ALTER TABLE Student.Calender
ADD CONSTRAINT PK_DateID PRIMARY KEY(DateID);

ALTER TABLE Student.Course
ADD CONSTRAINT PK_CourseID PRIMARY KEY(CourseID);

ALTER TABLE Student.Degree
ADD CONSTRAINT PK_DegreeID PRIMARY KEY(DegreeID);

ALTER TABLE Student.Department
ADD CONSTRAINT PK_DepartmentID PRIMARY KEY(DepartmentID);

ALTER TABLE Student.Events
ADD CONSTRAINT PK_EventID PRIMARY KEY(EventID);

ALTER TABLE Student.Grades
ADD CONSTRAINT PK_GradeID PRIMARY KEY(GradeID);

ALTER TABLE Student.Professor
ADD CONSTRAINT PK_ProfessorID PRIMARY KEY(ProfessorID);

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT PK_StudentEnrollmentDetailsID PRIMARY KEY(StudentEnrollmentDetailsID);

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT PK_StudentEnrollmentDetailsID PRIMARY KEY(StudentEnrollmentDetailsID);

ALTER TABLE Student.StudentEvents
ADD CONSTRAINT PK_StudentEventID PRIMARY KEY(StudentEventID);

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT PK_StudentEnrollmentDetailsID PRIMARY KEY(StudentEnrollmentDetailsID);

ALTER TABLE Student.Students
ADD CONSTRAINT PK_StudentID PRIMARY KEY(StudentID);

ALTER TABLE Student.Term
ADD CONSTRAINT PK_TermID PRIMARY KEY(TermID);


ALTER TABLE Student.Students
ADD CONSTRAINT FK_DepartmentID FOREIGN KEY(DepartmentID)
REFERENCES Student.Department(DepartmentID);

ALTER TABLE Student.Students
ADD CONSTRAINT FK_DegreeID FOREIGN KEY(DegreeID)
REFERENCES Student.Degree(DegreeID);

ALTER TABLE Student.StudentAddress
ADD CONSTRAINT FK_StudentID FOREIGN KEY(StudentID)
REFERENCES Student.Students(StudentID);

ALTER TABLE Student.StudentEvents
ADD CONSTRAINT FK_StudentID_StudentID FOREIGN KEY(StudentID)
REFERENCES Student.Students;

ALTER TABLE Student.StudentEvents
ADD CONSTRAINT FK_EventID_EventID FOREIGN KEY(EventID)
REFERENCES Student.Events;

ALTER TABLE Student.StudentEvents
ADD CONSTRAINT FK_Event_DateID FOREIGN KEY(Event_DateID)
REFERENCES Student.Calender(DateID);

ALTER TABLE Student.Professor
ADD CONSTRAINT FK_DepartmentID_DepartmentID FOREIGN KEY(DepartmentID)
REFERENCES Student.Department;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_StudentID_StudentID FOREIGN KEY(StudentID)
REFERENCES Student.Students;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_CourseID_CourseID FOREIGN KEY(CourseID)
REFERENCES Student.Course;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_TermID_TermID FOREIGN KEY(TermID)
REFERENCES Student.Term;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_ProfessorID_ProfessorID FOREIGN KEY(ProfessorID)
REFERENCES Student.Professor;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_StudentEventID_StudentEventID FOREIGN KEY(StudentEventID)
REFERENCES Student.StudentEvents;

ALTER TABLE Student.StudentEnrollmentDetails
ADD CONSTRAINT FK_GradeID_GradeID FOREIGN KEY(GradeID)
REFERENCES Student.Grades;

ALTER TABLE Student.Course
ADD CONSTRAINT FK_Course_Min_GradeID FOREIGN KEY(Course_min_GradeID)
REFERENCES Student.Grades(GradeID);