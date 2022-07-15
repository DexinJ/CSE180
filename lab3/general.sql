ALTER TABLE Authors
ADD CONSTRAINT positive_authorPosition
    CHECK(authorPosition>0);

ALTER TABLE Conferences
ADD CONSTRAINT student_pay_less
    CHECK (studentAttendeeCost<regularAttendeeCost);

ALTER TABLE Submissions
ADD CONSTRAINT consistent_acceptance
    CHECK ((wasAccepted IS NULL) or (dateAccepted IS NOT NULL))