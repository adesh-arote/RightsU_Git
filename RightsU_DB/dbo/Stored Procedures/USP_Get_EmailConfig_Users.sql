ALTER PROCEDURE USP_Get_EmailConfig_Users 
(
	@Key VARCHAR(5),
	@CallFor CHAR(1) = 'N'
)       
AS    
BEGIN
	--DECLARE @Key NVARCHAR(MAX) = 'TME', @CallFor  CHAR(1) = 'N'
	DECLARE @Tbl2 TABLE (
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

	IF @CallFor = 'Y'
	BEGIN
		SELECT A. BUCode, A.Users_Code , A.User_Mail_Id  FROM (
		SELECT BUCode, To_Users_Code As Users_Code , To_User_Mail_Id AS User_Mail_Id  
		FROM @tbl WHERE To_Users_Code IS NOT NULL OR CC_Users_Code IS NOT NULL or BCC_Users_Code IS NOT NULL
		UNION ALL
		SELECT BuCode, NULL, To_User_Mail_Id FROM @tbl WHERE To_Users_Code IS NULL AND CC_Users_Code IS NULL AND BCC_Users_Code IS NULL
		) AS A WHERE ISNULL(A.Users_Code,'') <> ''

		--SELECT BUCode, COALESCE(To_Users_Code,CC_Users_Code, BCC_Users_Code) As Users_Code , COALESCE(To_User_Mail_Id,CC_User_Mail_Id, BCC_User_Mail_Id) AS User_Mail_Id  
		--FROM @tbl WHERE To_Users_Code IS NOT NULL OR CC_Users_Code IS NOT NULL or BCC_Users_Code IS NOT NULL
		--UNION ALL
		--SELECT BuCode, NULL, To_User_Mail_Id+';'+CC_User_Mail_Id+';'+BCC_User_Mail_Id FROM @tbl WHERE To_Users_Code IS NULL AND CC_Users_Code IS NULL AND BCC_Users_Code IS NULL
	END

	
	SELECT @Business_Unit_Codes = ECDU.Business_Unit_Codes	
	FROM Email_Config EC 
		INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
		INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE [Key] = @Key

	IF(@Business_Unit_Codes = 0)
	BEGIN
		DECLARE db_Channel_Cursor CURSOR FOR 
		SELECT DISTINCT  Channel_Codes FROM @tbl

		OPEN db_Channel_Cursor  
		FETCH NEXT FROM db_Channel_Cursor INTO @Channel_Codes

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
				INSERT INTO @Tbl2 (BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes)
				SELECT 0, STUFF((
						SELECT DISTINCT ',' + CAST(To_Users_Code AS NVARCHAR(MAX))
						FROM @tbl 
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + To_User_Mail_Id
						FROM @tbl  
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ',' + CAST(CC_Users_Code AS NVARCHAR(MAX))
						FROM @tbl
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + CC_User_Mail_Id
						FROM @tbl 
					FOR XML PATH('')), 1, 1, ''),
					STUFF((
						SELECT DISTINCT ',' + CAST(BCC_Users_Code AS NVARCHAR(MAX))
						FROM @tbl 
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + BCC_User_Mail_Id
						FROM @tbl 
					FOR XML PATH('')), 1, 1, ''), @Channel_Codes

		 
			  FETCH NEXT FROM db_Channel_Cursor INTO  @Channel_Codes
		END 

		CLOSE db_Channel_Cursor  
		DEALLOCATE db_Channel_Cursor 

	END
	ELSE
	BEGIN

		DECLARE db_BU_cursor CURSOR FOR 
		SELECT DISTINCT BuCode, Channel_Codes FROM @tbl

		OPEN db_BU_cursor  
		FETCH NEXT FROM db_BU_cursor INTO @BUCode ,@Channel_Codes

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
				INSERT INTO @Tbl2 (BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, Channel_Codes)
				SELECT @BUCode, STUFF((
						SELECT DISTINCT ',' + CAST(To_Users_Code AS NVARCHAR(MAX))
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + To_User_Mail_Id
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ',' + CAST(CC_Users_Code AS NVARCHAR(MAX))
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + CC_User_Mail_Id
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''),
					STUFF((
						SELECT  DISTINCT ',' + CAST(BCC_Users_Code AS NVARCHAR(MAX))
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''), 
					STUFF((
						SELECT DISTINCT ';' + BCC_User_Mail_Id
						FROM @tbl  where BuCode = @BUCode
					FOR XML PATH('')), 1, 1, ''), @Channel_Codes

		 
			  FETCH NEXT FROM db_BU_cursor INTO @BUCode , @Channel_Codes
		END 

		CLOSE db_BU_cursor  
		DEALLOCATE db_BU_cursor 
	END
	IF @CallFor = 'N'
		SELECT Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes FROM @tbl2

END