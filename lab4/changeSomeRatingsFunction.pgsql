CREATE OR REPLACE FUNCTION
changeSomeRatingsFunction(theReviewerID INTEGER, maxRatingChanges INTEGER)
RETURNS INTEGER AS $$


    DECLARE
    	numChanged		INTEGER;	  /* Number actually fired, the value returned */
        theConference   VARCHAR(60);
        theYear         INTEGER;
    DECLARE ratingCursor CURSOR FOR
    	    SELECT r.conferenceName, r.year
            FROM Reviews r, Reviewers p
            WHERE p.reviewerID = r.reviewerID 
              AND p.reviewerID = theReviewerID
              AND p.conferenceName = r.conferenceName
              AND p.year = r.year
            ORDER BY p.reviewDate DESC;

    BEGIN

	-- Input Validation
	IF maxRatingChanges <= 0 THEN
	    RETURN -1;		/* Illegal value of maxFired */
	    END IF;

        numChanged := 0;

        OPEN ratingCursor;

        LOOP
 
            FETCH ratingCursor INTO theConference, theYear;

            EXIT WHEN NOT FOUND OR numChanged >= maxRatingChanges;

            UPDATE Reviewers INNER JOIN Reviews on Reviewers.reviewerID
            SET rating = 
            CASE 
                WHEN reliability = 'H' THEN 
                CASE
                    WHEN rating < 4 THEN rating+2
                    ELSE 5
                END
                WHEN reliability = 'M' THEN
                CASE
                    WHEN rating < 5 THEN rating+1
                    ELSE 5
                END
                WHEN reliability = 'L' THEN rating
                ELSE
                CASE
                    WHEN rating > 0 THEN rating-1
                    ELSE 0
                END
            END
            numChanged := numChanged + 1;

        END LOOP;
        CLOSE ratingCursor;

	RETURN numChanged;

    END

$$ LANGUAGE plpgsql;
