SELECT p.lastName, p.firstName
FROM Reviewers r1, Reviewers r2, Persons p
WHERE r1.reviewerID = p.personID
AND r1.reviewerID = r2.reviewerID
AND (r1.conferenceName != r2.conferenceName
    OR r1.year != r2.year)
GROUP BY p.lastName, p.firstName
ORDER BY p.lastName DESC, p.firstName DESC;