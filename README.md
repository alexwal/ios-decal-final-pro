# Micro EMR
## Alex Walczak

## A simpler way to do EMR.
Micro EMR is a simplified electronic medical records software. It allows health practitioners to easily maintain records of patient visits.

## Features
* View all patients and patient records.
* Speech-to-text recording of patient info and condition.
* Ability to correct dictation.
* Functionality to capture a photo of patient and attach to that patient's profile.

## Control Flow
* The user is presented with a screen asking to either begin a new record or view patient records.
* Patient records will have a searchable view of patient profiles.
* When a patient profile is chosen, another view of a particular patient's records is displayed (sorted by timestamp).
* From the list of a particular patient's records, the user can edit a specific record.
* If beginning a new record, a new view will ask to write the patient's name.
* The patient will be checked against the database. 
* If the patient is new, the user will need to:
  * take the patient's picture
  * write patient's info
  * dictate patient's condition/diagnosis/medication
  * record timestamp
* Otherwise, the picture and patient info are skipped and the new record is appended to that patient's list of records.
* Finally, when finishing creating/editing a record, the user can save a current record or cancel.

## Implementation

### Model
* Patient.Swift
* Record.Swfit
* RecordDatabase.Swift
* PatientDatabase.Swift

### View:
* PatientView.swift
* RecordView.Swfit
* RecordDatabaseView.Swift
* PatientDatabaseView.Swift

### Controller:
* PatientViewController.swift
* RecordViewController.Swfit
* RecordDatabaseViewController.Swift
* PatientDatabaseViewController.Swift
