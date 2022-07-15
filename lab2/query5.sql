SELECT p.email, c.conferenceName, c.year, c.StudentAttendeeCost
FROM Attendees a, Persons p, Conferences c
WHERE a.attendeeID = p.personID
AND a.conferenceName = c.conferenceName
AND a.year = c.year
AND p.affiliation = 'Harvard University'
AND EXISTS (SELECT *
            FROM Reviewers r, Persons p2
            WHERE r.conferenceName = a.conferenceName
            AND r.year = a.year
            AND r.reviewerID = p2.personID
            AND p2.lastName = 'Huntington')
AND EXISTS (SELECT *
            FROM SUbmissions s
            WHERE s.conferenceName = a.conferenceName
            AND s.year = a.year
            AND s.dateAccepted = DATE '2021-03-28'
            AND s.numPages > 7)