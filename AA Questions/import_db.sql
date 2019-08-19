PRAGMA foreign_keys = ON;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR (255),
    lname VARCHAR (255)
);

CREATE TABLE questions (
    id INTeger PRIMARY KEY,
    title VARCHAR (255),
    body TEXT,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTeger PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INT NOT NULL,
    user_id INT NOT NULL,
    body TEXT,
    parent_id INT,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Patrick', 'Mondala'),
    ('Jake', 'Schneider'),
    ('App', 'Academy');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('How do I clean my dog?', 'What soap do I use, what temperature water, etc.?', 1),
    ('Why is there so much water?', 'Most of it isn''t even drinkable!', 2),
    ('What is programming?', 'No please we need help', 3);

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    (1, 2),
    (2, 1),
    (3, 1),
    (3, 2);

INSERT INTO
    replies (question_id, user_id, body, parent_id)
VALUES
    (2, 1, 'I don''t know!', NULL),
    (2, 2, 'thanks!', 1);

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    (3, 1),
    (3, 2),
    (3, 3);