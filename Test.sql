exec studentRegister 'merna','michel','merna','m@mail.com',1,'nasrcity'
exec InstructorRegister 'Rana','Magdy','rana','rana@mail.com',1,'cairo' 
INSERT INTO Users(firstName, lastName, password, gender, email, address) VALUES ('Abdallah','Adel','name',0,'Abdallah@mail.com','Nasr City')
 Insert into Admin(id) values(3)
Declare @Success Bit;
Declare @Type INT;
exec userLogin   2,'raa', @Success output,@Type output
exec addMobile 1, '111111111'
exec AdminListInstr
exec AdminViewInstructorProfile 2
exec AdminViewAllCourses
exec AdminViewNonAcceptedCourses
exec AdminViewCourseDetails 2
exec AdminAcceptRejectCourse 3,2
exec AdminCreatePromocode 'G101','1/1/2019','1/1/2020',10,3
exec AdminListAllStudents
exec AdminViewStudentProfile 1
exec AdminIssuePromocodeToStudent 1,'G101'