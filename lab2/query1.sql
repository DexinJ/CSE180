SELECT c.conferenceName,c.year,c.importance
FROM Conferences c
WHERE EXISTS (SELECT *
              FROM Submissions s
              WHERE c.conferenceName = s.conferenceName
              AND c.year = s.year
              AND s.wasAccepted = TRUE);