CREATE PROCEDURE USP_Lock_Refresh_Release_Record
(
	@Record_Code INT = 0,
	@Module_Code INT = 0,
	@User_Code INT = 0,
	@IP_Address VARCHAR(20) = '',
	@Record_Locking_Code INT OUT,
	@Message NVARCHAR(500) OUT,
	@Action VARCHAR(20) = ''
)
AS
/*=======================================================================================================================================
Author:			Abhaysingh N. Rajpurohit
Create date:	05 Jan 2017
Description:	This stored procedure will be using for record locking. We are handling three actions in this stored procedure.
				and we are storing user_code and IP-Address so we can track who is accessing this record.

01) LOCK :	Please check and lock record.
			REQUIRED INPUT : 
				@Record_Code : Code of record which you want to lock.
				@Module_Code : Code of module whose record you want to lock
				@User_Code	 : Code of currenty logged-In user and accessing this record.
				@IP_Address  : IP adress of user's machin,

			OUTPUT :
				@Record_Locking_Code :
				We will assign Record_Locking_Code for current record in this variable. If other user is working on current record, 
				so we will assign 0 to this variable, else Record_Locking_Code of current record. 

				@Message:
				In this variable we will assign proper message, if other user had locked and accessing particulare record otherwise this will be blank.

			CONCLUSION: 
				When you call this stored procedure, you can check value of @Record_Locking_Code variable, if value is greater then 0, it means record 
				has beed lock, else other user has locked current record and accessing, so you can display value of @Message varible to current user. 

02) REFRESH :	Refresh Release time.
				Required Input :
					@Record_Locking_Code : To Refresh Release_Time for current locked record

03) RELEASE :	Release current record so other user can access
				Required Input :
					@Record_Locking_Code : To Release current locked record
=======================================================================================================================================*/

BEGIN
	--DECLARE
	--@Record_Code INT = 1,
	--@Module_Code INT = 4,
	--@User_Code INT = 221,
	--@IP_Address VARCHAR(20) = '192.168.0.35',
	--@Record_Locking_Code INT,
	--@Message NVARCHAR(500),
	--@Action VARCHAR(20) = 'LOCK'

	SET @Message = ''
	IF(@Action = 'LOCK')
	BEGIN
		SET @Record_Locking_Code = 0
		DECLARE @ExistRLCode INT = 0, @ExistUserCode INT = 0, @FullName NVARCHAR(3000) = '', @DiffInSecond INT = 0

		SELECT TOP 1 @ExistRLCode =  RC.Record_Locking_Code, @ExistUserCode=  U.Users_Code,  
		@FullName = U.First_Name + ' ' + U.Last_Name, @DiffInSecond = DATEDIFF(second, RC.Release_Time, GETDATE())
		FROM Record_Locking RC 
		INNER JOIN Users U ON U.Users_Code = RC.User_Code
        WHERE RC.Is_Active = 'Y' AND RC.Record_Code = @Record_Code AND RC.Module_Code = @Module_Code
        ORDER BY RC.Record_Locking_Code

		IF(@ExistRLCode > 0)
		BEGIN
			PRINT 'Exist Record Locking Code : ' + CAST(@ExistRLCode AS VARCHAR)
			DECLARE @MaxLockTimeInSecond INT = 20
			SELECT TOP 1 @MaxLockTimeInSecond  = CAST(Parameter_Value AS INT) 
			FROM System_Parameter_New WHERE Parameter_Name = 'Max_Record_Lock_Duration_In_Second' AND IsActive = 'Y'

			PRINT 'Max Lock Time In Second : ' + CAST(@MaxLockTimeInSecond AS VARCHAR)
			PRINT 'Diff In Second : ' + CAST(@DiffInSecond AS VARCHAR)

			IF(@DiffInSecond > @MaxLockTimeInSecond OR @ExistUserCode = @User_Code)
			BEGIN
				UPDATE Record_Locking SET Is_Active = 'N', Release_Time = NULL WHERE Record_Locking_Code = @ExistRLCode
				SET @ExistRLCode = 0
			END
			ELSE
			BEGIN
				SET @Message = 'This record is currently used by ' + @FullName
			END
		END

		IF(@ExistRLCode = 0)
		BEGIN
			INSERT INTO Record_Locking(Record_Code, User_Code, Module_Code, Lock_Time, Release_Time, IP_Address, Is_Active)
			VALUES (@Record_Code, @User_Code, @Module_Code, GETDATE(), GETDATE(), @IP_Address, 'Y')

			SELECT @Record_Locking_Code = ISNULL(IDENT_CURRENT('Record_Locking'), 0)
		END
	END
	ELSE IF(@Action = 'REFRESH')
	BEGIN
		UPDATE Record_Locking SET Release_Time =  GETDATE() WHERE Record_Locking_Code = @Record_Locking_Code
	END
	ELSE IF(@Action = 'RELEASE')
	BEGIN
		UPDATE Record_Locking SET Is_Active = 'N', Release_Time = GETDATE() WHERE Record_Locking_Code = @Record_Locking_Code
	END	

	SELECT @Record_Locking_Code, @Message
END
