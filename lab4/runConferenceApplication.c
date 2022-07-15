/**
 * runSupermarketApplication skeleton, to be modified by students
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define  MAXCONNECTIONSTRINGSIZE    501
/* Maximum length of string used to submit a SQL statement */
#define   MAXSQLSTATEMENTSTRINGSIZE  2001

/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_FAILURE);
}


/* The three C functions that for Lab4 should appear below.
 * Write those functions, as described in Lab4 Section 4 (and Section 5,
 * which describes the Stored Function used by the third C function).
 *
 * Write the tests of those function in main, as described in Section 6
 * of Lab4.
 */


 /* getConferenceAttendeeCount:
  * A conference is identified by its conferenceName and year.  Besides the
  * database connection, the getConferenceAttendeeCount function has two
  * arguments, a string argument theConferenceName and an integer,
  * theConferenceYear.
  *
  * getConferenceAttendeeCount should return the number of attendees for the
  * conference that has the specified conferenceName and year.  It is possible
  * that there are no attendees for that conference, either because it is a
  * conference but there are no attendees, or because there is no such
  * conference.  In either of those cases, the value returned should be 0.
  *
  */
int getConferenceAttendeeCount(PGconn *conn,
                        char *theConferenceName,
                        int theConferenceYear) {
    if(PQstatus(conn) != CONNECTION_OK){
        fprintf(stderr,"Connection to database failed: %s", PQerrorMessage(conn));
        return -1;
    }
    char command[1000] = "SELECT COUNT(*) FROM Attendees WHERE conferenceName = ";
    strcat(command, theConferenceName);
    strcat(command," AND year = ");
    strcat(command, to_string(theConferenceYear));
    PGresult *res = PQexec(conn, command);
    if(PQresultStatus(res) != PGRES_TUPLES_OK){
        return 0;
    }
    int count = PQgetValue(res, 0, 0);
    PQclear(res);
    return count;
}


/* updateAffiliation:
 * affiliation is an attribute of Persons.  Sometimes the people can change affiliation because
 * their company is renamed.
 *
 * Besides the database connection, the updateAffiliation function has two arguments, a string
 * argument oldAffiliation and another string argument, newAffiliation.  For every person in the
 * Persons table (if any) whose affiliation equals oldAffiliation, updateAffiliation should update
 *  their affiliation to be newAffiliation.
 *
 * There might be no person whose affiliation equals oldAffiliation (that’s not an error), and there
 * also might be multiple persons whose affiliation equals oldAffiliation, since affiliation is not
 * UNIQUE.  updateAffiliation should return the number of Products whose affiliation was updated.
 */
int updateAffiliation(PGconn *conn,
                              char *oldAffiliation,
                              char *newAffiliation) {
    if(PQstatus(conn) != CONNECTION_OK){
        fprintf(stderr,"Connection to database failed: %s", PQerrorMessage(conn));
        return -1;
    }

    char command[1000] = "UPDATE Persons SET affiliation = ";
    strcat(command, oldAffiliation);
    strcat(command," WHERE affiliation = ");
    strcat(command, newAffiliation);
    PGresult *res = PQexec(conn, command);
    if(PQresultStatus(res) != PGRES_COMMAND_OK){
        fprintf(stderr, "Update failed\n");
        PQclear(res);
        return -1;
    }
    int count = PQcmdTuples(res);
    PQclear(res);
    return count;
}


/* changeSomeRatings:  Besides the database connection, this function has two integer parameters,
 * theReviewerID, and maxRatingChanges.  changeSomeRatings invokes a Stored Function,
 * changeSomeRatingsFunction, that you will need to implement and store in the database according
 * to the description in Section 5.  The Stored Function changeSomeRatingsFunction should have the
 * same parameters (theReviewerID and maxRatingChanges) as changeSomeRatings.
 *
 * The Reviews table has attributes include reviewerID (reviewer who did the review) and rating (the
 * rating that the reviewer gave to the paper).  changeSomeRatingsFunction will change the rating
 * for some (but not necessarily all) of the Reviews made by theReviewerID.  Section 5 explains
 * which Reviews should have their rating values changed, and also tells you how much you should
 * change the value of those rating values.  The changeSomeRatings function should return the same
 * integer result that the changeSomeRatingsFunction Stored Function returns.  Sometimes
 * changeSomeRatingsFunction returns a negative value, signifying an erroneous parameter;
 * changeSomeRatings should just return that value to its invoker, which will deal with that as
 * described in the Testing section below, Section 6.
 *
 * The changeSomeRatings function must only invoke the Stored Function changeSomeRatingsFunction,
 * which does all of the work for this part of the assignment; changeSomeRatings must not do the
 * work itself.
 */
int changeSomeRatings(PGconn *conn, int theReviewerID, int maxRatingChanges) {
    if(PQstatus(conn) != CONNECTION_OK){
        fprintf(stderr,"Connection to database failed: %s", PQerrorMessage(conn));
        return -1;
    }
    char command[1000] = "SELECT changeSomeRatingsFunction(";
    strcat(command, theReviewerID);
    strcat(command, ", ");
    strcat(command, maxRatingChanges);
    strcat(command,");");
    PGresult *res = PQexec(conn, command);
    int count = PQgetValue(res, 0, 0);
    PQclear(res);
    return count;
}

int
main(int argc, char **argv)
{
    PGconn      *conn;
    int         theResult;
    
    if (argc != 3) {
        fprintf(stderr, "Must supply userid and password\n");
        exit(EXIT_FAILURE);
    }
    
    char *userID = argv[1];
    char *pwd = argv[2];
    
    char conninfo[MAXCONNECTIONSTRINGSIZE] = "host=cse180-db.lt.ucsc.edu user=";
    strcat(conninfo, userID);
    strcat(conninfo, " password=");
    strcat(conninfo, pwd);
    
    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);
    
    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Connection to database failed: %s\n",
                PQerrorMessage(conn));
        bad_exit(conn);
    }

        
     /* Perform the calls to getConferenceAttendeeCount described in Section 6 of Lab4,
      * and print their outputs in specified format.
      */
    printf("Attendance for conference ‘American Conference of Law’ 2020 was %d\n",
        getConferenceAttendeeCount(conn,'American Conference of Law',2020));

    printf("Attendance for conference ‘‘Harvard Law Review’ 2021 was %d\n",
    getConferenceAttendeeCount(conn,'‘Harvard Law Review',2021));
        
    /* Perform the calls to updateAffiliation described in Section 6 of Lab4,
     * and print their outputs in specified format.
     */
    printf("Output of updateAffiliation when oldAffiliation is \n
    UC Santa Cruz and newAffiliation is City College of Santa Cruz is:\n
    %d\n",updateAffiliation(conn,"UC Santa Cruz","City College of Santa Cruz"));

    printf("Output of updateAffiliation when oldAffiliation is \n
    California University of Los Angeles and newAffiliation is UCLA is:\n
    %d\n",updateAffiliation(conn,"California University of Los Angeles","UCLA")); 
    /* Perform the calls to changeSomeRatings described in Section 6 of Lab4,
     * and print their outputs in specified format.
     */
     printf("Output of changeSomeRatings\n
    when theReviewerID is 987 and maxRatingChanges is 3
    %d\n", changeSomeRatings(987,3));

    printf("Output of changeSomeRatings\n
    when theReviewerID is 22 and maxRatingChanges is 1
    %d\n", changeSomeRatings(22,1));

    printf("Output of changeSomeRatings\n
    when theReviewerID is 3488 and maxRatingChanges is 3
    %d\n", changeSomeRatings(3488,3));

    printf("Output of changeSomeRatings\n
    when theReviewerID is 3488 and maxRatingChanges is 4
    %d\n", changeSomeRatings(3488,4));

    printf("Output of changeSomeRatings\n
    when theReviewerID is 991 and maxRatingChanges is 2
    %d\n", changeSomeRatings(991,2));
    
    good_exit(conn);
    return 0;

}


