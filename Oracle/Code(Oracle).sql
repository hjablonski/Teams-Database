CREATE OR REPLACE PROCEDURE AddEvent (p_Name VARCHAR2, p_TeamID INTEGER, p_PublishDate DATE, p_DueDate DATE, p_Description VARCHAR2) AS
    v_TeamCount INTEGER;
    v_TaskCount INTEGER;
    v_DuplicateCount INTEGER;
    v_NewID INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_TeamCount FROM Team WHERE ID = p_TeamID;

    IF v_TeamCount = 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'Cannot add task to a non-existent team!');
    END IF;

    IF p_DueDate < p_PublishDate THEN
        RAISE_APPLICATION_ERROR(-20502, 'Task due date cannot be earlier than the start date!');
    END IF;

    SELECT COUNT(*) INTO v_DuplicateCount
    FROM TeamEvent
    WHERE TeamID = p_TeamID AND Name = p_Name;

    IF v_DuplicateCount > 0 THEN
        RAISE_APPLICATION_ERROR(-20503, 'An event with this name already exists in this team!');
    END IF;

    SELECT COUNT(*) INTO v_TaskCount
    FROM TeamEvent e
    JOIN Task t ON e.ID = t.TeamEventID
    WHERE e.TeamID = p_TeamID AND t.Status != 'Completed';

    IF v_TaskCount > 10 THEN
        RAISE_APPLICATION_ERROR(-20504, 'Team is overloaded! Cannot add more than 10 active tasks.');
    END IF;

    v_NewID := TeamEventSequence.NEXTVAL;

    INSERT INTO TeamEvent (ID, Name, ShouldNotify, TeamID, PublishDate)
    VALUES (v_NewID, p_Name, 1, p_TeamID, p_PublishDate);

    INSERT INTO Task (TeamEventID, DueDate, Status, Description)
    VALUES (v_NewID, p_DueDate, 'New', p_Description);
END;
/

CREATE OR REPLACE PROCEDURE ManageTeamStaff (p_TeamID INTEGER) AS
    /* 
     * ARCHITECTURE NOTE:
     * The cursor is used below for demonstration purposes (academic project requirement).
     * In a commercial production environment, to maintain optimal performance, 
     * this logic would be refactored into set-based operations, 
     * using bulk UPDATE and DELETE statements with subqueries.
     */
    CURSOR staff_cursor IS SELECT UserID, AppRoleID FROM UserTeam WHERE TeamID = p_TeamID;
    v_UserID UserTeam.UserID%TYPE;
    v_CurrentRole UserTeam.AppRoleID%TYPE;
    v_AverageRating NUMBER(3,1);
    v_RatingCount INTEGER;
BEGIN
    OPEN staff_cursor;
    LOOP
        FETCH staff_cursor INTO v_UserID, v_CurrentRole;
        EXIT WHEN staff_cursor%NOTFOUND;

        SELECT NVL(AVG(Rating), 0), COUNT(*)
        INTO v_AverageRating, v_RatingCount
        FROM UserRating
        WHERE UserID = v_UserID;

        IF v_RatingCount > 0 THEN
            IF v_AverageRating > 4.5 AND v_CurrentRole != 1 THEN
                UPDATE UserTeam
                SET AppRoleID = 1
                WHERE UserID = v_UserID AND TeamID = p_TeamID;
                DBMS_OUTPUT.PUT_LINE('Employee ' || v_UserID || ' has been promoted to Administrator!');

            ELSIF v_AverageRating < 2.0 THEN
                DELETE FROM UserTeam
                WHERE UserID = v_UserID AND TeamID = p_TeamID;
                DBMS_OUTPUT.PUT_LINE('Employee ' || v_UserID || ' has been removed from the team due to low performance.');

            ELSIF v_AverageRating < 3.0 AND v_CurrentRole = 1 THEN
                UPDATE UserTeam
                SET AppRoleID = 2
                WHERE UserID = v_UserID AND TeamID = p_TeamID;
                DBMS_OUTPUT.PUT_LINE('Administrator ' || v_UserID || ' has been demoted to User.');

            END IF;
        END IF;
    END LOOP;
    CLOSE staff_cursor;
END;
/

CREATE OR REPLACE TRIGGER MembershipValidation
BEFORE INSERT OR UPDATE ON UserTeam
FOR EACH ROW
DECLARE
    v_TeamCount INTEGER;
    v_TeamPrivacy INTEGER;
    v_Email AppUser.Email%TYPE;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO v_TeamCount
        FROM UserTeam
        WHERE UserID = :NEW.UserID;

        IF v_TeamCount >= 5 THEN
            RAISE_APPLICATION_ERROR(-20510, 'User already belongs to 5 teams. Limit reached.');
        END IF;
    END IF;

    IF :NEW.AppRoleID = 1 THEN
        SELECT TeamPrivacyID INTO v_TeamPrivacy
        FROM Team
        WHERE ID = :NEW.TeamID;

        IF v_TeamPrivacy = 3 THEN
            RAISE_APPLICATION_ERROR(-20511, 'Cannot appoint an Administrator in a hidden team.');
        END IF;
    END IF;

    IF :NEW.AppRoleID = 1 THEN
        SELECT Email INTO v_Email
        FROM AppUser
        WHERE ID = :NEW.UserID;

        IF v_Email NOT LIKE '%@teams.com' THEN
            RAISE_APPLICATION_ERROR(-20512, 'Only employees with the @teams.com domain can be Administrators.');
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TaskDataProtection
BEFORE DELETE OR UPDATE ON Task
FOR EACH ROW
DECLARE
    v_RatingCount INTEGER;
    v_PublishDate TeamEvent.PublishDate%TYPE;
BEGIN
    IF UPDATING THEN
        SELECT PublishDate INTO v_PublishDate
        FROM TeamEvent
        WHERE ID = :NEW.TeamEventID;

        IF :NEW.DueDate < v_PublishDate THEN
            RAISE_APPLICATION_ERROR(-20520, 'Due date cannot be earlier than the task publish date!');
        END IF;

        IF :OLD.Status = 'Completed' AND :NEW.Status != 'Completed' THEN
            RAISE_APPLICATION_ERROR(-20521, 'Cannot resume a task that has already been completed.');
        END IF;
    END IF;

    IF DELETING THEN
        SELECT COUNT(*) INTO v_RatingCount
        FROM UserRating
        WHERE TaskID = :OLD.TeamEventID;

        IF v_RatingCount > 0 THEN
            RAISE_APPLICATION_ERROR(-20522, 'Cannot delete a task that already has ratings.');
        END IF;
    END IF;
END;