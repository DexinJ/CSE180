SELECT h.year COUNT(h.conferenceName)
FROM HuntingtonReviewerConferences h, LongConferenceSubmissionsCount l
WHERE h.year = l.year
AND h.conferenceName=l.conferenceName
GROUP BY h.year
HAVING h.hCount = 1 AND SUM(longCount)>=4

DELETE FROM Reviewers 
WHERE reviewerID = 3488
AND conferenceName = 'Santa Cruz Law Review'
AND year = 2021

DELETE FROM Reviewers 
WHERE reviewerID = 3396
AND conferenceName = 'American Conference of Law'
AND year = 2020