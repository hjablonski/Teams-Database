CREATE OR ALTER PROCEDURE AddEvent (@p_Name VARCHAR(50), @p_TeamID INT, @p_PublishDate DATE, @p_DueDate DATE, @p_Description VARCHAR(500)) AS
BEGIN
    DECLARE @v_TeamCount INT;
    DECLARE @v_TaskCount INT;
    DECLARE @v_DuplicateCount INT;
    DECLARE @v_NewID INT;

    SELECT @v_TeamCount = COUNT(*) FROM Team WHERE ID = @p_TeamID;

    IF @v_TeamCount = 0
    BEGIN
        RAISERROR ('Cannot add task to a non-existent team!', 16, 1);
    END

    IF @p_DueDate < @p_PublishDate
    BEGIN
        RAISERROR ('Task due date cannot be earlier than the start date!', 16, 1);
    END

    SELECT @v_DuplicateCount = COUNT(*)
    FROM TeamEvent
    WHERE TeamID = @p_TeamID AND Name = @p_Name;

    IF @v_DuplicateCount > 0
    BEGIN
        RAISERROR ('An event with this name already exists in this team!', 16, 1);
    END

    SELECT @v_TaskCount = COUNT(*)
    FROM TeamEvent e
    JOIN Task t ON e.ID = t.TeamEventID
    WHERE e.TeamID = @p_TeamID AND t.Status != 'Completed';

    IF @v_TaskCount > 10
    BEGIN
        RAISERROR ('Team is overloaded! Cannot add more than 10 active tasks.', 16, 1);
    END

    SET @v_NewID = NEXT VALUE FOR TeamEventSequence;

    INSERT INTO TeamEvent (ID, Name, ShouldNotify, TeamID, PublishDate)
    VALUES (@v_NewID, @p_Name, 1, @p_TeamID, @p_PublishDate);

    INSERT INTO Task (TeamEventID, DueDate, Status, Description)
    VALUES (@v_NewID, @p_DueDate, 'New', @p_Description);
    
    PRINT 'Added task with ID: ' + CAST(@v_NewID AS VARCHAR);
END;
GO

CREATE OR ALTER PROCEDURE ManageTeamStaff (@p_TeamID INT) AS
BEGIN
    DECLARE @v_UserID INT;
    DECLARE @v_CurrentRole INT;
    DECLARE @v_AverageRating DECIMAL(4,2);
    DECLARE @v_RatingCount INT;

    /* 
     * ARCHITECTURE NOTE:
     * The cursor is used below for demonstration purposes (academic project requirement).
     * In a commercial production environment, to maintain optimal performance, 
     * this logic would be refactored into set-based operations, 
     * using bulk UPDATE and DELETE statements with subqueries.
     */
    DECLARE staff_cursor CURSOR FOR 
    SELECT UserID, AppRoleID 
    FROM UserTeam 
    WHERE TeamID = @p_TeamID;

    OPEN staff_cursor;
    FETCH NEXT FROM staff_cursor INTO @v_UserID, @v_CurrentRole;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT 
            @v_AverageRating = ISNULL(AVG(CAST(Rating AS DECIMAL(4,2))), 0), 
            @v_RatingCount = COUNT(*)
        FROM UserRating
        WHERE UserID = @v_UserID;

        IF @v_RatingCount > 0
        BEGIN
            IF @v_AverageRating > 4.5 AND @v_CurrentRole != 1
            BEGIN
                UPDATE UserTeam
                SET AppRoleID = 1
                WHERE UserID = @v_UserID AND TeamID = @p_TeamID;
                PRINT 'Employee ' + CAST(@v_UserID AS VARCHAR) + ' has been promoted to Administrator!';
            END
            ELSE IF @v_AverageRating < 2.0
            BEGIN
                DELETE FROM UserTeam
                WHERE UserID = @v_UserID AND TeamID = @p_TeamID;
                PRINT 'Employee ' + CAST(@v_UserID AS VARCHAR) + ' has been removed from the team due to low performance.';
            END
            ELSE IF @v_AverageRating < 3.0 AND @v_CurrentRole = 1
            BEGIN
                UPDATE UserTeam
                SET AppRoleID = 2
                WHERE UserID = @v_UserID AND TeamID = @p_TeamID;
                PRINT 'Administrator ' + CAST(@v_UserID AS VARCHAR) + ' has been demoted to User.';
            END
        END
        FETCH NEXT FROM staff_cursor INTO @v_UserID, @v_CurrentRole;
    END

    CLOSE staff_cursor;
    DEALLOCATE staff_cursor;
END;
GO

CREATE OR ALTER TRIGGER MembershipValidation
ON UserTeam
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT i.UserID 
        FROM inserted i
        JOIN UserTeam ut ON i.UserID = ut.UserID
        GROUP BY i.UserID
        HAVING COUNT(*) > 5
    )
    BEGIN
        RAISERROR ('User already belongs to 5 teams. Limit reached.', 16, 1);
        ROLLBACK;
    END

    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Team t ON i.TeamID = t.ID
        WHERE i.AppRoleID = 1 AND t.TeamPrivacyID = 3
    )
    BEGIN
        RAISERROR ('Cannot appoint an Administrator in a hidden team.', 16, 1);
        ROLLBACK;
    END

    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN AppUser u ON i.UserID = u.ID
        WHERE i.AppRoleID = 1 AND u.Email NOT LIKE '%@teams.com'
    )
    BEGIN
        RAISERROR ('Only employees with the @teams.com domain can be Administrators.', 16, 1);
        ROLLBACK;
    END
END;
GO

CREATE OR ALTER TRIGGER TaskDataProtection
ON Task
AFTER UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            JOIN TeamEvent e ON i.TeamEventID = e.ID
            WHERE i.DueDate < e.PublishDate
        )
        BEGIN
            RAISERROR ('Due date cannot be earlier than the task publish date!', 16, 1);
            ROLLBACK;
        END

        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.TeamEventID = d.TeamEventID
            WHERE d.Status = 'Completed' AND i.Status != 'Completed'
        )
        BEGIN
            RAISERROR ('Cannot resume a task that has already been completed.', 16, 1);
            ROLLBACK;
        END
    END

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        IF EXISTS (
            SELECT 1 
            FROM deleted d
            JOIN UserRating ur ON d.TeamEventID = ur.TaskID
        )
        BEGIN
            RAISERROR ('Cannot delete a task that already has ratings.', 16, 1);
            ROLLBACK;
        END
    END
END;
GO