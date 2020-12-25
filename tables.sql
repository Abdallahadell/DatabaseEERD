CREATE TABLE Users(
    id INT PRIMARY KEY IDENTITY,
    firstName VARCHAR(20),
    lastName VARCHAR(20),
    password VARCHAR(40),
    gender BIT,
    email VARCHAR(40),
    address VARCHAR(40)
);

CREATE TABLE UserMobileNumber(
    id INT,
    mobileNumber VARCHAR(20),
    PRIMARY KEY (id, mobileNumber), 
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Student (
    id INT PRIMARY KEY,
    gpa DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CreditCard (
    number VARCHAR(20) PRIMARY KEY,
    cardHolderName VARCHAR(50),
    expiryDate DATETIME,
    cvv VARCHAR(3)
);

CREATE TABLE StudentAddCreditCard (
    sid INT,
    creditCardNumber VARCHAR(20),
    PRIMARY KEY (sid, creditCardNumber),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (creditCardNumber) REFERENCES CreditCard ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Admin(
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Promocode(
    code VARCHAR(6) PRIMARY KEY,
    issueDate DATE,
    expiryDate DATE,
    discountAmount INT,
    adminId INT,
    FOREIGN KEY (adminId) REFERENCES Admin ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE StudentHasPromocode(
    sid INT,
    code VARCHAR(6),
    PRIMARY KEY(sid, code),
    FOREIGN KEY (sid) REFERENCES Student,
    FOREIGN KEY (code) REFERENCES Promocode ON DELETE CASCADE ON UPDATE CASCADE
);
 
CREATE TABLE Instructor(
    ID INT PRIMARY KEY,
    Rating DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (ID) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE StudentRateInstructor(
    sid INT,
    instId INT,
    rate DECIMAL(10, 2),
    PRIMARY KEY (sid, instId),
    FOREIGN KEY (sid) REFERENCES Student,
    FOREIGN KEY (instId) REFERENCES Instructor
);

CREATE TABLE Course(
    id INT PRIMARY KEY IDENTITY NOT NULL,
    creditHours INT,
    name VARCHAR(50),
    courseDescription VARCHAR(100),
    price DECIMAL,
    content VARCHAR(100),
    adminId int,
    instructorId INT,
    accepted BIT,
    FOREIGN KEY(adminId) REFERENCES Admin,
    FOREIGN KEY(instructorId) REFERENCES Instructor
);

CREATE TABLE InstructorTeachCourse(
    instId INT,
    cid INT,
    PRIMARY KEY (instId, cid),
    FOREIGN KEY (instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE StudentTakeCourse (
    sid INT,
    cid INT,
    instId INT,
    payedfor INT,
    grade DECIMAL(10, 2),
    PRIMARY KEY (sid, cid, instId),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (instId) REFERENCES Instructor
);

CREATE TABLE StudentCertifyCourse (
    sid INT,
    cid INT,
    issueDate DATETIME,
    PRIMARY KEY (sid, cid),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CoursePrerequisiteCourse(
    cid INT,
    prerequisiteId INT,
    PRIMARY KEY (cid, prerequisiteId),
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prerequisiteId) REFERENCES Course
);

CREATE TABLE Feedback(
    cid INT,
    number INT IDENTITY NOT NULL,
    comments VARCHAR(100),
    numberOfLikes INT DEFAULT 0,
    sid INT,
    PRIMARY KEY (number, cid),
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Assignment(
    cid INT,
    number INT,
    type VARCHAR(50) ,
    fullGrade DECIMAL(10,2),
    weight DECIMAL(10,2),
    deadline DATETIME not null,
    content VARCHAR(100),
    PRIMARY KEY (cid, number, type),
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE StudentTakeAssignment(
    sid INT,
    cid INT,
    assignmentNumber INT,
    assignmentType VARCHAR(50),
    grade DECIMAL(10, 2) DEFAULT 0,
    PRIMARY KEY (sid, cid, assignmentNumber, assignmentType, grade),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid, assignmentNumber, assignmentType) REFERENCES Assignment(cid, number, type) ON DELETE CASCADE ON UPDATE CASCADE
);
/*info*/