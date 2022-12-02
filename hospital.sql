-- DATABASE HOSPITAL
-- https://en.wikibooks.org/wiki/SQL_Exercises/The_Hospital

CREATE DATABASE HOSPITAL

DROP TABLE IF EXISTS Physician;
CREATE TABLE Physician (
  EmployeeID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  SSN INTEGER NOT NULL,
  CONSTRAINT pk_physician PRIMARY KEY(EmployeeID)
); 

DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
  DepartmentID INTEGER NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Head INTEGER NOT NULL,
  CONSTRAINT pk_Department PRIMARY KEY(DepartmentID),
  CONSTRAINT fk_Department_Physician_EmployeeID FOREIGN KEY(Head) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Affiliated_With;
CREATE TABLE Affiliated_With (
  Physician INTEGER NOT NULL,
  Department INTEGER NOT NULL,
  PrimaryAffiliation BIT NOT NULL,
  CONSTRAINT fk_Affiliated_With_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Affiliated_With_Department_DepartmentID FOREIGN KEY(Department) REFERENCES Department(DepartmentID),
  PRIMARY KEY(Physician, Department)
);

DROP TABLE IF EXISTS Procedures;
CREATE TABLE Procedures (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Cost REAL NOT NULL
);

DROP TABLE IF EXISTS Trained_In;
CREATE TABLE Trained_In (
  Physician INTEGER NOT NULL,
  Treatment INTEGER NOT NULL,
  CertificationDate DATE NOT NULL,
  CertificationExpires DATE NOT NULL,
  CONSTRAINT fk_Trained_In_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Trained_In_Procedures_Code FOREIGN KEY(Treatment) REFERENCES Procedures(Code),
  PRIMARY KEY(Physician, Treatment)
);

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient (
  SSN INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Address VARCHAR(30) NOT NULL,
  Phone VARCHAR(30) NOT NULL,
  InsuranceID INTEGER NOT NULL,
  PCP INTEGER NOT NULL,
  CONSTRAINT fk_Patient_Physician_EmployeeID FOREIGN KEY(PCP) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Nurse;
CREATE TABLE Nurse (
  EmployeeID INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Position VARCHAR(30) NOT NULL,
  Registered BIT NOT NULL,
  SSN INTEGER NOT NULL
);

DROP TABLE IF EXISTS Appointment;
CREATE TABLE Appointment (
  AppointmentID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,    
  PrepNurse INTEGER,
  Physician INTEGER NOT NULL,
  Starto DATE NOT NULL,
  Endo DATE NOT NULL,
  ExaminationRoom TEXT NOT NULL,
  CONSTRAINT fk_Appointment_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Appointment_Nurse_EmployeeID FOREIGN KEY(PrepNurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_Appointment_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID)
);

DROP TABLE IF EXISTS Medication;
CREATE TABLE Medication (
  Code INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR(30) NOT NULL,
  Brand VARCHAR(30) NOT NULL,
  Description VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS Prescribes;
CREATE TABLE Prescribes (
  Physician INTEGER NOT NULL,
  Patient INTEGER NOT NULL, 
  Medication INTEGER NOT NULL, 
  Date DATE NOT NULL,
  Appointment INTEGER,  
  Dose VARCHAR(30) NOT NULL,
  PRIMARY KEY(Physician, Patient, Medication, Date),
  CONSTRAINT fk_Prescribes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Prescribes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Prescribes_Medication_Code FOREIGN KEY(Medication) REFERENCES Medication(Code),
  CONSTRAINT fk_Prescribes_Appointment_AppointmentID FOREIGN KEY(Appointment) REFERENCES Appointment(AppointmentID)
);

DROP TABLE IF EXISTS Block;
CREATE TABLE Block (
  BlockFloor INTEGER NOT NULL,
  BlockCode INTEGER NOT NULL,
  PRIMARY KEY(BlockFloor, BlockCode)
); 

DROP TABLE IF EXISTS Room;
CREATE TABLE Room (
  RoomNumber INTEGER PRIMARY KEY NOT NULL,
  RoomType VARCHAR(30) NOT NULL,
  BlockFloor INTEGER NOT NULL,  
  BlockCode INTEGER NOT NULL,  
  Unavailable BIT NOT NULL,
  CONSTRAINT fk_Room_Block_PK FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode)
);

DROP TABLE IF EXISTS On_Call;
CREATE TABLE On_Call (
  Nurse INTEGER NOT NULL,
  BlockFloor INTEGER NOT NULL, 
  BlockCode INTEGER NOT NULL,
  OnCallStart DATE NOT NULL,
  OnCallEnd DATE NOT NULL,
  PRIMARY KEY(Nurse, BlockFloor, BlockCode, OnCallStart, OnCallEnd),
  CONSTRAINT fk_OnCall_Nurse_EmployeeID FOREIGN KEY(Nurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_OnCall_Block_Floor FOREIGN KEY(BlockFloor, BlockCode) REFERENCES Block(BlockFloor, BlockCode) 
);

DROP TABLE IF EXISTS Stay;
CREATE TABLE Stay (
  StayID INTEGER PRIMARY KEY NOT NULL,
  Patient INTEGER NOT NULL,
  Room INTEGER NOT NULL,
  StayStart DATE NOT NULL,
  StayEnd DATE NOT NULL,
  CONSTRAINT fk_Stay_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Stay_Room_Number FOREIGN KEY(Room) REFERENCES Room(RoomNumber)
);

DROP TABLE IF EXISTS Undergoes;
CREATE TABLE Undergoes (
  Patient INTEGER NOT NULL,
  Procedures INTEGER NOT NULL,
  Stay INTEGER NOT NULL,
  DateUndergoes DATE NOT NULL,
  Physician INTEGER NOT NULL,
  AssistingNurse INTEGER,
  PRIMARY KEY(Patient, Procedures, Stay, DateUndergoes),
  CONSTRAINT fk_Undergoes_Patient_SSN FOREIGN KEY(Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_Undergoes_Procedures_Code FOREIGN KEY(Procedures) REFERENCES Procedures(Code),
  CONSTRAINT fk_Undergoes_Stay_StayID FOREIGN KEY(Stay) REFERENCES Stay(StayID),
  CONSTRAINT fk_Undergoes_Physician_EmployeeID FOREIGN KEY(Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_Undergoes_Nurse_EmployeeID FOREIGN KEY(AssistingNurse) REFERENCES Nurse(EmployeeID)
);

-- SAMPLE DATA

INSERT INTO Physician VALUES(1,'John Dorian','Staff Internist',111111111);
INSERT INTO Physician VALUES(2,'Elliot Reid','Attending Physician',222222222);
INSERT INTO Physician VALUES(3,'Christopher Turk','Surgical Attending Physician',333333333);
INSERT INTO Physician VALUES(4,'Percival Cox','Senior Attending Physician',444444444);
INSERT INTO Physician VALUES(5,'Bob Kelso','Head Chief of Medicine',555555555);
INSERT INTO Physician VALUES(6,'Todd Quinlan','Surgical Attending Physician',666666666);
INSERT INTO Physician VALUES(7,'John Wen','Surgical Attending Physician',777777777);
INSERT INTO Physician VALUES(8,'Keith Dudemeister','MD Resident',888888888);
INSERT INTO Physician VALUES(9,'Molly Clock','Attending Psychiatrist',999999999);

INSERT INTO Department VALUES(1,'General Medicine',4);
INSERT INTO Department VALUES(2,'Surgery',7);
INSERT INTO Department VALUES(3,'Psychiatry',9);

INSERT INTO Affiliated_With VALUES(1,1,B'1');  -- changed datatype BIT
INSERT INTO Affiliated_With VALUES(2,1,B'1');
INSERT INTO Affiliated_With VALUES(3,1,B'0');
INSERT INTO Affiliated_With VALUES(3,2,B'1');
INSERT INTO Affiliated_With VALUES(4,1,B'1');
INSERT INTO Affiliated_With VALUES(5,1,B'1');
INSERT INTO Affiliated_With VALUES(6,2,B'1');
INSERT INTO Affiliated_With VALUES(7,1,B'0');
INSERT INTO Affiliated_With VALUES(7,2,B'1');
INSERT INTO Affiliated_With VALUES(8,1,B'1');
INSERT INTO Affiliated_With VALUES(9,3,B'1');

INSERT INTO Procedures VALUES(1,'Reverse Rhinopodoplasty',1500.0);
INSERT INTO Procedures VALUES(2,'Obtuse Pyloric Recombobulation',3750.0);
INSERT INTO Procedures VALUES(3,'Folded Demiophtalmectomy',4500.0);
INSERT INTO Procedures VALUES(4,'Complete Walletectomy',10000.0);
INSERT INTO Procedures VALUES(5,'Obfuscated Dermogastrotomy',4899.0);
INSERT INTO Procedures VALUES(6,'Reversible Pancreomyoplasty',5600.0);
INSERT INTO Procedures VALUES(7,'Follicular Demiectomy',25.0);

INSERT INTO Patient VALUES(100000001,'John Smith','42 Foobar Lane','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000002,'Grace Ritchie','37 Snafu Drive','555-0512',36546321,2);
INSERT INTO Patient VALUES(100000003,'Random J. Patient','101 Omgbbq Street','555-1204',65465421,2);
INSERT INTO Patient VALUES(100000004,'Dennis Doe','1100 Foobaz Avenue','555-2048',68421879,3);

INSERT INTO Nurse VALUES(101,'Carla Espinosa','Head Nurse',B'1',111111110); -- change BIT datatype value
INSERT INTO Nurse VALUES(102,'Laverne Roberts','Nurse',B'1',222222220);
INSERT INTO Nurse VALUES(103,'Paul Flowers','Nurse',B'0',333333330);

INSERT INTO Appointment VALUES(13216584,100000001,101,1,'2008-04-24 10:00','2008-04-24 11:00','A');
INSERT INTO Appointment VALUES(26548913,100000002,101,2,'2008-04-24 10:00','2008-04-24 11:00','B');
INSERT INTO Appointment VALUES(36549879,100000001,102,1,'2008-04-25 10:00','2008-04-25 11:00','A');
INSERT INTO Appointment VALUES(46846589,100000004,103,4,'2008-04-25 10:00','2008-04-25 11:00','B');
INSERT INTO Appointment VALUES(59871321,100000004,NULL,4,'2008-04-26 10:00','2008-04-26 11:00','C');
INSERT INTO Appointment VALUES(69879231,100000003,103,2,'2008-04-26 11:00','2008-04-26 12:00','C');
INSERT INTO Appointment VALUES(76983231,100000001,NULL,3,'2008-04-26 12:00','2008-04-26 13:00','C');
INSERT INTO Appointment VALUES(86213939,100000004,102,9,'2008-04-27 10:00','2008-04-21 11:00','A');
INSERT INTO Appointment VALUES(93216548,100000002,101,2,'2008-04-27 10:00','2008-04-27 11:00','B');

INSERT INTO Medication VALUES(1,'Procrastin-X','X','N/A');
INSERT INTO Medication VALUES(2,'Thesisin','Foo Labs','N/A');
INSERT INTO Medication VALUES(3,'Awakin','Bar Laboratories','N/A');
INSERT INTO Medication VALUES(4,'Crescavitin','Baz Industries','N/A');
INSERT INTO Medication VALUES(5,'Melioraurin','Snafu Pharmaceuticals','N/A');

INSERT INTO Prescribes VALUES(1,100000001,1,'2008-04-24 10:47',13216584,'5');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-27 10:53',86213939,'10');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-30 16:53',NULL,'5');

INSERT INTO Block VALUES(1,1);
INSERT INTO Block VALUES(1,2);
INSERT INTO Block VALUES(1,3);
INSERT INTO Block VALUES(2,1);
INSERT INTO Block VALUES(2,2);
INSERT INTO Block VALUES(2,3);
INSERT INTO Block VALUES(3,1);
INSERT INTO Block VALUES(3,2);
INSERT INTO Block VALUES(3,3);
INSERT INTO Block VALUES(4,1);
INSERT INTO Block VALUES(4,2);
INSERT INTO Block VALUES(4,3);

INSERT INTO Room VALUES(101,'Single',1,1,B'0');  -- changed datatype BIT 
INSERT INTO Room VALUES(102,'Single',1,1,B'0');
INSERT INTO Room VALUES(103,'Single',1,1,B'0');
INSERT INTO Room VALUES(111,'Single',1,2,B'0');
INSERT INTO Room VALUES(112,'Single',1,2,B'1');
INSERT INTO Room VALUES(113,'Single',1,2,B'0');
INSERT INTO Room VALUES(121,'Single',1,3,B'0');
INSERT INTO Room VALUES(122,'Single',1,3,B'0');
INSERT INTO Room VALUES(123,'Single',1,3,B'0');
INSERT INTO Room VALUES(201,'Single',2,1,B'1');
INSERT INTO Room VALUES(202,'Single',2,1,B'0');
INSERT INTO Room VALUES(203,'Single',2,1,B'0');
INSERT INTO Room VALUES(211,'Single',2,2,B'0');
INSERT INTO Room VALUES(212,'Single',2,2,B'0');
INSERT INTO Room VALUES(213,'Single',2,2,B'1');
INSERT INTO Room VALUES(221,'Single',2,3,B'0');
INSERT INTO Room VALUES(222,'Single',2,3,B'0');
INSERT INTO Room VALUES(223,'Single',2,3,B'0');
INSERT INTO Room VALUES(301,'Single',3,1,B'0');
INSERT INTO Room VALUES(302,'Single',3,1,B'1');
INSERT INTO Room VALUES(303,'Single',3,1,B'0');
INSERT INTO Room VALUES(311,'Single',3,2,B'0');
INSERT INTO Room VALUES(312,'Single',3,2,B'0');
INSERT INTO Room VALUES(313,'Single',3,2,B'0');
INSERT INTO Room VALUES(321,'Single',3,3,B'1');
INSERT INTO Room VALUES(322,'Single',3,3,B'0');
INSERT INTO Room VALUES(323,'Single',3,3,B'0');
INSERT INTO Room VALUES(401,'Single',4,1,B'0');
INSERT INTO Room VALUES(402,'Single',4,1,B'1');
INSERT INTO Room VALUES(403,'Single',4,1,B'0');
INSERT INTO Room VALUES(411,'Single',4,2,B'0');
INSERT INTO Room VALUES(412,'Single',4,2,B'0');
INSERT INTO Room VALUES(413,'Single',4,2,B'0');
INSERT INTO Room VALUES(421,'Single',4,3,B'1');
INSERT INTO Room VALUES(422,'Single',4,3,B'0');
INSERT INTO Room VALUES(423,'Single',4,3,B'0');

INSERT INTO On_Call VALUES(101,1,1,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(101,1,2,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(102,1,3,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(103,1,1,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,2,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,3,'2008-11-04 19:00','2008-11-05 03:00');

INSERT INTO Stay VALUES(3215,100000001,111,'2008-05-01','2008-05-04');
INSERT INTO Stay VALUES(3216,100000003,123,'2008-05-03','2008-05-14');
INSERT INTO Stay VALUES(3217,100000004,112,'2008-05-02','2008-05-03');

INSERT INTO Undergoes VALUES(100000001,6,3215,'2008-05-02',3,101);
INSERT INTO Undergoes VALUES(100000001,2,3215,'2008-05-03',7,101);
INSERT INTO Undergoes VALUES(100000004,1,3217,'2008-05-07',3,102);
INSERT INTO Undergoes VALUES(100000004,5,3217,'2008-05-09',6,NULL);
INSERT INTO Undergoes VALUES(100000001,7,3217,'2008-05-10',7,101);
INSERT INTO Undergoes VALUES(100000004,4,3217,'2008-05-13',3,103);

INSERT INTO Trained_In VALUES(3,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,7,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,5,'2007-01-01','2007-12-31');
INSERT INTO Trained_In VALUES(6,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,3,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,4,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,7,'2008-01-01','2008-12-31');

-- EXERCISES

-- Q1

/*
Obtain the names of all physicians that have performed a medical procedure 
they have never been certified to perform 
*/

SELECT Physician.Name
FROM Physician
   INNER JOIN Undergoes ON Physician.EmployeeID = Undergoes.Physician
   LEFT JOIN Trained_In ON Undergoes.Procedures = Trained_In.Treatment
AND Physician.EmployeeID = Trained_In.Physician
WHERE Trained_In.Treatment IS NULL
GROUP BY Physician.EmployeeID;

/*
SELECT P.Name
FROM Physician P
   INNER JOIN Undergoes U ON P.EmployeeID = U.Physician
   LEFT JOIN Trained_In TR ON U.Procedures = Tr.Treatment  
AND P.EmployeeID = Tr.Physician
WHERE Tr.Treatment IS NULL
GROUP BY P.EmployeeID;
*/

-- Q2

/*
Same as the previous query, but include the following information in the results: 
Physician name, name of procedure, date when the procedure was carried out, 
name of the patient the procedure was carried out on
*/

SELECT P.Name AS Physician, Pr.Name AS Procedure, U.Date, Pt.Name AS Patient 
  FROM Physician P, Undergoes U, Patient Pt, Procedure Pr
  WHERE U.Patient = Pt.SSN
    AND U.Procedure = Pr.Code
    AND U.Physician = P.EmployeeID
    AND NOT EXISTS 
              (
                SELECT * FROM Trained_In T
                WHERE T.Treatment = U.Procedure 
                AND T.Physician = U.Physician
              );

 -- Q3

 /* 
 Same as the previous query, but include the following information in the results: 
 Physician name, name of procedure, date when the procedure was carried out, 
 name of the patient the procedure was carried out on, and date when the certification expired
 */

 SELECT P.Name AS Physician, Pr.Name AS Procedure, U.Date, Pt.Name AS Patient, T.CertificationExpires
  FROM Physician P, Undergoes U, Patient Pt, Procedure Pr, Trained_In T
  WHERE U.Patient = Pt.SSN
    AND U.Procedure = Pr.Code
    AND U.Physician = P.EmployeeID
    AND Pr.Code = T.Treatment
    AND P.EmployeeID = T.Physician
    AND U.Date > T.CertificationExpires;

-- Q4
/*
Obtain the information for appointments where a patient met 
with a physician other than his/her primary care physician. 
Show the following information: Patient name, physician name, nurse name (if any), 
start and end time of appointment, examination room, 
and the name of the patient's primary care physician
*/

SELECT Pt.Name AS Patient, Ph.Name AS Physician, N.Name AS Nurse, 
A.Start, A.End, A.ExaminationRoom, PhPCP.Name AS PCP
FROM Patient Pt, Physician Ph, Physician PhPCP, Appointment A 
LEFT JOIN Nurse N ON A.PrepNurse = N.EmployeeID
 WHERE A.Patient = Pt.SSN
   AND A.Physician = Ph.EmployeeID
   AND Pt.PCP = PhPCP.EmployeeID
   AND A.Physician <> Pt.PCP;


-- Q5

/*
The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. 
There are no constraints in force to prevent inconsistencies between these two tables. 
More specifically, the Undergoes table may include a row where the patient ID 
does not match the one we would obtain from the Stay table through the Undergoes.Stay foreign key. 
Select all rows from Undergoes that exhibit this inconsistency.
*/

SELECT * FROM Undergoes U
 WHERE Patient <> 
   (
     SELECT Patient FROM Stay S
      WHERE U.Stay = S.StayID
   );


-- Q6

/*
Obtain the names of all the nurses who have ever been on call for room 123
*/

SELECT N.Name FROM Nurse N
 WHERE EmployeeID IN
   (
     SELECT OC.Nurse FROM On_Call OC, Room R
      WHERE OC.BlockFloor = R.BlockFloor
        AND OC.BlockCode = R.BlockCode
        AND R.Number = 123
   );


-- Q7

/*
The hospital has several examination rooms where appointments take place. 
Obtain the number of appointments that have taken place in each examination room.

*/

SELECT ExaminationRoom, COUNT(AppointmentID) AS Number FROM Appointment
GROUP BY ExaminationRoom;

-- Q8

/*
Write a SQL query to count the number of available rooms.
Return count as "Number of available rooms".
*/


SELECT COUNT(*) "Number of available rooms"
FROM room Where unavailable='0';

-- Q9
/*
 write a SQL query to find those physicians who are yet to be affiliated.
 Return Physician name as "Physician", Position, and department as "Department"
*/

SELECT p.name AS "Physician",
       p.position,
       d.name AS "Department"
FROM physician p
JOIN affiliated_with a ON a.physician=p.employeeid
JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='1'; -- for false

/*
Write a SQL query to find the patients with their physicians by whom they received preliminary treatment.
Return Patient name as "Patient", address as "Address", Physician name as "Physician" and address contains 'Foobaz'
*/

SELECT pt.name AS "Patient",
       pt.address AS "Address",
       pt.name AS "Physician"
FROM patient pt
JOIN physician ph ON pt.pcp=ph.employeeid
WHERE pt.address LIKE '%Foobaz%';
