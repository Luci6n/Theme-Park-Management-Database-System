/*
File to submit by each member: G0999_9999999.sql

INDIVIDUAL ASSIGNMENT SUBMISSION
Submit one individual report with SQL statements only (*.docx)
and one sql script (*.sql for oOacle)

Template save as "G999_YourStudentID.sql"
e.g. G001_999999.sql

GROUP NUMBER : G089
PROGRAMME : CS
STUDENT ID : 2207200
STUDENT NAME : LER JUN WEI
Submission date and time: dd-mon-yy

Your information should appear in both files one individual report docx & one individual sql script, then save as G01_99ACB999999.zip
Should be obvious different transaction among the members

*/



/* Query 1: List all the customer full name where their first name start with 'J',
where they are also expresslane customer and their status for the current 
activity they are queueing for and the activty name.*/

SELECT (c.first_name || ' ' || c.last_name) AS "Customer's Name",
 a.name AS "Activity Name", w.status AS "WaitList Status"
FROM CUSTOMER c
JOIN EXPRESSLANE_CUSTOMER ec 
ON c.customer_id = ec.customer_id
JOIN WAITLIST w 
ON c.customer_id = w.customer_id
JOIN ACTIVITY a
ON w.activity_id = a.activity_id
WHERE c.first_name LIKE 'J%';

/* Query 2 Show all the name, capacity, price and description of the activities 
that has been made reservation by the annual customer where both of their 
reservation status and payment status is success.*/

SELECT a.name AS "Activity's Name", a.capacity AS "Activity's Capacity", 
a.price AS "Activity's Price", a.description AS "Activity's Description"
FROM ACTIVITY a
JOIN RESERVATION_DETAILS rd 
ON a.activity_id = rd.activity_id
JOIN RESERVATION r 
ON rd.reservation_id = r.reservation_id
JOIN ANNUAL_CUSTOMER ac 
ON r.customer_id = ac.customer_id
WHERE r.status = 'SUCCESSFUL' AND r.payment_status = 'SUCCESSFUL';

/*Stored procedure 1: Retrieve all the name of customer that has 
successful reservation on activity.*/

CREATE OR REPLACE PROCEDURE customers_successful_reservation(
    p_activity_name IN VARCHAR2,
    p_customer_search OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_customer_search FOR
    SELECT DISTINCT (c.first_name || ' ' || c.last_name) AS customer_name
    FROM CUSTOMER c
    JOIN RESERVATION r 
    ON c.customer_id = r.customer_id
    JOIN RESERVATION_DETAILS rd 
    ON r.reservation_id = rd.reservation_id
    JOIN ACTIVITY a 
    ON rd.activity_id = a.activity_id
    WHERE a.name = p_activity_name
    AND r.status = 'SUCCESSFUL';
END;
/

DECLARE
    v_customer_search SYS_REFCURSOR;
    v_customer_name VARCHAR(25);
    activity_name VARCHAR(30) := 'Amusement Park';

BEGIN
    customers_successful_reservation(activity_name, v_customer_search);
    LOOP
        FETCH v_customer_search INTO v_customer_name;
        EXIT WHEN v_customer_search%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Customer Name who had successfully had reservation on ' || activity_name ||': ' || v_customer_name);
    END LOOP;
    CLOSE v_customer_search;

END;
/

/* Stored procedure 2: Update both reservation details and waitlist for the 
annual customer. */

CREATE OR REPLACE PROCEDURE update_reservation_and_waitlist_ac(
    p_customer_id IN ANNUAL_CUSTOMER.customer_id%TYPE,
    p_first_name OUT VARCHAR2,
    p_last_name OUT VARCHAR2,
    p_reservation_id IN RESERVATION.reservation_id%TYPE,
    p_new_status IN RESERVATION.status%TYPE,
    p_new_waitlist_status IN WAITLIST.status%TYPE
)
AS

BEGIN
    
    p_first_name := NULL;
    p_last_name := NULL;

    SELECT first_name, last_name INTO p_first_name, p_last_name
    FROM customer
    WHERE customer_id = p_customer_id;
    EXCEPTion
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' not found.');
            RETURN;
    
    -- Update reservation status
    UPDATE RESERVATION
    SET status = p_new_status
    WHERE reservation_id = p_reservation_id AND customer_id = p_customer_id;
    
    -- Update waitlist status
    UPDATE WAITLIST
    SET status = p_new_waitlist_status
    WHERE activity_id IN (SELECT activity_id FROM RESERVATION_DETAILS WHERE reservation_id = p_reservation_id) AND customer_id = p_customer_id;
    
    COMMIT;

END;
/
DECLARE 
    v_first_name VARCHAR2(10);
    v_last_name VARCHAR2(10);

BEGIN
    update_reservation_and_waitlist_ac(
        p_customer_id => 103,
        p_first_name => v_first_name,
        p_last_name => v_last_name,
        p_reservation_id => 201,
        p_new_status => 'SUCCESSFUL',
        p_new_waitlist_status => 'COMPLETED'
    );
    DBMS_OUTPUT.PUT_LINE('The latest reservation and the waitlist for ' || (v_first_name || ' ' || v_last_name) || ' is updated.');

END;
/

/* Function 1: Calculate the total number of customer that paid their 
reservation using eWallet.*/

CREATE OR REPLACE FUNCTION count_customers_using_ewallet
RETURN NUMBER
AS
    total_customers NUMBER := 0;

BEGIN
    SELECT COUNT(DISTINCT c.customer_id) INTO total_customers
    FROM CUSTOMER c
    JOIN RESERVATION r
    ON c.customer_id = r.customer_id
    JOIN PAYMENTS p
    ON r.reservation_id = p.reservation_id
    JOIN EWALLET e
    ON p.payment_id = e.payment_id
    WHERE p.payment_id = e.payment_id
    AND p.reservation_id = r.reservation_id
    AND r.customer_id = c.customer_id;
    
    RETURN total_customers;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

DECLARE
    v_total_customers NUMBER;
BEGIN
    v_total_customers := count_customers_using_ewallet();
    DBMS_OUTPUT.PUT_LINE('Total number of customers using eWallet: ' || v_total_customers);
END;
/

/* Function 2: Calculate the total of expenses by  Express Lane customers.*/

CREATE OR REPLACE FUNCTION express_lane_customers_expenses_total
RETURN NUMBER
AS
    v_total_sales NUMBER := 0;

BEGIN
    SELECT SUM(p.amount) INTO v_total_sales
    FROM PAYMENTS p
    JOIN RESERVATION r 
    ON p.reservation_id = r.reservation_id
    JOIN EXPRESSLANE_CUSTOMER ec
    ON r.customer_id = ec.customer_id;

    RETURN v_total_sales;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;

END;
/

DECLARE
    v_total_sales NUMBER;

BEGIN
    v_total_sales := express_lane_customers_expenses_total();
    IF v_total_sales != 0 THEN
        DBMS_OUTPUT.PUT_LINE('The total expenses for Express Lane customer is RM' || v_total_sales || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('There is no sales for Express Lane customer.');
    END IF;

END;
/
