SELECT a.authorID AS theAuthor, s.submissionTitle AS theSubmission, c.conferenceDate AS theConference
FROM Submissions s, Authors a, Conferences c, Persons p
WHERE a.submissionID = s.submissionID
AND a.conferenceName = s.conferenceName
AND a.year = s.year
AND a.conferenceName = c.conferenceName
AND a.year = c.year
AND a.authorID = p.personID
AND p.lastName LIKE 'K%'
AND s.datePublished IS NULL
AND c.conferenceDate >= DATE '2020-1-9';