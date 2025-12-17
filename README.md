# Emergency Room Database System – MySQL

This project implements a relational database system for managing operations in an Emergency Room (ER).
It was developed as part of a database course project, with a focus on **entity-relationship modeling,
data integrity, and advanced SQL logic**, without a frontend.

## Problem Description
The Emergency Room system models patients and healthcare workers (receptionists, nurses, and doctors),
their shifts, patient admissions, treatments, medications, and bed supervision.

The design captures real-world ER workflows such as triage, shift assignments, patient care,
and medication administration.

## Key Entities
- Person (patients and workers)
- Addresses, Emails, Phone Numbers
- Workers (Receptionists, Nurses, Doctors)
- Shifts
- Patients
- Beds
- Medications
- Prescriptions
- Assignments (patients to doctors, nurses, beds)

## Database Features
- Fully normalized relational schema
- Support for multiple roles per person
- Shift-based assignment of staff
- Triage doctor identification per shift
- Bed supervision by nurses
- Medication prescription and administration tracking
- Referential integrity using primary and foreign keys

## Files
- `EmergencyRoom.sql`  
  Complete MySQL implementation including tables, constraints, and relationships.

## How to Run
```sql
CREATE DATABASE Emergency_room;
USE Emergency_room;
SOURCE EmergencyRoom.sql;
