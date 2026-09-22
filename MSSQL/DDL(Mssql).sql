DROP TABLE IF EXISTS UserRating;
DROP TABLE IF EXISTS UserTeam;
DROP TABLE IF EXISTS VoiceMeeting;
DROP TABLE IF EXISTS Task;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS TeamEvent;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS AppUser;
DROP TABLE IF EXISTS AppRole;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS TeamPrivacy;
DROP TABLE IF EXISTS AppLanguage;

CREATE TABLE AppLanguage (
    ID integer NOT NULL,
    Name varchar(20) NOT NULL,
    CONSTRAINT AppLanguage_pk PRIMARY KEY (ID)
);

CREATE TABLE TeamPrivacy (
    ID integer NOT NULL,
    PrivacyLevel varchar(20) NOT NULL,
    CONSTRAINT TeamPrivacy_pk PRIMARY KEY (ID)
);

CREATE TABLE Region (
    ID integer NOT NULL,
    Name varchar(20) NOT NULL,
    CONSTRAINT Region_pk PRIMARY KEY (ID)
);

CREATE TABLE AppRole (
    ID integer NOT NULL,
    Name varchar(20) NOT NULL,
    IsAdmin smallint NOT NULL,
    CONSTRAINT AppRole_pk PRIMARY KEY (ID)
);

CREATE TABLE AppUser (
    ID integer NOT NULL,
    FirstName varchar(20) NOT NULL,
    LastName varchar(20) NOT NULL,
    Email varchar(254) NOT NULL,
    PhoneNumber varchar(15) NULL,
    PasswordHash varchar(256) NOT NULL,
    AppLanguageID integer NOT NULL,
    CONSTRAINT AppUser_pk PRIMARY KEY (ID)
);

CREATE TABLE Team (
    ID integer NOT NULL,
    Name varchar(20) NOT NULL,
    RegionID integer NOT NULL,
    TeamPrivacyID integer NOT NULL,
    CONSTRAINT Team_pk PRIMARY KEY (ID)
);

CREATE TABLE UserTeam (
    UserID integer NOT NULL,
    TeamID integer NOT NULL,
    AppRoleID integer NOT NULL,
    CONSTRAINT UserTeam_pk PRIMARY KEY (UserID, TeamID)
);

CREATE TABLE TeamEvent (
    ID integer NOT NULL,
    Name varchar(50) NOT NULL,
    ShouldNotify smallint NOT NULL,
    TeamID integer NOT NULL,
    PublishDate date NOT NULL,
    CONSTRAINT TeamEvent_pk PRIMARY KEY (ID)
);

CREATE TABLE VoiceMeeting (
    TeamEventID integer NOT NULL,
    StartDate datetime NOT NULL,
    EndDate datetime NOT NULL,
    CONSTRAINT VoiceMeeting_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE Task (
    TeamEventID integer NOT NULL,
    DueDate date NOT NULL,
    Status varchar(20) NOT NULL,
    Feedback varchar(500) NULL,
    Description varchar(500) NULL,
    CONSTRAINT Task_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE Post (
    TeamEventID integer NOT NULL,
    Title varchar(50) NOT NULL,
    Description varchar(500) NOT NULL,
    CONSTRAINT Post_pk PRIMARY KEY (TeamEventID)
);

CREATE TABLE UserRating (
    UserID integer NOT NULL,
    TaskID integer NOT NULL,
    Rating integer NOT NULL,
    CONSTRAINT UserRating_pk PRIMARY KEY (UserID, TaskID)
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

CREATE SEQUENCE TeamEventSequence START WITH 300 INCREMENT BY 1;
GO