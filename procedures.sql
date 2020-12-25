CREATE PROC studentRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @email VARCHAR(50),
    @gender BIT,
    @address VARCHAR(10)
    AS
        INSERT INTO Users(firstName, lastName, password, gender, email, address)
        VALUES(@first_name, @last_name, @password, @gender, @email, @address)
        DECLARE @id INT
        SET @id = SCOPE_IDENTITY() 
        INSERT INTO Student(id)
        VALUES(@id)
        INSERT INTO UserMobileNumber(id, mobileNumber)
        VALUES(@id, '0')
GO;

CREATE PROC InstructorRegister
@first_name VARCHAR(20),
@last_name VARCHAR(20),
@password VARCHAR(20),
@email VARCHAR(50),
@gender BIT,
@address VARCHAR(10)
AS
    INSERT INTO Users(firstName, lastName, password, gender, email, address)
    VALUES(@first_name, @last_name, @password, @gender, @email, @address)
    DECLARE @id INT
    SET @id = SCOPE_IDENTITY() 
    INSERT INTO Instructor(id)
    VALUES(@id)
    INSERT INTO UserMobileNumber(id, mobileNumber)
    VALUES(@id, '0')

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
DECLARE @id INT
SET @id = SCOPE_IDENTITY()
INSERT INTO InstructorTeachCourse(instId, cid)
VALUES(@instructorId, @id)

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
    WHERE instructorId = @instrId And accepted = 1

GO;

CREATE PROC DefineCoursePrerequisites
@cid INT,
@prerequisiteId INT
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
    DECLARE @totalRating DECIMAL(10,2)
    SELECT @totalRating = AVG(rate)
    FROM StudentRateInstructor
    WHERE instId = @insid
    UPDATE Instructor
    SET rating = @totalRating
    WHERE id = @insid
    
GO;

CREATE PROC ViewInstructorProfile
@instrId INT
AS
    EXEC updateInstructorRate @instrId
    SELECT u.firstName, u.lastName, u.gender, u.email, u.address, i.Rating, m.mobileNumber
    FROM Instructor i INNER JOIN Users u ON u.id = i.ID INNER JOIN UserMobileNumber m ON u.id = m.id
    WHERE i.ID = @instrId AND i.id = m.id
GO;

CREATE PROC InstructorViewAssignmentsStudents
@instrId INT,
@cid INT
AS
    IF EXISTS (
        SELECT *
        FROM InstructorTeachCourse
        WHERE instId = @instrId AND cid = @cid
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
        FROM InstructorTeachCourse
        WHERE instId = @instrId AND cid = @cid 
        )
    BEGIN
        UPDATE StudentTakeAssignment
        SET grade = @grade
        WHERE sid = @sid AND cid = @cid AND assignmentNumber = @assignmentNumber AND assignmentType = @type
    END;

GO;

CREATE PROC ViewFeedbacksAddedByStudentsOnMyCourse
@instrId INT,
@cid INT
AS
    SELECT *
    FROM Feedback f INNER JOIN InstructorTeachCourse i ON f.cid = i.cid
    WHERE f.cid = @cid AND i.instId  = @instrId 

GO;

CREATE PROC calculateFinalGrade
@cid INT,
@sid INT,
@insId INT
AS
    IF EXISTS(
        SELECT * 
        FROM StudentTakeCourse
        WHERE instId = @insId and cid = @cid
        )
    BEGIN
    DECLARE @sum DECIMAL(10,2) 
        SELECT @sum = SUM((x.grade/a.fullGrade) * weight) 
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
        FROM StudentTakeCourse 
        WHERE instId = @insId and cid = @cid
        )
    BEGIN
        INSERT INTO StudentCertifyCourse(sid,cid,issueDate)
        VALUES(@sid, @cid, @issueDate)
    END;

GO;

CREATE PROC userLogin
@ID INT,
@password VARCHAR(20),
@Success BIT OUTPUT,
@Type INT OUTPUT
AS
    IF EXISTS(
        SELECT u.*
        FROM Users u
        WHERE u.id = @ID AND @password = u.password
    )
    BEGIN
        SET @Success = 1
        PRINT CONCAT('Success : ' , @Success)
        IF EXISTS(
            SELECT *
            FROM Instructor
            WHERE id = @ID
        )
        BEGIN
            SET @Type = 0
            PRINT CONCAT('Type : ' , @Type)
        END;
        IF EXISTS(
            SELECT *
            FROM Admin
            WHERE id = @ID
        )
        BEGIN
            SET @Type = 1
            PRINT CONCAT('Type : ' , @Type)
        END;
        IF EXISTS(
            SELECT u.*
            FROM Student
            WHERE id = @ID
        )
        BEGIN
            SET @Type = 2
            PRINT CONCAT('Type : ' , @Type)
        END;
    END;
    ELSE
    BEGIN
        SET @Success = 0
        PRINT CONCAT('Success : ' , @Success)
        SET @Type = -1
        PRINT CONCAT('Type : ' , @Type)
    END;

GO;

CREATE PROC addMobile
@id INT,
@mobile_number VARCHAR(20)
AS
    INSERT INTO UserMobileNumber(id, mobileNumber)
    VALUES (@id, @mobile_number)

GO;

CREATE PROC viewMyProfile
@id INT
AS
    SELECT u.* , s.gpa
    FROM Student s INNER JOIN Users u ON s.id = u.id
    WHERE s.id = @id

GO;

CREATE PROC editMyProfile
@id INT,
@firstName VARCHAR(10),
@lastName VARCHAR(10),
@password VARCHAR(10),
@gender BIT,
@email VARCHAR(10),
@address VARCHAR(10)
AS
 
    IF @firstName IS NULL
        BEGIN
             SELECT @firstName = u.firstName
             FROM Users u
             WHERE u.id = @id 
        END;
    IF @lastName IS NULL
       BEGIN
             SELECT @lastName = u.lastName
             FROM Users u
             WHERE u.id = @id 
        END;
    IF @password IS NULL
       BEGIN
             SELECT @password = u.password
             FROM Users u
             WHERE u.id = @id 
        END;
    IF @gender IS NULL
       BEGIN
             SELECT @gender = u.gender
             FROM Users u
             WHERE u.id = @id 
        END;
    IF @email IS NULL
       BEGIN
             SELECT @email = u.email
             FROM Users u
             WHERE u.id = @id 
        END;
    IF @address IS NULL
       BEGIN
             SELECT @address = u.address
             FROM Users u
             WHERE u.id = @id 
        END;
    UPDATE Users
    SET firstName = @firstName , lastName = @lastName , password = @password , gender = @gender , email = @email , address = @address
    WHERE id = @id;

GO;

CREATE PROC availableCourses
AS
    SELECT name
    FROM Course
    WHERE accepted = 1;

GO;

CREATE PROC courseInformation
@id INT
AS
    SELECT c.* , u.firstName , u.lastName
    FROM Course c INNER JOIN Users u ON c.instructorId = u.id
    WHERE c.id = @id

GO;

CREATE PROC enrollInCourse
@sid INT,
@cid INT,
@instr INT
AS
    INSERT INTO StudentTakeCourse(sid , cid , instId)
    VALUES (@sid , @cid , @instr)

GO;


CREATE PROC addCreditCard
@sid INT,
@number VARCHAR(15),
@cardHolderName VARCHAR(16),
@expiryDate DATETIME,
@cvv VARCHAR(3)
AS
    IF EXISTS(
        SELECT *
        FROM StudentAddCreditCard
        WHERE sid = @sid
    )
    BEGIN
        PRINT('ALREADY ADDED')
    END;
    ELSE IF EXISTS(
        SELECT *
        FROM CreditCard
        WHERE number = @number
    )
    BEGIN
        INSERT INTO StudentAddCreditCard(sid , creditCardNumber)
        VALUES (@sid , @number)
    END;
    ELSE
    BEGIN
       INSERT INTO CreditCard(number, cardHolderName, expiryDate, cvv)
       VALUES (@number , @cardHolderName , @expiryDate , @cvv)
       INSERT INTO StudentAddCreditCard(sid , creditCardNumber)
       VALUES (@sid , @number)
    END;
    
GO;

CREATE PROC viewPromocode
@sid INT
AS
    SELECT p.*
    FROM Promocode p INNER JOIN StudentHasPromcode sp ON sp.code = p.code
    WHERE sp.sid = @sid

GO;

CREATE PROC payCourse
@cid INT,
@sid INT
AS 
    UPDATE StudentTakeCourse
    SET payedfor = 1
    WHERE sid = @sid AND cid = @cid

GO;

CREATE PROC enrollInCourseViewContent
@id INT,
@cid INt
AS
    IF EXISTS (
        SELECT sid
        FROM StudentTakeCourse
        WHERE sid = @id AND cid = @cid
    )
    BEGIN
        SELECT *
        FROM Course
        WHERE id = @cid
    END;

GO;

CREATE PROC viewAssign
@courseId INT,
@Sid INT
AS
    SELECT a.*
    FROM Assignment a INNER JOIN StudentTakeAssignment s on a.cid = s.cid
    WHERE a.cid = @courseId AND s.sid = @Sid

GO;

CREATE PROC submitAssign
@assignType VARCHAR(10),
@assignnumber INT,
@sid INT,
@cid INT
AS
    INSERT INTO StudentTakeAssignment(sid , cid , assignmentNumber , assignmentType, grade)
    VALUES (@sid , @cid , @assignnumber , @assignType, 0)

GO;

CREATE PROC viewAssignGrades
@assignnumber INT,
@assignType VARCHAR(10),
@cid INT,
@sid INT,
@assignGrade INT OUTPUT
AS
    SELECT @assignGrade = grade
    FROM StudentTakeAssignment
    WHERE assignmentNumber = @assignnumber AND assignmentType = @assignType AND cid = @cid AND sid = @sid
    PRINT @assignGrade

GO;

CREATE PROC viewFinalGrade
@cid INT,
@sid INT,
@finalgrade decimal(10,2) OUTPUT
AS
    SELECT @finalgrade = grade
    FROM StudentTakeCourse
    WHERE cid = @cid AND sid = @sid
    PRINT @finalGrade

GO;

CREATE PROC addFeedback
@comment varchar(100),
@cid INT,
@sid INT
AS
    INSERT INTO Feedback(cid,comments,sid)
    VALUES (@cid , @comment , @sid)

GO;

CREATE PROC rateInstructor
@rate DECIMAL(2,1),
@sid INT,
@insid INT
AS
    INSERT INTO StudentRateInstructor(sid , instId , rate)
    VALUES (@sid , @insid , @rate)

GO;

CREATE PROC viewCertificate
@cid INT,
@sid INT
AS
    SELECT *
    FROM StudentCertifyCourse
    WHERE sid = @sid AND cid = @cid

/*info*/
