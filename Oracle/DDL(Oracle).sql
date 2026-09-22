BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE UserRating CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE UserTeam CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Task CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE VoiceMeeting CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Post CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE TeamEvent CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE AppUser CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Team CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE AppRole CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE AppLanguage CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE TeamPrivacy CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE Region CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE AppLanguage (
    ID integer NOT NULL,
    Name varchar2(20) NOT NULL,
    CONSTRAINT AppLanguage_pk PRIMARY KEY (ID)
);

CREATE TABLE TeamPrivacy (
    ID integer NOT NULL,
    PrivacyLevel varchar2(20) NOT NULL,
    CONSTRAINT TeamPrivacy_pk PRIMARY KEY (ID)
);

CREATE TABLE Region (
    ID integer NOT NULL,
    Name varchar2(20) NOT NULL,
    CONSTRAINT Region_pk PRIMARY KEY (ID)
);

CREATE TABLE AppRole (
    ID integer NOT NULL,
    Name varchar2(20) NOT NULL,
    IsAdmin smallint NOT NULL,
    CONSTRAINT AppRole_pk PRIMARY KEY (ID)
);

CREATE TABLE VoiceMeeting (
    TeamEventID integer NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    CONSTRAINT VoiceMeeting_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE AppUser (
    ID integer NOT NULL,
    FirstName varchar2(20) NOT NULL,
    LastName varchar2(20) NOT NULL,
    Email varchar2(254) NOT NULL,
    PhoneNumber varchar2(15) NULL,
    PasswordHash varchar2(256) NOT NULL,
    AppLanguageID integer NOT NULL,
    CONSTRAINT AppUser_pk PRIMARY KEY (ID)
);

CREATE TABLE UserTeam (
    UserID integer NOT NULL,
    TeamID integer NOT NULL,
    AppRoleID integer NOT NULL,
    CONSTRAINT UserTeam_pk PRIMARY KEY (UserID, TeamID)
);

CREATE TABLE UserRating (
    UserID integer NOT NULL,
    TaskID integer NOT NULL,
    Rating integer NOT NULL,
    CONSTRAINT UserRating_pk PRIMARY KEY (UserID, TaskID)
);

CREATE TABLE Post (
    TeamEventID integer NOT NULL,
    Title varchar2(50) NOT NULL,
    Description varchar2(500) NOT NULL,
    CONSTRAINT Post_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE TeamEvent (
    ID integer NOT NULL,
    Name varchar2(50) NOT NULL,
    ShouldNotify smallint NOT NULL,
    TeamID integer NOT NULL,
    PublishDate date NOT NULL,
    CONSTRAINT TeamEvent_pk PRIMARY KEY (ID)
);

CREATE TABLE Task (
    TeamEventID integer NOT NULL,
    DueDate date NOT NULL,
    Status varchar2(20) NOT NULL,
    Feedback varchar2(500) NULL,
    Description varchar2(500) NULL,
    CONSTRAINT Task_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE Team (
    ID integer NOT NULL,
    Name varchar2(20) NOT NULL,
    RegionID integer NOT NULL,
    TeamPrivacyID integer NOT NULL,
    CONSTRAINT Team_pk PRIMARY KEY (ID)
);

ALTER TABLE VoiceMeeting ADD CONSTRAINT VoiceMeeting_TeamEvent FOREIGN KEY (TeamEventID) REFERENCES TeamEvent (ID);
ALTER TABLE AppUser ADD CONSTRAINT AppUser_AppLanguage FOREIGN KEY (AppLanguageID) REFERENCES AppLanguage (ID);
ALTER TABLE UserTeam ADD CONSTRAINT UserTeam_AppRole FOREIGN KEY (AppRoleID) REFERENCES AppRole (ID);
ALTER TABLE UserTeam ADD CONSTRAINT UserTeam_AppUser FOREIGN KEY (UserID) REFERENCES AppUser (ID);
ALTER TABLE UserTeam ADD CONSTRAINT UserTeam_Team FOREIGN KEY (TeamID) REFERENCES Team (ID);
ALTER TABLE UserRating ADD CONSTRAINT UserRating_AppUser FOREIGN KEY (UserID) REFERENCES AppUser (ID);
ALTER TABLE UserRating ADD CONSTRAINT UserRating_Task FOREIGN KEY (TaskID) REFERENCES Task (TeamEventID);
ALTER TABLE Post ADD CONSTRAINT Post_TeamEvent FOREIGN KEY (TeamEventID) REFERENCES TeamEvent (ID);
ALTER TABLE TeamEvent ADD CONSTRAINT TeamEvent_Team FOREIGN KEY (TeamID) REFERENCES Team (ID);
ALTER TABLE Task ADD CONSTRAINT Task_TeamEvent FOREIGN KEY (TeamEventID) REFERENCES TeamEvent (ID);
ALTER TABLE Team ADD CONSTRAINT Team_TeamPrivacy FOREIGN KEY (TeamPrivacyID) REFERENCES TeamPrivacy (ID);
ALTER TABLE Team ADD CONSTRAINT Team_Region FOREIGN KEY (RegionID) REFERENCES Region (ID);

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE TeamEventSequence';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
CREATE SEQUENCE TeamEventSequence START WITH 300 INCREMENT BY 1;
/