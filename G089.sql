/*
COURSE CODE: UCCD2303) 
PROGRAMME (IA/IB/CS)/DE: CS
GROUP NUMBER e.g. G001: G
GROUP LEADER NAME & EMAIL: Teoh Jia Jun / 
MEMBER 2 NAME: Ler Jun Wei
MEMBER 3 NAME: Lai Wei Bin
MEMBER 4 NAME: Tey Yong Sheng
Submission date and time (DD-MON-YY):

GROUP ASSIGNMENT SUBMISSION
Submit one individual report ith SQL statements only (*.docx)
and one sql script (*.sql for Oracle)

Template save as "G999.sql"  e.g. G001.sql
Part 1 script only.
Refer to the format of Northwoods.sql as an example for group sql script submission

Your GROUP member information should appear in both files one individual report docx & one individual sql script, 
then save as G01.zip


*/
-- script to create RESERVATION database
-- revised 8/17/2002 JM

DROP TABLE reservation CASCADE CONSTRAINTS;
DROP TABLE reservation_details CASCADE CONSTRAINTS;
DROP TABLE activity CASCADE CONSTRAINTS;
DROP TABLE waitlist CASCADE CONSTRAINTS;
DROP TABLE resources CASCADE CONSTRAINTS;
DROP TABLE payments CASCADE CONSTRAINTS;
DROP TABLE report CASCADE CONSTRAINTS;
DROP TABLE notification CASCADE CONSTRAINTS;
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE annual_customer CASCADE CONSTRAINTS;
DROP TABLE normallane_customer CASCADE CONSTRAINTS;
DROP TABLE expresslane_customer CASCADE CONSTRAINTS;
DROP TABLE cash CASCADE CONSTRAINTS;
DROP TABLE card CASCADE CONSTRAINTS;
DROP TABLE ewallet CASCADE CONSTRAINTS;
DROP TABLE amusement_park CASCADE CONSTRAINTS;
DROP TABLE water_park CASCADE CONSTRAINTS;
DROP TABLE wildlife_park CASCADE CONSTRAINTS;

CREATE TABLE CUSTOMER
(customer_id NUMBER(6),
first_name VARCHAR2(10),
last_name VARCHAR2(10),
email VARCHAR2(30),
phone_num NUMBER(11),
address VARCHAR2(30),
CONSTRAINT customer_customer_id_pk PRIMARY KEY (customer_id));

CREATE TABLE ANNUAL_CUSTOMER
(customer_id NUMBER(6),
MembershipStartDate DATE,
MembershipEndDate DATE,
CONSTRAINT annual_customer_customer_id_pk PRIMARY KEY (customer_id),
CONSTRAINT annual_customer_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id));

CREATE TABLE NORMALLANE_CUSTOMER
(customer_id NUMBER(6),
TicketType VARCHAR2(10),
CONSTRAINT normallane_customer_customer_id_pk PRIMARY KEY (customer_id),
CONSTRAINT normallane_customer_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id));

CREATE TABLE EXPRESSLANE_CUSTOMER
(customer_id NUMBER(6),
ExpressPass_id NUMBER(6),
CONSTRAINT expresslane_customer_customer_id_pk PRIMARY KEY (customer_id),
CONSTRAINT expresslane_customer_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id));

CREATE TABLE RESERVATION
(reservation_id NUMBER(6),
customer_id NUMBER(6),
status VARCHAR2(15),
payment_status VARCHAR2(11), 
CONSTRAINT reservation_reservation_id_pk PRIMARY KEY (reservation_id),
CONSTRAINT reservation_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
CONSTRAINT reservation_status_cc CHECK ((status = 'SUCCESSFUL') OR (status = 'PENDING') or (status = 'FAILED')),
CONSTRAINT reservation_payment_status_cc CHECK ((status = 'SUCCESSFUL') OR (status = 'PENDING') OR (status = 'FAILED')));

CREATE TABLE NOTIFICATION
(notification_id NUMBER(6),
reservation_id NUMBER(6),
status VARCHAR2(12),
timestamp TIMESTAMP, 
CONSTRAINT notification_notification_id_pk PRIMARY KEY (notification_id),
CONSTRAINT notification_reservation_id_fk FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
CONSTRAINT notification_status_cc CHECK ((status = 'SUCCESSFULL') OR (status = 'PENDING') OR (status = 'FAILED')));

CREATE TABLE REPORT
(report_id NUMBER(6),
amount_0f_reservation NUMBER(4),
total_sales NUMBER(10),
CONSTRAINT report_report_id_pk PRIMARY KEY (report_id));

CREATE TABLE PAYMENTS
(payment_id NUMBER(6),
reservation_id NUMBER(6),
amount NUMBER(4),
timestamp TIMESTAMP,
CONSTRAINT payments_payment_id_pk PRIMARY KEY (payment_id),
CONSTRAINT payments_reservation_id_fk FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id));

CREATE TABLE CASH
(payment_id NUMBER(6),
cash_received NUMBER(4),
cash_returned NUMBER(4),
CONSTRAINT cash_payment_id_pk PRIMARY KEY (payment_id),
CONSTRAINT cash_payment_id_fk FOREIGN KEY (payment_id) REFERENCES payments(payment_id));

CREATE TABLE CARD
(payment_id NUMBER(6),
CardNumber VARCHAR2(16),
ExpiryDate DATE,
cvv VARCHAR2(3),
CONSTRAINT card_payment_id_pk PRIMARY KEY (payment_id),
CONSTRAINT card_payment_id_fk FOREIGN KEY (payment_id) REFERENCES payments(payment_id));

CREATE TABLE EWALLET
(payment_id NUMBER(6),
ewallet_id VARCHAR2(30),
CONSTRAINT ewallet_payment_id_pk PRIMARY KEY (payment_id),
CONSTRAINT ewallet_payment_id_fk FOREIGN KEY (payment_id) REFERENCES payments(payment_id));

CREATE TABLE ACTIVITY
(activity_id NUMBER(6),
name VARCHAR2(30),
capacity NUMBER(5),
price NUMBER(5),
description VARCHAR2(100),
CONSTRAINT activity_activity_id_pk PRIMARY KEY (activity_id));

CREATE TABLE AMUSEMENT_PARK
(activity_id NUMBER(6),
FacilitiesType VARCHAR2(20),
SpecialShow VARCHAR2(20),
CONSTRAINT amusement_park_activity_id_pk PRIMARY KEY (activity_id),
CONSTRAINT amusement_park_activity_id_fk FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
CONSTRAINT amusement_park_SpecialShow_cc CHECK ((SpecialShow = 'have') OR (SpecialShow = 'no')),
CONSTRAINT amusement_park_FacilitiesType_cc CHECK ((FacilitiesType = 'flat') OR (FacilitiesType = 'gravity') OR (FacilitiesType = 'vertical')));

CREATE TABLE WATER_PARK
(activity_id NUMBER(6),
PoolType VARCHAR2(20),
TubeRental NUMBER(3),
TowelRental NUMBER(3),
CONSTRAINT water_park_activity_id_pk PRIMARY KEY (activity_id),
CONSTRAINT water_park_activity_id_fk FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
CONSTRAINT water_park_PoolType_cc CHECK ((PoolType = 'wave pool') OR (PoolType = 'lazy river') OR (PoolType = 'banana flip') OR (PoolType = 'tube ride')));

CREATE TABLE WILDLIFE_PARK
(activity_id NUMBER(6),
TypeOfAnimals VARCHAR2(20),
InteractionSessions VARCHAR2(4),
CONSTRAINT wildlife_park_activity_id_pk PRIMARY KEY (activity_id),
CONSTRAINT wildlife_park_activity_id_fk FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
CONSTRAINT wildlife_park_InteractionSessions_cc CHECK ((InteractionSessions = 'have') OR (InteractionSessions = 'no')),
CONSTRAINT wildlife_park_TypeOfAnimals_cc CHECK ((TypeOfAnimals = 'mammals') OR (TypeOfAnimals = 'birds') OR (TypeOfAnimals = 'reptiles') OR (TypeOfAnimals = 'marine organism')));

CREATE TABLE RESERVATION_DETAILS
(reservation_id NUMBER(6),
activity_id NUMBER(6),
CONSTRAINT reservation_details_pk PRIMARY KEY (reservation_id, activity_id),
CONSTRAINT reservation_details_reservation_id_fk FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
CONSTRAINT reservation_details_activity_id_fk FOREIGN KEY (activity_id) REFERENCES activity(activity_id));

CREATE TABLE WAITLIST
(waitlist_id NUMBER(6),
activity_id NUMBER(6),
customer_id NUMBER(6),
status VARCHAR2(11),
CONSTRAINT waitlist_waitlist_id_pk PRIMARY KEY (waitlist_id),
CONSTRAINT waitlist_activity_id_fk FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
CONSTRAINT waitlist_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
CONSTRAINT waitlist_status_cc CHECK ((status = 'COMPLETED') OR (status = 'FAILED') OR (status = 'PENDING')));

CREATE TABLE RESOURCES
(resource_id NUMBER(6),
name VARCHAR2(30),
description VARCHAR2(30),
available_seats NUMBER(5),
CONSTRAINT resource_resource_id_pk PRIMARY KEY (resource_id));

-- Inserting records into the CUSTOMER table
INSERT INTO CUSTOMER VALUES
(101, 'John', 'Doe', 'john@example.com', 1234567890, '123 Main St');
INSERT INTO CUSTOMER VALUES
(102, 'Jane', 'Smith', 'jane@example.com', 9876543210, '456 Oak Ave');
INSERT INTO CUSTOMER VALUES
(103, 'Michael', 'Johnson', 'michael@example.com', 5551234567, '789 Elm Rd');
INSERT INTO CUSTOMER VALUES
(104, 'Emily', 'Brown', 'emily@example.com', 9998887777, '321 Pine St');
INSERT INTO CUSTOMER VALUES
(105, 'David', 'Lee', 'david@example.com', 7779998888, '654 Maple Dr');
INSERT INTO CUSTOMER VALUES
(106, 'Jessica', 'Taylor', 'jessica@example.com', 1112223333, '987 Cedar Ave');
INSERT INTO CUSTOMER VALUES
(107, 'William', 'Anderson', 'william@example.com', 4445556666, '210 Elm St');
INSERT INTO CUSTOMER VALUES
(108, 'Sarah', 'Wilson', 'sarah@example.com', 7778889999, '369 Pine Ave');
INSERT INTO CUSTOMER VALUES
(109, 'Christ', 'Martinez', 'christopher@example.com', 8889990000, '741 Oak St');
INSERT INTO CUSTOMER VALUES
(110, 'Jennifer', 'Garcia', 'jennifer@example.com', 2223334444, '852 Maple Ave');

-- Inserting records into the ANNUAL_CUSTOMER table
INSERT INTO ANNUAL_CUSTOMER VALUES
(101, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO ANNUAL_CUSTOMER VALUES
(102, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2025-02-14', 'YYYY-MM-DD'));
INSERT INTO ANNUAL_CUSTOMER VALUES
(103, TO_DATE('2024-03-20', 'YYYY-MM-DD'), TO_DATE('2025-03-19', 'YYYY-MM-DD'));
INSERT INTO ANNUAL_CUSTOMER VALUES
(104, TO_DATE('2024-04-10', 'YYYY-MM-DD'), TO_DATE('2025-04-09', 'YYYY-MM-DD'));
INSERT INTO ANNUAL_CUSTOMER VALUES
(105, TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2025-05-04', 'YYYY-MM-DD'));

-- Inserting records into the NORMALLANE_CUSTOMER table
INSERT INTO NORMALLANE_CUSTOMER VALUES
(106, 'Single');
INSERT INTO NORMALLANE_CUSTOMER VALUES
(108, 'Family');
INSERT INTO NORMALLANE_CUSTOMER VALUES
(109, 'Couple');
INSERT INTO NORMALLANE_CUSTOMER VALUES
(110, 'Single');
INSERT INTO NORMALLANE_CUSTOMER VALUES
(107, 'Family');

-- Inserting records into the EXPRESSLANE_CUSTOMER table
INSERT INTO EXPRESSLANE_CUSTOMER VALUES
(101, 201);
INSERT INTO EXPRESSLANE_CUSTOMER VALUES
(102, 202);
INSERT INTO EXPRESSLANE_CUSTOMER VALUES
(103, 203);
INSERT INTO EXPRESSLANE_CUSTOMER VALUES
(104, 204);
INSERT INTO EXPRESSLANE_CUSTOMER VALUES
(105, 205);

-- Inserting records into the RESERVATION table
INSERT INTO RESERVATION VALUES
(201, 101, 'SUCCESSFUL', 'PENDING');
INSERT INTO RESERVATION VALUES
(202, 102, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(203, 103, 'SUCCESSFUL', 'SUCCESSFUL');
INSERT INTO RESERVATION VALUES
(204, 104, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(205, 105, 'FAILED', 'FAILED');
INSERT INTO RESERVATION VALUES
(206, 101, 'SUCCESSFUL', 'SUCCESSFUL');
INSERT INTO RESERVATION VALUES
(207, 102, 'FAILED', 'FAILED');
INSERT INTO RESERVATION VALUES
(208, 103, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(209, 104, 'SUCCESSFUL', 'SUCCESSFUL');
INSERT INTO RESERVATION VALUES
(210, 105, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(211, 101, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(212, 102, 'SUCCESSFUL', 'SUCCESSFUL');
INSERT INTO RESERVATION VALUES
(213, 103, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(214, 104, 'PENDING', 'PENDING');
INSERT INTO RESERVATION VALUES
(215, 105, 'SUCCESSFUL', 'SUCCESSFUL');

-- Inserting records into the NOTIFICATION table
INSERT INTO NOTIFICATION VALUES
(301, 201, 'PENDING', TIMESTAMP '2024-04-10 12:00:00');
INSERT INTO NOTIFICATION VALUES
(302, 202, 'PENDING', TIMESTAMP '2024-04-10 12:15:00');
INSERT INTO NOTIFICATION VALUES
(303, 203, 'SUCCESSFULL', TIMESTAMP '2024-04-10 12:30:00');
INSERT INTO NOTIFICATION VALUES
(304, 204, 'PENDING', TIMESTAMP '2024-04-10 12:45:00');
INSERT INTO NOTIFICATION VALUES
(305, 205, 'PENDING', TIMESTAMP '2024-04-10 13:00:00');

-- Inserting records into the REPORT table
INSERT INTO REPORT VALUES
(111, 10, 500);
INSERT INTO REPORT VALUES
(112, 15, 450);
INSERT INTO REPORT VALUES
(113, 20, 600);
INSERT INTO REPORT VALUES
(114, 25, 1000);
INSERT INTO REPORT VALUES
(115, 30, 1500);

-- Inserting records into the PAYMENTS table
INSERT INTO PAYMENTS VALUES
(401, 201, 50, TIMESTAMP '2024-04-10 12:00:00');
INSERT INTO PAYMENTS VALUES
(402, 202, 40, TIMESTAMP '2024-04-10 12:15:00');
INSERT INTO PAYMENTS VALUES
(403, 203, 70, TIMESTAMP '2024-04-10 12:30:00');
INSERT INTO PAYMENTS VALUES
(404, 204, 60, TIMESTAMP '2024-04-10 12:45:00');
INSERT INTO PAYMENTS VALUES
(405, 205, 30, TIMESTAMP '2024-04-10 13:00:00');
INSERT INTO PAYMENTS VALUES
(406, 206, 50, TIMESTAMP '2024-04-10 13:15:00');
INSERT INTO PAYMENTS VALUES
(407, 207, 40, TIMESTAMP '2024-04-10 13:30:00');
INSERT INTO PAYMENTS VALUES
(408, 208, 70, TIMESTAMP '2024-04-10 13:45:00');
INSERT INTO PAYMENTS VALUES
(409, 209, 60, TIMESTAMP '2024-04-10 14:00:00');
INSERT INTO PAYMENTS VALUES
(410, 210, 30, TIMESTAMP '2024-04-10 14:15:00');
INSERT INTO PAYMENTS VALUES
(411, 211, 50, TIMESTAMP '2024-04-10 14:30:00');
INSERT INTO PAYMENTS VALUES
(412, 212, 40, TIMESTAMP '2024-04-10 14:45:00');
INSERT INTO PAYMENTS VALUES
(413, 213, 70, TIMESTAMP '2024-04-10 15:00:00');
INSERT INTO PAYMENTS VALUES
(414, 214, 60, TIMESTAMP '2024-04-10 15:15:00');
INSERT INTO PAYMENTS VALUES
(415, 215, 30, TIMESTAMP '2024-04-10 15:30:00');

-- Inserting records into the CASH table
INSERT INTO CASH VALUES 
(401, 50, 0);
INSERT INTO CASH VALUES 
(402, 50, 10);
INSERT INTO CASH VALUES 
(403, 100, 30);
INSERT INTO CASH VALUES 
(404, 60, 0);
INSERT INTO CASH VALUES 
(405, 30, 0);

-- Inserting records into the CARD table
INSERT INTO CARD VALUES 
(411, '1234567890123456', DATE '2025-12-31', '123');
INSERT INTO CARD VALUES 
(412, '2345678901234567', DATE '2025-12-31', '234');
INSERT INTO CARD VALUES 
(413, '3456789012345678', DATE '2025-12-31', '345');
INSERT INTO CARD VALUES 
(414, '4567890123456789', DATE '2025-12-31', '456');
INSERT INTO CARD VALUES 
(415, '5678901234567890', DATE '2025-12-31', '567');

-- Inserting records into the EWALLET table
INSERT INTO EWALLET VALUES 
(406, '202404104646562216879566');
INSERT INTO EWALLET VALUES 
(407, '202404104643632216879566');
INSERT INTO EWALLET VALUES 
(408, '202404104646597216879566');
INSERT INTO EWALLET VALUES 
(409, '202404104649332216879566');
INSERT INTO EWALLET VALUES 
(410, '202404104646562216731566');

-- Inserting records into the ACTIVITY table
INSERT INTO ACTIVITY VALUES
(501, 'Amusement Park', 100, 50, 'Super exciting! Super Fun!');
INSERT INTO ACTIVITY VALUES
(502, 'Amusement Park', 50, 50, 'Super exciting! Super Fun!');
INSERT INTO ACTIVITY VALUES
(503, 'Amusement Park', 50, 50, 'Super exciting! Super Fun!');
INSERT INTO ACTIVITY VALUES
(504, 'Water Park', 50, 30, 'Best Choice in Summer!');
INSERT INTO ACTIVITY VALUES
(505, 'Water Park', 35, 30, 'Best Choice in Summer!');
INSERT INTO ACTIVITY VALUES
(506, 'Water Park', 65, 30, 'Best Choice in Summer!');
INSERT INTO ACTIVITY VALUES
(507, 'Water Park', 65, 30, 'Best Choice in Summer!');
INSERT INTO ACTIVITY VALUES
(508, 'Wildlife Park', 70, 40, 'Come and Play with animals!');
INSERT INTO ACTIVITY VALUES
(509, 'Wildlife Park', 80, 40, 'Come and Play with animals!');
INSERT INTO ACTIVITY VALUES
(510, 'Wildlife Park', 20, 40, 'Come and Play with animals!');
INSERT INTO ACTIVITY VALUES
(511, 'Wildlife Park', 30, 40, 'Come and Play with animals!');
INSERT INTO ACTIVITY VALUES
(512, 'Wildlife Park', 30, 40, 'Come and Play with animals!');
INSERT INTO ACTIVITY VALUES
(513, 'Amusement Park', 60, 50, 'Super exciting! Super Fun!');
INSERT INTO ACTIVITY VALUES
(514, 'Amusement Park', 60, 50, 'Super exciting! Super Fun!');
INSERT INTO ACTIVITY VALUES
(515, 'Water Park', 35, 30, 'Best Choice in Summer!');


-- Inserting records into the AMUSEMENT_PARK table
INSERT INTO AMUSEMENT_PARK VALUES
(501, 'flat', 'have');
INSERT INTO AMUSEMENT_PARK VALUES
(502, 'gravity', 'have');
INSERT INTO AMUSEMENT_PARK VALUES
(503, 'gravity', 'no');
INSERT INTO AMUSEMENT_PARK VALUES
(513, 'gravity', 'no');
INSERT INTO AMUSEMENT_PARK VALUES
(514, 'vertical', 'no');


-- Inserting records into the WATER_PARK table
INSERT INTO WATER_PARK VALUES
(504, 'wave pool', 5, 10);
INSERT INTO WATER_PARK VALUES
(505, 'lazy river', 5, 10);
INSERT INTO WATER_PARK VALUES
(506, 'banana flip', 5, 10);
INSERT INTO WATER_PARK VALUES
(507, 'tube ride', 5, 10);
INSERT INTO WATER_PARK VALUES
(515, 'wave pool', 5, 10);

-- Inserting records into the WILDLIFE_PARK table 
INSERT INTO WILDLIFE_PARK VALUES
(508, 'mammals', 'have');
INSERT INTO WILDLIFE_PARK VALUES
(509, 'birds', 'have');
INSERT INTO WILDLIFE_PARK VALUES
(510, 'reptiles', 'have');
INSERT INTO WILDLIFE_PARK VALUES
(511, 'marine organism', 'have');
INSERT INTO WILDLIFE_PARK VALUES
(512, 'mammals', 'no');

-- Inserting records into the RESERVATION_DETAILS table
INSERT INTO RESERVATION_DETAILS VALUES
(201, 501);
INSERT INTO RESERVATION_DETAILS VALUES
(202, 502);
INSERT INTO RESERVATION_DETAILS VALUES
(203, 513);
INSERT INTO RESERVATION_DETAILS VALUES
(204, 504);
INSERT INTO RESERVATION_DETAILS VALUES
(205, 515);

-- Inserting records into the WAITLIST table
INSERT INTO WAITLIST VALUES
(221, 501, 101, 'PENDING');
INSERT INTO WAITLIST VALUES
(222, 502, 102, 'FAILED');
INSERT INTO WAITLIST VALUES
(223, 513, 103, 'COMPLETED');
INSERT INTO WAITLIST VALUES
(224, 504, 104, 'PENDING');
INSERT INTO WAITLIST VALUES
(225, 515, 105, 'COMPLETED');

-- Inserting records into the RESOURCES table
INSERT INTO RESOURCES VALUES
(331, 'Station A', 'Amusement Park', 20);
INSERT INTO RESOURCES VALUES
(332, 'Station B', 'Water Park', 30);
INSERT INTO RESOURCES VALUES
(333, 'Station C', 'Wildlife Park', 50);
INSERT INTO RESOURCES VALUES
(334, 'Station C', 'Wildlife Park', 10);
INSERT INTO RESOURCES VALUES
(335, 'Station B', 'Water Park', 5);


COMMIT;







