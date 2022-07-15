DROP SCHEMA Lab2 CASCADE;
CREATE SCHEMA Lab2;

CREATE TABLE Persons (
    personID INT,
    lastName VARCHAR(30),
    firstName VARCHAR(30),
    email VARCHAR(60) NOT NULL UNIQUE,
    affiliation VARCHAR(60),
    isStudent BOOLEAN,
    UNIQUE(lastName,firstName),
    PRIMARY KEY(personID)
);

CREATE TABLE Conferences (
    conferenceName VARCHAR(60),
    year INT,
    conferenceDate DATE,
    regularAttendeeCost NUMERIC(6,2),
    StudentAttendeeCost NUMERIC(6,2),
    submissionDueDate DATE,
    reviewDueDate DATE,
    importance CHAR(1),
    PRIMARY KEY(conferenceName, year)
);

CREATE TABLE Submissions (
    conferenceName VARCHAR(60),
    year INT,
    submissionID INT,
    numPages INT,
    submitDate DATE NOT NULL,
    wasAccepted BOOLEAN,
    submissionTitle VARCHAR(60),
    dateAccepted DATE,
    datePublished DATE,
    PRIMARY KEY(conferenceName, year, submissionID),
    FOREIGN KEY(conferenceName, year) REFERENCES Conferences
);

CREATE TABLE Authors (
    authorID INT REFERENCES Persons(personID),
    conferenceName VARCHAR(60),
    year INT,
    submissionID INT,
    authorPosition INT,
    UNIQUE(conferenceName,year,submissionID,authorPosition),
    PRIMARY KEY(authorID, conferenceName, year, submissionID),
    FOREIGN KEY(conferenceName, year) REFERENCES Conferences
);

CREATE TABLE Reviewers (
    reviewerID INT REFERENCES Persons(personID),
    conferenceName VARCHAR(60),
    year INT,
    reliability CHAR(1),
    PRIMARY KEY(reviewerID, conferenceName, year),
    FOREIGN KEY(conferenceName, year) REFERENCES Conferences
);

CREATE TABLE Reviews (
    reviewerID INT,
    conferenceName VARCHAR(60),
    year INT,
    submissionID INT,
    reviewDate DATE NOT NULL,
    rating INT,
    PRIMARY KEY(reviewerID, conferenceName, year, submissionID),
    FOREIGN KEY(reviewerID, conferenceName, year) REFERENCES Reviewers,
    FOREIGN KEY(conferenceName, year, submissionID) REFERENCES Submissions
);

CREATE TABLE Attendees(
    attendeeID INT REFERENCES Persons(personID),
    conferenceName VARCHAR(60),
    year INT,
    PRIMARY KEY(attendeeID, conferenceName, year),
    FOREIGN KEY(conferenceName, year) REFERENCES Conferences
);