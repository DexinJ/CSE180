BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO Submissions
SELECT  upd.conferenceName,
        upd.year,
        upd.submissionID,
        NULL,
        CURRENT_DATE,
        TRUE,
        NULL,
        upd.dateAccepted,
        NULL
FROM SubmissionChanges upd
WHERE NOT EXISTS (  SELECT *
                    FROM Submissions s
                    WHERE s.conferenceName = upd.conferenceName
                    AND s.year = upd.year
                    AND s.submissionID = upd.submissionID);

UPDATE Submissions
SET submitDate = NULL,
    dateAccepted = upd.dateAccepted,
    wasAccepted = TRUE
FROM SubmissionChanges upd
where Submissions.submissionID = upd.submissionID
AND Submissions.year = upd.year
AND Submissions.conferenceName = upd.conferenceName;
COMMIT TRANSACTION;

