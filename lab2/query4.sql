SELECT c.conferenceName AS name, c.year AS year, c.regularAttendeeCost AS theCost, c.importance AS theImportance
FROM Conferences c
WHERE c.regularAttendeeCost IS NOT NULL
AND c.importance IS NOT NULL 
AND c.regularAttendeeCost <= (SELECT MIN(c2.regularAttendeeCost)
                              FROM Conferences c2
                              WHERE c2.regularAttendeeCost IS NOT NULL);