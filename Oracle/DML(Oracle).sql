INSERT INTO AppLanguage VALUES (1, 'Polish');
INSERT INTO AppLanguage VALUES (2, 'English');
INSERT INTO AppLanguage VALUES (3, 'German');

INSERT INTO Region VALUES (1, 'Europe');
INSERT INTO Region VALUES (2, 'America');
INSERT INTO Region VALUES (3, 'Asia');

INSERT INTO TeamPrivacy VALUES (1, 'Public');
INSERT INTO TeamPrivacy VALUES (2, 'Private');
INSERT INTO TeamPrivacy VALUES (3, 'Hidden');

INSERT INTO AppRole VALUES (1, 'Administrator', 1);
INSERT INTO AppRole VALUES (2, 'User', 0);
INSERT INTO AppRole VALUES (3, 'Guest', 0);

INSERT INTO AppUser VALUES (1, 'Anna', 'Nowak', 'anna@teams.com', '902480128', 'e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4', 1);
INSERT INTO AppUser VALUES (2, 'Jan', 'Kowalski', 'jan@teams.com', NULL, '7b52009b64fd0a2a49e6d8a939753077792b0554', 2);
INSERT INTO AppUser VALUES (3, 'Ewa', 'Zielińska', 'ewa@teams.com', '842991993', '315f5b53125a07c0828dbe45d2e7185038c98522', 1);
INSERT INTO AppUser VALUES (4, 'Piotr', 'Malinowski', 'piotr@teams.com', '611924112', '9c88737ccab0d0354162e245050f2832599283f6', 3);
INSERT INTO AppUser VALUES (5, 'Marta', 'Szulc', 'marta@teams.com', NULL, '4f03916960d7b275bf191f649bf7c7d42cf3bc21', 1);
INSERT INTO AppUser VALUES (6, 'Tomasz', 'Wójcik', 'tomasz@teams.com', '511042001', '79cb3a597b4c6e987178c5dce7f32997bb2153df', 2);
INSERT INTO AppUser VALUES (7, 'Kasia', 'Krawczyk', 'kasia@teams.com', '312152844', 'a2b6357492984b2372d8a4e69b0fa8ff1e5cfbc8', 1);

INSERT INTO Team VALUES (10, 'Team A', 1, 1);
INSERT INTO Team VALUES (20, 'Team B', 2, 2);
INSERT INTO Team VALUES (30, 'Team C', 3, 3);
INSERT INTO Team VALUES (40, 'Team D', 2, 1);

INSERT INTO UserTeam VALUES (1, 10, 1);
INSERT INTO UserTeam VALUES (2, 10, 2);
INSERT INTO UserTeam VALUES (3, 10, 3);
INSERT INTO UserTeam VALUES (4, 10, 2);
INSERT INTO UserTeam VALUES (5, 10, 2);
INSERT INTO UserTeam VALUES (4, 20, 1);
INSERT INTO UserTeam VALUES (5, 20, 1);
INSERT INTO UserTeam VALUES (1, 20, 1);
INSERT INTO UserTeam VALUES (6, 30, 2);
INSERT INTO UserTeam VALUES (3, 30, 3);
INSERT INTO UserTeam VALUES (7, 30, 3);
INSERT INTO UserTeam VALUES (5, 30, 3);
INSERT INTO UserTeam VALUES (2, 30, 3);
INSERT INTO UserTeam VALUES (4, 30, 3);
INSERT INTO UserTeam VALUES (2, 40, 1);
INSERT INTO UserTeam VALUES (5, 40, 2);
INSERT INTO UserTeam VALUES (6, 40, 2);
INSERT INTO UserTeam VALUES (1, 40, 2);

INSERT INTO TeamEvent VALUES (100, 'Report', 1, 10, TO_DATE('2025-05-23', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (101, 'Important Call', 0, 10, TO_DATE('2025-05-24', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (102, 'New Post', 1, 20, TO_DATE('2025-05-24', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (103, 'Product Presentation', 1, 20, TO_DATE('2025-05-25', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (104, 'Team Integration', 0, 30, TO_DATE('2025-05-26', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (105, 'Recruitment', 1, 40, TO_DATE('2025-05-27', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (106, 'Team Atmosphere', 1, 30, TO_DATE('2025-05-28', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (107, 'Information Meeting', 0, 10, TO_DATE('2025-05-29', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (108, 'Employee Information', 1, 40, TO_DATE('2025-05-30', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (109, 'Project Meeting', 1, 20, TO_DATE('2025-06-01', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (201, 'Java Backend Project', 1, 30, TO_DATE('2025-05-01', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (202, 'API Documentation', 1, 30, TO_DATE('2025-05-02', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (203, 'Archive Cleanup', 0, 10, TO_DATE('2025-05-01', 'YYYY-MM-DD'));
INSERT INTO TeamEvent VALUES (204, 'Risk Management', 1, 20, TO_DATE('2025-05-01', 'YYYY-MM-DD'));

INSERT INTO Task VALUES (100, TO_DATE('2025-05-30','YYYY-MM-DD'), 'Completed', 'Good job', 'Create team progress report');
INSERT INTO Task VALUES (103, TO_DATE('2025-06-01','YYYY-MM-DD'), 'Completed', NULL, 'Prepare slides for presentation');
INSERT INTO Task VALUES (105, TO_DATE('2025-06-05','YYYY-MM-DD'), 'In Progress', NULL, 'Organize recruitment meetings');
INSERT INTO Task VALUES (201, TO_DATE('2025-05-10','YYYY-MM-DD'), 'Completed', 'Exemplary execution', 'Backend coding');
INSERT INTO Task VALUES (202, TO_DATE('2025-05-12','YYYY-MM-DD'), 'Completed', 'No errors', 'Write Swagger documentation');
INSERT INTO Task VALUES (203, TO_DATE('2025-05-05','YYYY-MM-DD'), 'Completed', 'Inaccurate', 'Organize files');
INSERT INTO Task VALUES (204, TO_DATE('2025-05-15','YYYY-MM-DD'), 'Completed', 'Below expectations', 'Risk analysis');

INSERT INTO VoiceMeeting VALUES (
    101,
    TO_DATE('2025-05-24 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2025-05-24 09:30:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO VoiceMeeting VALUES (
    107,
    TO_DATE('2025-05-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2025-05-29 10:45:00', 'YYYY-MM-DD HH24:MI:SS')
);
INSERT INTO VoiceMeeting VALUES (
    109,
    TO_DATE('2025-06-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2025-06-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS')
);

INSERT INTO Post VALUES (102, 'Welcome to the team!', 'We are glad you joined us!');
INSERT INTO Post VALUES (104, 'Integration party', 'Integration meeting will take place on May 26 at 17:00, we count on your presence');
INSERT INTO Post VALUES (106, 'Great atmosphere', 'Thank you for the high employee culture in our corporate teams - great job!');
INSERT INTO Post VALUES (108, 'New leave rules', 'Please read the new leave regulations attached in the message');

INSERT INTO UserRating VALUES (6, 201, 5);
INSERT INTO UserRating VALUES (6, 202, 5);
INSERT INTO UserRating VALUES (6, 105, 4);
INSERT INTO UserRating VALUES (2, 203, 1);
INSERT INTO UserRating VALUES (1, 103, 3);
INSERT INTO UserRating VALUES (1, 105, 3);
INSERT INTO UserRating VALUES (1, 204, 2);
INSERT INTO UserRating VALUES (3, 100, 5);
INSERT INTO UserRating VALUES (4, 100, 4);
INSERT INTO UserRating VALUES (5, 100, 5);
INSERT INTO UserRating VALUES (4, 103, 4);
INSERT INTO UserRating VALUES (5, 103, 5);
INSERT INTO UserRating VALUES (5, 105, 4);

COMMIT;