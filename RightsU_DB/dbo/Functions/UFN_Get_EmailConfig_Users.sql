﻿CREATE FUNCTION UFN_Get_EmailConfig_Users (@Key VARCHAR(4))    
RETURNS   @Tbl2 TABLE (
		Id INT IDENTITY(1,1),
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)
AS    
BEGIN
	--DECLARE @Key NVARCHAR(MAX) = 'CUR' 
	--DECLARE @Tbl2 TABLE (
	--	Id INT IDENTITY(1,1),
	--	BuCode INT,
	--	To_Users_Code NVARCHAR(MAX),
	--	To_User_Mail_Id  NVARCHAR(MAX),
	--	CC_Users_Code  NVARCHAR(MAX),
	--	CC_User_Mail_Id  NVARCHAR(MAX),
	--	BCC_Users_Code  NVARCHAR(MAX),
	--	BCC_User_Mail_Id  NVARCHAR(MAX)
	--)

	DECLARE	@tbl TABLE (
		id int identity(1,1),
		BuCode INT, 
		To_Users_Code INT, 
		To_User_Mail_Id NVARCHAR(MAX),
		CC_Users_Code INT, 
		CC_User_Mail_Id NVARCHAR(MAX), 
		BCC_Users_Code INT, 
		BCC_User_Mail_Id NVARCHAR(MAX),
		Channel_Codes VARCHAR(MAX))

	DECLARE 
	@Business_Unit_Codes NVARCHAR(MAX),
	@To_User_Codes NVARCHAR(MAX),
	@CC_Users NVARCHAR(MAX),
	@BCC_Users  NVARCHAR(MAX),
	@Security_Group_Code NVARCHAR(MAX),
	@User_Type NVARCHAR(MAX),
	@Channel_Codes NVARCHAR(MAX),
	@ToUser_MailID NVARCHAR(MAX),
	@CCUser_MailID NVARCHAR(MAX),
	@BCCUser_MailID NVARCHAR(MAX),
	@BUCode INT

	DECLARE db_cursor CURSOR FOR 
	SELECT  ECDU.Business_Unit_Codes,
			ECDU.User_Codes, 
			ECDU.CC_Users, 
			ECDU.BCC_Users, 
			ECDU.Security_Group_Code, 
			User_Type, 
			ECDU.Channel_Codes,
			ECDU.ToUser_MailID,	
			ECDU.CCUser_MailID,	
			ECDU.BCCUser_MailID
	FROM Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
		INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE [Key] = @Key
	
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO 	@Business_Unit_Codes  ,@To_User_Codes	,@CC_Users  ,@BCC_Users   ,@Security_Group_Code  ,@User_Type  ,@Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID 

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		  
		  IF(@User_Type = 'U')
		  BEGIN
				INSERT INTO @tbl(BuCode, To_Users_Code, Channel_Codes, To_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@To_User_Codes,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
				
		  END
		  ELSE IF(@User_Type = 'G')
		  BEGIN
				INSERT INTO @tbl(BuCode, To_Users_Code, Channel_Codes, To_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code,U.Users_Code,@Channel_Codes,U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code=U.Users_Code
				WHERE U.Security_Group_Code IN (@Security_Group_Code)
					AND (UBU.Business_Unit_Code IN(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y' OR ISNULL(@Business_Unit_Codes,'0') = '0')
		  END
		  ELSE IF(@User_Type = 'E')
		  BEGIN

				INSERT INTO @tbl(BuCode, Channel_Codes, To_User_Mail_Id, CC_User_Mail_Id, BCC_User_Mail_Id)
				SELECT number, @Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID from fn_Split_withdelemiter(@Business_Unit_Codes,',')

		  END

		  IF(@CC_Users IS NOT NULL)
		  BEGIN
				INSERT INTO @tbl(BuCode, CC_Users_Code, Channel_Codes, CC_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@CC_Users,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
		   END

		  IF(@BCC_Users IS NOT NULL)
		  BEGIN
				INSERT INTO @tbl(BuCode, BCC_Users_Code, Channel_Codes, BCC_User_Mail_Id)
				SELECT DISTINCT UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
				FROM Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
				WHERE U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@BCC_Users,','))
					AND (UBU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'OR ISNULL(@Business_Unit_Codes,'0') = '0')
		  END

		  FETCH NEXT FROM db_cursor INTO 	@Business_Unit_Codes  ,@To_User_Codes	,@CC_Users  ,@BCC_Users   ,@Security_Group_Code  ,@User_Type  ,@Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID 
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 


	DECLARE db_BU_cursor CURSOR FOR 
	SELECT DISTINCT BuCode, Channel_Codes FROM @tbl

	OPEN db_BU_cursor  
	FETCH NEXT FROM db_BU_cursor INTO @BUCode ,@Channel_Codes

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
			INSERT INTO @Tbl2 (BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes)
			SELECT @BUCode, STUFF((
					SELECT ',' + CAST(To_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + To_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ',' + CAST(CC_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + CC_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''),
				STUFF((
					SELECT ',' + CAST(BCC_Users_Code AS NVARCHAR(MAX))
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), 
				STUFF((
					SELECT ';' + BCC_User_Mail_Id
					FROM @tbl  where BuCode = @BUCode
				FOR XML PATH('')), 1, 1, ''), @Channel_Codes

		 
		  FETCH NEXT FROM db_BU_cursor INTO @BUCode , @Channel_Codes
	END 

	CLOSE db_BU_cursor  
	DEALLOCATE db_BU_cursor 

	RETURN	
END

/*
--RETURN 
SELECT  ECDU.Business_Unit_Codes,
			ECDU.User_Codes, 
			ECDU.CC_Users, 
			ECDU.BCC_Users, 
			ECDU.Security_Group_Code, 
			User_Type, 
			ECDU.Channel_Codes,
			ECDU.ToUser_MailID,	
			ECDU.CCUser_MailID,	
			ECDU.BCCUser_MailID
	FROM Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
		INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE [Key] = 'CUR'

--		select *  FROM [dbo].[UFN_Get_Bu_Wise_User]('CUR')

--		SELECT * FROM UFN_Get_EmailConfig_Users('CUR')

------	SELECT * FROM Email_Config_Detail_User WHERE Users_Code IN (136,1319,247)

--*/

--select BU.Business_Unit_Name, U.Login_Name, U.First_Name, U.Last_Name
--from Users_Business_Unit A
--inner join Business_Unit BU on A.Business_Unit_Code = BU.Business_Unit_Code
--inner join Users U on U.Users_Code = A.Users_Code
--order by 1
----where Business_Unit_Code = 24
--select * from Users where users_code in (247,136)