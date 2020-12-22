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
    set @id = SCOPE_IDENTITY() 
    INSERT INTO Student(id)
    VALUES(@id)
    go;

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
    set @id = SCOPE_IDENTITY() 
    INSERT INTO Instructor(id)
    VALUES(@id)
    go;