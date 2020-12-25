exec studentRegister 'merna','michel','merna','m@mail.com',1,'nasrcity'
exec InstructorRegister 'Rana','Magdy','rana','rana@mail.com',1,'cairo' 
INSERT INTO Users(firstName, lastName, password, gender, email, address) VALUES ('Abdallah','Adel','name',0,'Abdallah@mail.com','Nasr City')
Insert into Admin(id) values(3)
exec InstructorRegister 'kamal', 'berk', 'abd', 'obama@mail.com',0,'guc'
exec studentRegister 'seif','mohamed','ahmed','a@mail.com',0,'nasrcity'
exec studentRegister 'test','test','test','a@mail.com',0,'nasrcity'
Declare @Success Bit;
Declare @Type INT;
exec userLogin   2,'rana', @Success output,@Type output
exec addMobile 1, '111111111'
exec addMobile 2, '3334444'
exec AdminListInstr
exec AdminViewInstructorProfile 2
exec AdminViewAllCourses
exec AdminViewNonAcceptedCourses
exec AdminViewCourseDetails 1
exec AdminAcceptRejectCourse 3,1,1
exec AdminCreatePromocode 'G101','1/1/2019','1/1/2020',10,3
exec AdminListAllStudents
exec AdminViewStudentProfile 1
exec AdminIssuePromocodeToStudent 1,'G101'
exec InstAddCourse 2, 'db',100, 2
exec InstAddCourse 1, 'math',200, 4
exec UpdateCourseContent 2, 1, 'intranet.guc.edu.eg/db1'
exec AddAnotherInstructorToCourse 4,1,2
exec InstructorViewAcceptedCoursesByAdmin 2
exec DefineCoursePrerequisites 1,2
exec DefineAssignmentOfCourseOfCertianType 2,1,1,'midterm',50,15,'1/1/2021','question1'
exec rateInstructor 5, 1, 2
exec rateInstructor 2.5,5,2
exec updateInstructorRate 2
exec ViewInstructorProfile 2
exec enrollInCourse 1,1,4
exec submitAssign 'midterm', 1, 1, 1
exec InstructorViewAssignmentsStudents 4, 1
exec InstructorgradeAssignmentOfAStudent 4,1,1,1,'midterm',9
exec addFeedback 'bad', 1, 1
exec ViewFeedbacksAddedByStudentsOnMyCourse 4, 1
exec calculateFinalGrade 1, 1, 4
exec InstructorIssueCertificateToStudent 1, 1, 4, '1/1/9090'
exec viewMyProfile 1
exec editMyProfile 1, null, 'alo', 'merna', 1, 'merna@mail.com', 'york'
exec availableCourses
exec UpdateCourseDescription 2, 1, 'hohoho'
exec courseInformation 1
exec addCreditCard 1, '000000', 'Merna', '1/1/2021', '123'
exec viewPromocode 1
exec payCourse 1, 1
exec enrollInCourseViewContent 1, 2
exec viewAssign 1, 1
DECLARE @grade DECIMAL(10, 2);
exec viewAssignGrades 1, 'midterm', 1, 1, @grade OUTPUT
DECLARE @finalgrade DECIMAL(10, 2);
exec viewFinalGrade 1, 1, @finalgrade OUTPUT
exec viewCertificate 1,1
/*info*/