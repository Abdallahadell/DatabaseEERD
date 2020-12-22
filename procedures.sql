CREATE PROC studentRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @email VARCHAR(50),
    @gender BIT,
    @address VARCHAR(10)
    AS
    INSERT INTO Users(first_name, last_name, password, gender, email, address)
    VALUES(@first_name, @last_name, @password, @gender, @email, @address)
    DECLARE @id INT
    SET @id = SCOPE_IDENTITY() 
    INSERT INTO Student(id)
    VALUES(@id)
    
GO;
CREATE PROC InstructorRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @email VARCHAR(50),
    @gender BIT,
    @address VARCHAR(10)
    AS
    INSERT INTO Users(first_name, last_name, password, gender, email, address)
    VALUES(@first_name, @last_name, @password, @gender, @email, @address)
    DECLARE @id INT
    SET @id = SCOPE_IDENTITY() 
    INSERT INTO Instructor(id)
    VALUES(@id)
    
GO;
CREATE PROC AdminListInstr
AS
SELECT *
FROM Instructor
ORDER BY firstName

GO;
CREATE PROC AdminViewInstructorProfile
@instrId INT
AS
SELECT *
FROM Users u INNER JOIN Instructor i ON u.id = i.id
WHERE u.id = @instrId

GO;
CREATE PROC AdminViewAllCourses
AS
SELECT *
FROM Course
ORDER BY Course.name

GO;
CREATE PROC AdminViewNonAcceptedCourses
AS
SELECT *
FROM Course c
WHERE c.accepted <> 1

GO;
CREATE PROC AdminViewCourseDetails
@courseId INT
AS
SELECT *
FROM Course
WHERE id = @courseId

GO;
CREATE PROC AdminAcceptRejectCourse
@adminId INT,
@courseId INT,
@acceptOrReject BIT
AS
UPDATE Course
SET Accepted = @acceptOrReject , adminId = @adminId
WHERE id = @courseId

GO;
CREATE PROC AdminCreatePromocode
@code VARCHAR(6),
@issueDate DATETIME,
@expiryDate DATETIME,
@discount DECIMAL(4,2),
@adminId INT
AS
INSERT INTO Promocode(code, issueDate, expiryDate, discountAmount, adminId)
VALUES (@code, @issueDate, @expiryDate, @discount, @adminId)

GO;
CREATE PROC AdminListAllStudents
AS
SELECT *
FROM Users u INNER JOIN Student s ON s.id = u.id

GO;
CREATE PROC AdminViewStudentProfile
@sid INT
AS
SELECT *
FROM Users u INNER JOIN Student s ON u.id = s.id
WHERE s.id = @sid

GO;
CREATE PROC AdminIssuePromocodeToStudent
@sid INT,
@pid VARCHAR(6)
AS
INSERT INTO StudentHasPromocode(sid, code)
VALUES (@sid,@pid)

GO;
CREATE PROC InstAddCourse
@creditHours INT,
@name VARCHAR(10),
@price DECIMAL(6,2),
@instructorId INT
AS
INSERT INTO Course(creditHours,name,price,instructorId)
VALUES(@creditHours,@name,@price,@instructorId)


GO; 
CREATE PROC UpdateCourseContent
@instrId INT,
@courseId INT,
@content VARCHAR(20)
AS
UPDATE Course
SET content = @content
WHERE instructorId = @instrid AND id = @courseId

GO;
CREATE PROC UpdateCourseDescription
@instrId INT,
@courseId INT,
@courseDescription VARCHAR(200)
AS
UPDATE Course
SET courseDescription = @courseDescription
WHERE instructorId = @instrid AND id = @courseId

GO;
CREATE PROC InstructorViewAcceptedCoursesByAdmin
@instrId INT
AS
SELECT *
FROM Course
WHERE instructorId = instrId And accepted = 1

GO;
CREATE PROC DefineCoursePrerequisites
@cid INT,
@prerequsiteId INT
AS 
INSERT INTO CoursePrerequisiteCourse(cid,prerequisiteId)
VALUES(@cid,@prerequisiteId)

GO;
CREATE PROC DefineAssignmentOfCourseOfCertianType
@instId INT,
@cid INT,
@number INT,
@type VARCHAR(10),
@fullGrade INT,
@weight DECIMAL(4,1),
@deadline DATETIME,
@content VARCHAR(200)
AS
IF EXISTS (
      SELECT *
      FROM Course
      WHERE instructorId = @instId AND id = @cid
  )
BEGIN
  INSERT INTO Assignment(cid, number, type, fullGrade, weight, deadline, content)
  VALUES(@cid,@number,@type,@fullGrade,@weight,@deadline,@content)
END;

GO;
CREATE PROC updateInstructorRate
@insid INT
AS
DECLARE @totalRating SMALLINT
SELECT @totalRating = AVG(rate)
FROM StudentRateInstructor
WHERE instId = @insid
UPDATE Instructor
SET rating = @totalRating
WHERE id = @insid
    
GO;
CREATE PROC InstructorViewAssignmentsStudents
@instrId INT,
@cid INT
AS
IF EXISTS (
    SELECT *
    FROM Course
    WHERE instructorId = @instId AND id = @cid
)
BEGIN
    SELECT *
    FROM StudentTakeAssignment
    WHERE cid = @cid
END;

GO;
CREATE PROC AddAnotherInstructorToCourse
@insid INT,
@cid INT,
@adderins INT
AS
IF EXISTS(
    SELECT *
    FROM Course
    WHERE instructorId = @adderins AND id = @cid
)
BEGIN
    INSERT INTO InstructorTeachCourse(instId,cid)
    VALUES(@insid,@cid)
END;

GO;
CREATE PROC InstructorgradeAssignmentOfAStudent
@instrId INT,
@sid INT,
@cid INT,
@assignmentNumber INT,
@type VARCHAR(10),
@grade DECIMAL(5,2)
AS
IF EXISTS(
    SELECT * 
    FROM Course
    WHERE instructorId = @instrId AND cid = @cid 
    )
BEGIN
    INSERT INTO StudentTakeAssignment(sid, cid, assignmentNumber, assignmentType, grade)
    VALUES(@sid, @cid, @assignmentNumber, @type, @grade)
END;

GO;
CREATE PROC ViewFeedbacksAddedByStudentsOnMyCourse
@instrId INT,
@cid INT
AS
SELECT *
FROM Feedback f INNER JOIN InstructorTeachCourse i ON f.cid = i.cid
WHERE f.cid = @cid AND I.id  = @instrId 

GO;
CREATE PROC calculateFinalGrade
@cid INT,
@sid INT,
@insId INT
AS
IF EXISTS(
    SELECT * 
    FROM Course
    WHERE instructorId = @insId and id = @cid
    )
BEGIN
DECLARE @sum DECIMAL 
    SELECT @sum = SUM(grade/fullGrade * weight) 
    FROM StudentTakeAssignment x INNER JOIN Assignment a ON x.cid = a.cid 
    WHERE x.sid = @sid AND a.cid = @cid
END;
UPDATE StudentTakeCourse
SET grade = @sum
WHERE cid = @cid AND sid = @sid

GO;
CREATE PROC InstructorIssueCertificateToStudent
@cid INT,
@sid INT,
@insId INT,
@issueDate DATETIME
AS
IF EXISTS(
    SELECT * 
    FROM Course 
    WHERE instructorId = @insId and id = @cid
    )
BEGIN
    INSERT INTO StudentCertifyCourse(sid,cid,issueDate)
    VALUES(@sid, @cid, @issueDate)
END;
