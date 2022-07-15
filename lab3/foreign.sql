ALTER TABLE Reviews
ADD CONSTRAINT reviewer_constraint FOREIGN KEY(reviewerID,conferenceName,year)
REFERENCES Reviewers(reviewerID,conferenceName,year)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE Reviews
ADD CONSTRAINT reviewsub_constraint FOREIGN KEY(conferenceName,year,submissionID)
REFERENCES Submissions(conferenceName,year,submissionID)
    ON DELETE DELETE
    ON UPDATE RESTRICT;