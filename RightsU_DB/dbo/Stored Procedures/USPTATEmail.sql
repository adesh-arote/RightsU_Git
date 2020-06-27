--Create TABLE TATEmailLog
--(
--	TATEmailLogCode INT,
--	TATCode INT,
--	LevelNo INT,
--	UserCode INT,
--	MailID NVARCHAR(500),
--	StatusCode INT,
--	SentOn Datetime,
--	MailBody NVARCHAR(MAX)
--)
CREATE PROCEDURE USPTATEmail
AS
BEGIN
	DECLARE @TATCode INT, @StatusCode INT, @TATSLACode INT, @DatabaseEmail_Profile NVARCHAR(100), @Users_Email_Id NVARCHAR(MAX), @MailSubjectCr NVARCHAR(100), 
	@EmailUser_Body NVARCHAR(MAX), @UserCode INT, @FromDay INT, @TATSLAMatrixCode INT, @ToDay INT, @UpdatedOn DATETIME

	SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
	Update TATSLAStatus SET IsActive='Y'
	DECLARE db_cursor CURSOR FOR 
	SELECT DISTINCT TATCode, TATSLAStatusCode, TATSLACode from TAT Where TATSLAStatusCode IN(SELECT TATSLAStatusCode FROM TATSLAStatus WHERE IsSLAEmail = 'Y')
	
	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @TATCode, @StatusCode, @TATSLACode
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @LevelNoInr INT, @UserCodeInr INT, @MailIDInr NVARCHAR(MAX), @StatusCodeInr INT, @SentOnInr DATETIME
		SELECT TOP 1 @LevelNoInr = LevelNo, @UserCodeInr = UserCode, @MailIDInr = MailID, @StatusCodeInr = StatusCode, @SentOnInr = SentOn from TATEmailLog
		Where TATCode = @TATCode Order BY TATCode desc
		SET @StatusCodeInr = ISNULL(@StatusCodeInr, 2)
		SET @LevelNoInr = ISNULL(@LevelNoInr, 0)
		
		IF (@StatusCodeInr != @StatusCode)
		BEGIN
			SET @LevelNoInr = 0
		END

		IF (@StatusCodeInr = @StatusCode)
		BEGIN
			if(@LevelNoInr<3)
			SET @LevelNoInr = @LevelNoInr+1

			SELECT TOP 1 @FromDay = FromDay, @ToDay = ToDay, @TATSLAMatrixCode = TATSLAMatrixCode FROM TATSLAMatrix WHERE LevelNo = @LevelNoInr and TATSLAStatusCode = @StatusCode
			
			SELECT TOP 1 @UpdatedOn = StatusChangedOn from TATStatusLog Where TATCode = @TATCode AND TATSLAStatusCode = @StatusCode ORDER BY TATStatusLogCode DESC
			
			IF(DATEDIFF(DAY,@UpdatedOn,GETDATE()) BETWEEN @FromDay AND @ToDay)
			BEGIN
				DECLARE db_Inncursor CURSOR FOR
				SELECT DISTINCT Email_Id, Users_Code FROM Users WHERE Users_Code IN(SELECT UserCode FROM TATSLAMatrixDetails TMD
				INNER JOIN TATSLAMatrix TSM ON TSM.TATSLAMatrixCode = TMD.TATSLAMatrixCode AND TSM.LevelNo = @LevelNoInr  WHERE TSM.TATSLAMatrixCode = @TATSLAMatrixCode)
				OPEN db_Inncursor
				FETCH NEXT FROM db_Inncursor INTO @Users_Email_Id, @UserCode
				WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					IF (@@FETCH_STATUS <> -2)
					INSERT INTO TATEmailLog(TATCode, LevelNo, UserCode,	MailID,	StatusCode,	SentOn,	MailBody)
					SELECT @TATCode, @LevelNoInr, M.UserCode, U.Email_Id, @StatusCode, GETDATE(), '' FROM TATSLAMatrixDetails M
					INNER JOIN Users U ON U.Users_Code = M.UserCode
					WHERE TATSLAMatrixCode = @TATSLAMatrixCode

					--EXEC msdb.dbo.sp_send_dbmail
					--@profile_name = @DatabaseEmail_Profile,
					--@recipients =  @Users_Email_Id,
					--@subject = @MailSubjectCr,
					--@body = @EmailUser_Body,
					--@body_format = 'HTML';

					FETCH NEXT FROM db_Inncursor INTO @Users_Email_Id, @UserCode
				END
				CLOSE db_Inncursor
				DEALLOCATE db_Inncursor
			END
		END
		FETCH NEXT FROM db_cursor INTO @TATCode, @StatusCode, @TATSLACode
	END
	CLOSE db_cursor
	DEALLOCATE db_cursor
END

--INSERT INTO TATSLAStatus(TATSLAStatusName,IsActive)
--select 'Deal Approved','S'
--select * from TAT
--select * from TATSLAMatrix
--Truncate Table TATEmailLog
--select * from TATEmailLog
----DROP TABLE TATEmailLog
--SP_Help TATEmailLog
--ALTER TABLE TATEmailLog
--Add TATEmailLog INT Primary Key IDENTITY(1,1)

--CREATE TABLE TATEmailLog(
--TATEmailLogCode	int Primary Key IDENTITY(1,1)
--,TATCode	int
--,LevelNo	int
--,UserCode	int
--,MailID	nvarchar(50)
--,StatusCode	int
--,SentOn	datetime
--,MailBody	nvarchar(MAX))