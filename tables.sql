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

