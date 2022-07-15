CREATE VIEW HuntingtonReviewerConferences AS
    SELECT r.conferenceName,r.year,COUNT(r.reviewerID) AS hCount
    FROM Reviewers r, Persons p
    WHERE r.reviewerID = p.personID
    AND p.lastName = "Huntington"
    GROUP BY r.conferenceName, r.year

CREATE VIEW LongConferenceSubmissionsCount AS
    SELECT s.conferenceName, s.year, COUNT(s.submissionID) AS longCount
    FROM Submissions s
    GROUP BY s.conferenceName, s.year
    HAVING s.numPages>7
