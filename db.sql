CREATE TABLE authors (
    id INT AUTO_INCREMENT,
    name VARCHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE publishers (
    id INT AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE books (
    id INT AUTO_INCREMENT,
    title VARCHAR(100),
    author INT,
    publisher INT,
    PRIMARY KEY (id),
    FOREIGN KEY (author) REFERENCES authors(id),
    FOREIGN KEY (publisher) REFERENCES publishers(id)
);

INSERT INTO
    authors (name)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('John Smith'),
    ('Jane Smith'),
    ('John Black'),
    ('Jane Black'),
    ('John White'),
    ('Jane White'),
    ('John Green'),
    ('Jane Green');

INSERT INTO
    publishers (name, email)
VALUES
    ('Publisher 1', 'publisher1@gmail.com'),
    ('Publisher 2', 'publisher2@gmqil.com'),
    ('Publisher 3', 'publisher3@gmail.com');

INSERT INTO
    books (title, author, publisher)
VALUES
    ('Book 1', 1, 1),
    ('Book 2', 2, 1),
    ('Book 3', 3, 1),
    ('Book 4', 4, 1),
    ('Book 5', 5, 1),
    ('Book 6', 6, 1),
    ('Book 7', 7, 1),
    ('Book 8', 8, 1),
    ('Book 9', 9, 1),
    ('Book 10', 10, 1),
    ('Book 11', 1, 2),
    ('Book 12', 2, 2),
    ('Book 13', 3, 2),
    ('Book 14', 4, 2),
    ('Book 15', 5, 2),
    ('Book 16', 6, 2),
    ('Book 17', 7, 2),
    ('Book 18', 8, 2),
    ('Book 19', 9, 2),
    ('Book 20', 10, 2),
    ('Book 21', 1, 3),
    ('Book 22', 2, 3),
    ('Book 23', 3, 3),
    ('Book 24', 4, 3),
    ('Book 25', 5, 3),
    ('Book 26', 6, 3),
    ('Book 27', 7, 3),
    ('Book 28', 8, 3),
    ('Book 29', 9, 3),
    ('Book 30', 10, 3);