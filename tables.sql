CREATE TABLE Users(
    id INT PRIMARY KEY IDENTITY,
    firstName VARCHAR(20),
    lastName VARCHAR(20),
    password VARCHAR(40),
    gender BIT,
    email VARCHAR(40),
    address VARCHAR(40)
)

CREATE TABLE UserMobileNumber(
    id INT PRIMARY KEY,
    mobileNumber VARCHAR(20),
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Student (
    id INT PRIMARY KEY,
    gpa DECIMAL(10, 2),
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CreditCard (
    number INT PRIMARY KEY,
    cardHolderName VARCHAR(50),
    expiryDate DATETIME,
    cvv VARCHAR(3)
);

CREATE TABLE StudentAddCreditCard (
    sid INT,
    creditCardNumber INT,
    PRIMARY KEY (sid, creditCardNumber),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (creditCardNumber) REFERENCES CreditCard ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Admin(
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Promocode(
    code VARCHAR(6) PRIMARY KEY,
    issueDate DATE,
    expiryDate DATE,
    discountAmount INT,
    adminId INT,
    FOREIGN KEY(adminId) REFERENCES Admin ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE StudentHasPromocode(
    sid INT,
    code VARCHAR(6),
    PRIMARY KEY(sid, code),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (code) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
)
  
CREATE TABLE Instructor(
    ID INT PRIMARY KEY,
    Rating INT,
    FOREIGN KEY (ID) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE StudentRateInstructor(
    sid INT,
    instId INT,
    rate INT,
    PRIMARY KEY (sid, instId),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE
)

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
    FOREIGN KEY(adminId) REFERENCES Admin ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(instructorId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE InstructorTeachCourse(
    instId INT,
    cid INT,
    PRIMARY KEY (instId, cid),
    FOREIGN KEY (instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE StudentTakeCourse (
    sid INT,
    cid INT,
    instId INT,
    payedfor INT,
    grade DECIMAL(10, 2),
    PRIMARY KEY (sid, cid, instId),
    FOREIGN KEY (sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE
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
    PRIMARY KEY(cid, prerequisiteId),
    FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(prerequisiteId) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE Feedback(
    cid INT,
    number INT IDENTITY NOT NULL,
    comments VARCHAR(100),
    numberOfLikes INT,
    sid INT,
    PRIMARY KEY(number, cid),
    FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Assignment(
    cid INT,
    number INT,
    type VARCHAR(50) ,
    fullGrade DECIMAL,
    weight DECIMAL,
    deadline DATETIME not null,
    content VARCHAR(100),
    PRIMARY KEY(cid, number, type),
    FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE StudentTakeAssignment(
    sid INT,
    cid INT,
    assignmentNumber INT,
    assignentType VARCHAR(50),
    grade DECIMAL,
    PRIMARY KEY(sid, cid, assignmentNumber, assignentType, grade),
    FOREIGN KEY(sid) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(assignmentNumber) REFERENCES Assignment(number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(assignmentType) REFERENCES Assignment(type) ON DELETE CASCADE ON UPDATE CASCADE
);
