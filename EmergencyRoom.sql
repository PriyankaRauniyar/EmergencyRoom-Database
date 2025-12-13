-- =========================================================
-- Emergency Room Database (MySQL 8+)
-- Based on ER case study: workers (receptionists/nurses/doctors),
-- shifts, admissions, beds, supervision, medications, etc.
-- =========================================================


DROP DATABASE IF EXISTS Emergency_room;
create database Emergency_room;
use Emergency_room;
select database();

-- ---------- People + Contacts ----------

CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50)  NULL,
    LastName VARCHAR(50) NOT NULL
);
INSERT INTO Person VALUES
(1, 'Alice', 'Marie', 'Smith'),
(2, 'Bob', 'James', 'Brown'),
(3, 'Carol', 'J.', 'White'),
(4, 'David','Lee', 'Wong'),
(5, 'Eva', 'Andreew', 'Lee'),
(6, 'Frank', NULL, 'Green'),
(7, 'Grace', NULL, 'Kim');

CREATE TABLE Address (
    AddressID INT PRIMARY KEY,
    Country VARCHAR(50),
    Province VARCHAR(50),
    City VARCHAR(50),
    Street VARCHAR(100),
    StreetNumber VARCHAR(10)
);
INSERT INTO Address VALUES
(1, 'USA', 'SC', 'Greenville', 'Main St', '101'),
(2, 'USA', 'SC', 'Clemson', 'Elm St', '202'),
(3, 'USA', 'SC', 'Anderson', 'Pine St', '303'),
(4, 'USA', 'SC', 'Greenville', 'Oak St', '404'),
(5, 'USA', 'SC', 'Clemson', 'Maple Ave', '505'),
(6, 'USA', 'SC', 'Greenville', 'College St', '606'),
(7, 'USA', 'SC', 'Anderson', 'Willow Ln', '707'),
(8, 'USA', 'SC', 'Greenville', 'Birch St', '808'),
(9, 'USA', 'SC', 'Clemson', 'Chestnut Rd', '909'),
(10, 'USA', 'SC', 'Anderson', 'Cedar Dr', '1010');

-- A person can have 1+ addresses; an address can be shared if needed

CREATE TABLE PersonAddress (
    PersonID INT,
    AddressID INT,
    PRIMARY KEY (PersonID, AddressID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);
INSERT INTO PersonAddress VALUES
(1, 1), (2, 2), (3, 3), (4, 4),(5, 5), (6, 6), (7, 7);
INSERT INTO PersonAddress VALUES
(1, 8),  (2, 9),(4, 10);

CREATE TABLE Email (
    EmailID INT PRIMARY KEY,
    PersonID INT,
    EmailAddress VARCHAR(100),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

INSERT INTO Email VALUES
(1, 1, 'alice.smith@hospital.org'),
(2, 2, 'bob.brown@hospital.org'),
(3, 3, 'carol.white@hospital.org'),
(4, 4, 'david.wong@hospital.org'),
(5, 5, 'eva.lee@hospital.org'),
(6, 6, 'frank.green@hospital.org'),
(7, 7, 'grace.kim@hospital.org');
INSERT INTO Email VALUES
(8, 1, 'a.smith@altmail.com'),     
(9, 2, 'bob.b@workplace.org'),    
(10, 5, 'eva.lee@backupmail.com'); 

CREATE TABLE Phone (
    PhoneID INT PRIMARY KEY,
    PersonID INT,
    PhoneNumber VARCHAR(20),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);
INSERT INTO Phone VALUES
(1, 1, '123-456-1111'),
(2, 2, '123-456-2222'),
(3, 3, '123-456-3333'),
(4, 4, '123-456-4444'),
(5, 5, '123-456-5555'),
(6, 6, '123-456-6666'),
(7, 7, '123-456-7777');
INSERT INTO Phone VALUES
(8, 1, '321-654-1111'),  
(9, 3, '321-654-3333'),  
(10, 5, '321-654-5555'); 

-- ============ WORKERS ============

CREATE TABLE Worker (
    WorkerID INT PRIMARY KEY,
    PersonID INT,
    Role ENUM('Receptionist', 'Nurse', 'Doctor'),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);
INSERT INTO Worker VALUES
(101, 1, 'Nurse'),
(102, 2, 'Doctor'),
(103, 3, 'Receptionist'),
(104, 4, 'Nurse'),
(105, 5, 'Doctor'),
(106, 6, 'Receptionist'),
(107, 7, 'Doctor');

-- ============ PATIENTS ============

CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);
INSERT INTO Patient VALUES(201, 1),(202, 2),(203, 3),(204, 4),(205, 5),(206, 6),(207, 7);

-- ============ SHIFTS ============

CREATE TABLE Shift (
    ShiftID INT PRIMARY KEY,
    StartTime DATETIME,
    EndTime DATETIME,
    TriageDoctorID INT,
    FOREIGN KEY (TriageDoctorID) REFERENCES Worker(WorkerID)
);
INSERT INTO Shift VALUES
(301, '2025-12-01 08:00:00', '2025-12-01 16:00:00', 102),
(302, '2025-12-01 16:00:00', '2025-12-01 23:59:59', 105),
(303, '2025-12-02 08:00:00', '2025-12-02 16:00:00', 107),
(304, '2025-12-02 16:00:00', '2025-12-02 23:59:59', 102),
(305, '2025-12-03 08:00:00', '2025-12-03 16:00:00', 105),
(306, '2025-12-03 16:00:00', '2025-12-03 23:59:59', 107),
(307, '2025-12-04 08:00:00', '2025-12-04 16:00:00', 102);

CREATE TABLE WorkerShift (
    WorkerID INT,
    ShiftID INT,
    PRIMARY KEY (WorkerID, ShiftID),
    FOREIGN KEY (WorkerID) REFERENCES Worker(WorkerID),
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID)
);
INSERT INTO WorkerShift VALUES
(101, 301), (104, 302), (101, 303), (104, 304),
(101, 305), (104, 306), (101, 307),
(102, 301), (105, 302), (107, 303), (102, 304), (105, 305), (107, 306), (102, 307),
(103, 301), (106, 302), (103, 303), (106, 304), (103, 305), (106, 306), (103, 307);

-- ============ BED MANAGEMENT + Supervison ============

CREATE TABLE Bed (
    BedID INT PRIMARY KEY
);
INSERT INTO Bed VALUES
(401), (402), (403), (404), (405), (406), (407);

-- Each bed is supervised by a single nurse during a shift; nurse can supervise many beds

CREATE TABLE BedSupervision (
    BedID INT,
    ShiftID INT,
    NurseID INT,
    PRIMARY KEY (BedID, ShiftID),
    FOREIGN KEY (BedID) REFERENCES Bed(BedID),
    FOREIGN KEY (NurseID) REFERENCES Worker(WorkerID),
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID)
);

INSERT INTO BedSupervision VALUES
(401, 301, 101),
(402, 302, 104),
(403, 303, 101),
(404, 304, 104),
(405, 305, 101),
(406, 306, 104),
(407, 307, 101);

CREATE TABLE BedAssignment (
    BedID INT,
    PatientID INT,
    AssignedTime DATETIME,
    ReleasedTime DATETIME,
    PRIMARY KEY (BedID, PatientID, AssignedTime),
    FOREIGN KEY (BedID) REFERENCES Bed(BedID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

INSERT INTO BedAssignment VALUES
(401, 201, '2025-12-01 09:00:00', NULL),
(402, 202, '2025-12-01 17:00:00', NULL),
(403, 203, '2025-12-02 09:00:00', NULL),
(404, 204, '2025-12-02 17:00:00', NULL),
(405, 205, '2025-12-03 09:00:00', NULL),
(406, 206, '2025-12-03 17:00:00', NULL),
(407, 207, '2025-12-04 09:00:00', NULL);

UPDATE BedAssignment SET AssignedTime = '2023-05-15 08:30:00' WHERE BedID = 401 AND PatientID = 201;
UPDATE BedAssignment SET AssignedTime = '2024-02-10 14:45:00' WHERE BedID = 402 AND PatientID = 202;
UPDATE BedAssignment SET AssignedTime = '2025-01-21 11:20:00' WHERE BedID = 403 AND PatientID = 203;
UPDATE BedAssignment SET AssignedTime = '2024-11-03 18:10:00' WHERE BedID = 404 AND PatientID = 204;
UPDATE BedAssignment SET AssignedTime = '2023-08-27 07:00:00' WHERE BedID = 405 AND PatientID = 205;
UPDATE BedAssignment SET AssignedTime = '2024-03-12 13:30:00' WHERE BedID = 406 AND PatientID = 206;
UPDATE BedAssignment SET AssignedTime = '2023-12-19 20:05:00' WHERE BedID = 407 AND PatientID = 207;

-- ============ MEDICATION ============

CREATE TABLE Medication (
    MedicationID INT PRIMARY KEY,
    Name VARCHAR(100)
);
INSERT INTO Medication VALUES
(501, 'Paracetamol'),
(502, 'Amoxicillin'),
(503, 'Ibuprofen'),
(504, 'Aspirin'),
(505, 'Metformin'),
(506, 'Lisinopril'),
(507, 'Atorvastatin');

CREATE TABLE MedicationPrescription (
    PrescriptionID INT PRIMARY KEY,
    PatientID INT,
    MedicationID INT,
    DoctorID INT,
    Dosage VARCHAR(50),
    TimesPerDay INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (MedicationID) REFERENCES Medication(MedicationID),
    FOREIGN KEY (DoctorID) REFERENCES Worker(WorkerID)
);
INSERT INTO MedicationPrescription VALUES
(601, 201, 501, 102, '500mg', 3, '2025-12-01', '2025-12-03'),
(602, 202, 502, 105, '250mg', 2, '2025-12-01', '2025-12-04'),
(603, 203, 503, 107, '200mg', 1, '2025-12-02', '2025-12-03'),
(604, 204, 504, 102, '300mg', 1, '2025-12-02', '2025-12-04'),
(605, 205, 505, 105, '500mg', 2, '2025-12-03', '2025-12-05'),
(606, 206, 506, 107, '10mg', 1, '2025-12-03', '2025-12-06'),
(607, 207, 507, 102, '20mg', 1, '2025-12-04', '2025-12-07');

CREATE TABLE MedicationAdministration (
    PrescriptionID INT,
    ShiftID INT,
    NurseID INT,
    PRIMARY KEY (PrescriptionID, ShiftID),
    FOREIGN KEY (PrescriptionID) REFERENCES MedicationPrescription(PrescriptionID),
    FOREIGN KEY (NurseID) REFERENCES Worker(WorkerID),
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID)
);

INSERT INTO MedicationAdministration VALUES
(601, 301, 101),
(602, 302, 104),
(603, 303, 101),
(604, 304, 104),
(605, 305, 101),
(606, 306, 104),
(607, 307, 101);

-- ============ PATIENT ADMISSION  ============
CREATE TABLE PatientAdmission (
    AdmissionID INT PRIMARY KEY,
    PatientID INT,
    ShiftID INT,
    ReceptionistID INT,
    TriageDoctorID INT,
    AdmissionTime DATETIME,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID),
    FOREIGN KEY (ReceptionistID) REFERENCES Worker(WorkerID),
    FOREIGN KEY (TriageDoctorID) REFERENCES Worker(WorkerID)
);
INSERT INTO PatientAdmission VALUES
(701, 201, 301, 103, 102, '2025-12-01 08:30:00'),
(702, 202, 302, 106, 105, '2025-12-01 16:30:00'),
(703, 203, 303, 103, 107, '2025-12-02 08:45:00'),
(704, 204, 304, 106, 102, '2025-12-02 17:15:00'),
(705, 205, 305, 103, 105, '2025-12-03 09:10:00'),
(706, 206, 306, 106, 107, '2025-12-03 16:55:00'),
(707, 207, 307, 103, 102, '2025-12-04 08:05:00');

#      --------------------------------Complex Queries Examples--------------------------- 

# 1. List All Patients Currently Occupying Beds and Their Supervising Nurse
SELECT 
    p.PatientID,
    CONCAT(pers.FirstName, ' ', COALESCE(pers.MiddleName, ''), ' ', pers.LastName) AS PatientName,
    ba.BedID,
    bs.ShiftID,
    CONCAT(nurse.FirstName, ' ', COALESCE(nurse.MiddleName, ''), ' ', nurse.LastName) AS SupervisingNurse
FROM BedAssignment ba
JOIN Patient p ON ba.PatientID = p.PatientID
JOIN Person pers ON p.PersonID = pers.PersonID
JOIN BedSupervision bs ON ba.BedID = bs.BedID
    AND bs.ShiftID IN (
        SELECT ShiftID FROM WorkerShift WHERE WorkerID IN (
            SELECT WorkerID FROM Worker WHERE Role = 'Nurse'
        )
    )
JOIN Worker nw ON bs.NurseID = nw.WorkerID
JOIN Person nurse ON nw.PersonID = nurse.PersonID
WHERE ba.ReleasedTime IS NULL;

# 2. Get All Patients Who Were Admitted During a Specific Shift Along with Receptionist and Triage Doctor Names
SELECT 
    pa.PatientID,
    CONCAT(pp.FirstName, ' ', COALESCE(pp.MiddleName, ''), ' ', pp.LastName) AS PatientName,
    pa.ShiftID,
    CONCAT(rp.FirstName, ' ', COALESCE(rp.MiddleName, ''), ' ', rp.LastName) AS Receptionist,
    CONCAT(td.FirstName, ' ', COALESCE(td.MiddleName, ''), ' ', td.LastName) AS TriageDoctor
FROM PatientAdmission pa
JOIN Patient p ON pa.PatientID = p.PatientID
JOIN Person pp ON p.PersonID = pp.PersonID
JOIN Worker wr ON pa.ReceptionistID = wr.WorkerID
JOIN Person rp ON wr.PersonID = rp.PersonID
JOIN Worker wd ON pa.TriageDoctorID = wd.WorkerID
JOIN Person td ON wd.PersonID = td.PersonID
WHERE pa.ShiftID = 305;

# 3. List Shifts and the Number of Nurses, Doctors, and Receptionists Assigned
SELECT 
    s.ShiftID,
    s.StartTime,
    s.EndTime,
    SUM(CASE WHEN w.Role = 'Nurse' THEN 1 ELSE 0 END) AS NurseCount,
    SUM(CASE WHEN w.Role = 'Doctor' THEN 1 ELSE 0 END) AS DoctorCount,
    SUM(CASE WHEN w.Role = 'Receptionist' THEN 1 ELSE 0 END) AS ReceptionistCount
FROM Shift s
JOIN WorkerShift ws ON s.ShiftID = ws.ShiftID
JOIN Worker w ON ws.WorkerID = w.WorkerID
GROUP BY s.ShiftID, s.StartTime, s.EndTime;


#   ----------------------------------Stored Procedure Examples-----------------

# 1.Given a PatientID, this procedure returns all medications prescribed to the patient, who prescribed them, and dosage details.

DELIMITER //

CREATE PROCEDURE GetPatientMedications(IN patient_id INT)
BEGIN
    SELECT 
        CONCAT(pat.FirstName, ' ',
               COALESCE(pat.MiddleName, ''),
               ' ', pat.LastName) AS PatientName,
        m.Name AS Medication,
        mp.Dosage,
        mp.TimesPerDay,
        mp.StartDate,
        mp.EndDate,
        CONCAT(doc.FirstName, ' ',
               COALESCE(doc.MiddleName, ''),
               ' ', doc.LastName) AS PrescribedBy
    FROM MedicationPrescription mp
    JOIN Medication m ON mp.MedicationID = m.MedicationID
    JOIN Worker w ON mp.DoctorID = w.WorkerID
    JOIN Person doc ON w.PersonID = doc.PersonID
    JOIN Patient pa ON mp.PatientID = pa.PatientID
    JOIN Person pat ON pa.PersonID = pat.PersonID
    WHERE mp.PatientID = patient_id;
END;
//

DELIMITER ;
call GetPatientMedications(204);

-- 2. Given a PatientID, return the admission history of that patient, including: Admission time, Shift ID, Receptionist name, Triage doctor name

DELIMITER //

CREATE PROCEDURE GetPatientAdmissionHistory(IN p_patient_id INT)
BEGIN
    SELECT 
        pa.AdmissionID,
        pa.AdmissionTime,
        pa.ShiftID,
        CONCAT(rp.FirstName, ' ', COALESCE(rp.MiddleName, ''), ' ', rp.LastName) AS ReceptionistName,
        CONCAT(td.FirstName, ' ', COALESCE(td.MiddleName, ''), ' ', td.LastName) AS TriageDoctorName
    FROM PatientAdmission pa
    JOIN Worker wr ON pa.ReceptionistID = wr.WorkerID
    JOIN Person rp ON wr.PersonID = rp.PersonID
    JOIN Worker wd ON pa.TriageDoctorID = wd.WorkerID
    JOIN Person td ON wd.PersonID = td.PersonID
    WHERE pa.PatientID = p_patient_id
    ORDER BY pa.AdmissionTime DESC;
END;
//
DELIMITER ;
CALL GetPatientAdmissionHistory(202);


-- ---------------------------------------Function Examples---------------------------- 

/* 1. Given a PatientID and BedID, return the number of full days the patient stayed in the bed.
If the patient is still in the bed (ReleasedTime IS NULL), it calculates up to the current date.*/

DELIMITER //
CREATE FUNCTION GetBedOccupancyDays(p_patient_id INT, p_bed_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE assigned DATETIME DEFAULT NULL;
    DECLARE released DATETIME DEFAULT NULL;
    DECLARE days_stayed INT DEFAULT -1;

    -- Check if a matching record exists
    IF EXISTS (
        SELECT 1
        FROM BedAssignment
        WHERE PatientID = p_patient_id AND BedID = p_bed_id
    ) THEN
        -- Now fetch the values
        SELECT AssignedTime, ReleasedTime
        INTO assigned, released
        FROM BedAssignment
        WHERE PatientID = p_patient_id AND BedID = p_bed_id
        ORDER BY AssignedTime DESC
        LIMIT 1;

        -- Handle NULL release time
        IF released IS NULL THEN
            SET released = CURRENT_DATE;
        END IF;

        SET days_stayed = DATEDIFF(released, assigned);
    END IF;

    RETURN days_stayed;
END;
//

DELIMITER ;
SELECT GetBedOccupancyDays(206, 406);

-- 2. Given a PatientID, return the total number of different medications prescribed to that patient.
DELIMITER //

CREATE FUNCTION GetTotalMedicationsByPatient(p_patient_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE med_count INT;

    SELECT COUNT(DISTINCT MedicationID)
    INTO med_count
    FROM MedicationPrescription
    WHERE PatientID = p_patient_id;

    RETURN med_count;
END;
//
DELIMITER ;
SELECT GetTotalMedicationsByPatient(206);

--  --------------------------------------------Trigger (data integrity rules) Examples------------------

-- 1. Automatically insert a row into a MedicationLog table every time a new prescription is added to MedicationPrescription.
CREATE TABLE MedicationLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    MedicationID INT,
    PrescribedByDoctorID INT,
    PrescriptionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //
CREATE TRIGGER AfterPrescriptionInsert
AFTER INSERT ON MedicationPrescription
FOR EACH ROW
BEGIN
    INSERT INTO MedicationLog (PatientID, MedicationID, PrescribedByDoctorID)
    VALUES (NEW.PatientID, NEW.MedicationID, NEW.DoctorID);
END;
//
DELIMITER ;

INSERT INTO MedicationPrescription 
(PrescriptionID, PatientID, MedicationID, DoctorID, Dosage, TimesPerDay, StartDate, EndDate)
VALUES 
(702, 205, 503, 105, '250mg', 3, '2025-07-12', '2025-07-17');
select * from MedicationLog;

/* 2.LogShiftAssignment Whenever a new worker is assigned to a shift (i.e., inserted into the WorkerShift table), 
automatically log this assignment in a separate table ShiftAssignmentLog with: WorkerID,ShiftID,Timestamp of when they were added Their role (Doctor/Nurse/Receptionist)*/

CREATE TABLE ShiftAssignmentLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    WorkerID INT,
    ShiftID INT,
    Role ENUM('Doctor', 'Nurse', 'Receptionist'),
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER LogWorkerShiftAssignment
AFTER INSERT ON WorkerShift
FOR EACH ROW
BEGIN
    DECLARE worker_role ENUM('Doctor', 'Nurse', 'Receptionist');

    -- Get the role from the Worker table
    SELECT Role INTO worker_role
    FROM Worker
    WHERE WorkerID = NEW.WorkerID;

    -- Insert into ShiftAssignmentLog
    INSERT INTO ShiftAssignmentLog (WorkerID, ShiftID, Role)
    VALUES (NEW.WorkerID, NEW.ShiftID, worker_role);
END;
//
DELIMITER ;
-- Assign a worker to a shift
INSERT INTO WorkerShift VALUES (102, 305);
select * from WorkerShift;
-- Now check the log
SELECT * FROM ShiftAssignmentLog;
