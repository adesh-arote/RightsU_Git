-- =============================================
-- Author:		Anchal Sikarwar
-- CREATE DATE: 13 June 2017
-- Description:	Return the list of User with business Code
-- Modified by: Vipul Surve
-- Modified Date : 22 Aug 2017
-- Added Is_Active = 'Y' Condition in Where Clause
-- =============================================
ALTER FUNCTION [dbo].[UFN_Get_Bu_Wise_User] (@Key CHAR(4))    
RETURNS
--DECLARE @Key CHAR(4)='ARE'
--DECLARE 
@tbl TABLE (id int identity(1,1), BuCode INT,  Users_Codes VARCHAR(MAX), User_Mail_Id NVARCHAR(MAX), Channel_Codes VARCHAR(MAX), CCUser_Mail_Id NVARCHAR(MAX), BCCUser_Mail_Id NVARCHAR(MAX)) AS    
BEGIN
	DECLARE @Business_Unit_Codes VARCHAR(MAX), @User_Codes VARCHAR(MAX), @Security_Group_Code INT, @User_Type CHAR(1), @Email_Config_Code INT,
	@Channel_Codes VARCHAR(MAX), @ToUser_MailID NVARCHAR(MAX), @CCUser_MailID NVARCHAR(MAX), @BCCUser_MailID NVARCHAR(MAX), @CC_UserCodes VARCHAR(MAX), @BCC_UserCodes VARCHAR(MAX)

	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = @Key

	DECLARE cPointer CURSOR FOR 
	select DISTINCT ECDU.Business_Unit_Codes, ECDU.User_Codes, ECDU.Security_Group_Code, User_Type, ECDU.Channel_Codes, ECDU.CC_Users, ECDU.BCC_Users,
	ECDU.ToUser_MailID, ECDU.CCUser_MailID, ECDU.BCCUser_MailID
	from Email_Config EC INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
	INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	where [Key] = @Key
		OPEN cPointer
			FETCH NEXT FROM cPointer INTO @Business_Unit_Codes, @User_Codes, @Security_Group_Code, @User_Type, @Channel_Codes, @CC_UserCodes, @BCC_UserCodes,
			@ToUser_MailID, @CCUser_MailID, @BCCUser_MailID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--DECLARE @tempInner Table (Bu_Code INT,User_Code INT)
				
				IF EXISTS(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
				IF(@User_Type = 'U')
				BEGIN
					INSERT INTO @tbl(BuCode, Users_Codes, Channel_Codes, User_Mail_Id, CCUser_Mail_Id,BCCUser_Mail_Id)
					select number, @User_Codes, @Channel_Codes, 
					STUFF(( select ';' +U.Email_Id from Users U where  U.Is_Active = 'Y' AND  U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@User_Codes,'0'),',')) FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, '')
					,(STUFF(( select ';' +U.Email_Id from Users U where  U.Is_Active = 'Y' AND  U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@CC_UserCodes,'0'),',') 
					) AND ISNULL(@CC_UserCodes,'') IS NOT NULL FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, ''))
					,STUFF(( select ';' +U.Email_Id from Users U where U.Is_Active = 'Y' AND U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@BCC_UserCodes,'0'),',')) FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, '')
					FROM fn_Split_withdelemiter(@Business_Unit_Codes,',') 
				END
				ELSE IF(@User_Type = 'E')
				BEGIN
					INSERT INTO @tbl(BuCode, Users_Codes, Channel_Codes, User_Mail_Id, CCUser_Mail_Id,BCCUser_Mail_Id)
					select number, @User_Codes, @Channel_Codes, @ToUser_MailID, @CCUser_MailID, @BCCUser_MailID FROM fn_Split_withdelemiter(@Business_Unit_Codes,',')
				END
				ELSE
				BEGIN
					SET @User_Codes = STUFF(( select DISTINCT ',' + CAST(U.Users_Code AS VARCHAR) from Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code=U.Users_Code
					where U.Security_Group_Code IN(@Security_Group_Code) AND U.Is_Active = 'Y'  
					AND (UBU.Business_Unit_Code IN(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,',')) OR ISNULL(@Business_Unit_Codes,'0') = '0')
					AND U.Is_Active = 'Y' FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, '')

					INSERT INTO @tbl(BuCode, Users_Codes, Channel_Codes, User_Mail_Id, CCUser_Mail_Id,BCCUser_Mail_Id)
					SELECT number, @User_Codes, @Channel_Codes, 
					STUFF(( select ';' +U.Email_Id from Users U where  U.Is_Active = 'Y' AND  U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@User_Codes,'0'),',')) FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, ''),
						STUFF(( select ';' +U.Email_Id from Users U where  U.Is_Active = 'Y' AND  U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@CC_UserCodes,'0'),',')) FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, ''),
					STUFF(( select ';' +U.Email_Id from Users U where  U.Is_Active = 'Y' AND  U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(ISNULL(@BCC_UserCodes,'0'),',')) FOR XML PATH(''),root('MyString'), type   
					 ).value('/MyString[1]','nvarchar(max)')   
					, 1, 1, '')
					FROM fn_Split_withdelemiter(@Business_Unit_Codes,',')
				END
			FETCH NEXT FROM cPointer INTO @Business_Unit_Codes, @User_Codes, @Security_Group_Code, @User_Type, @Channel_Codes, @CC_UserCodes, @BCC_UserCodes,
			@ToUser_MailID, @CCUser_MailID,@BCCUser_MailID
			END
			CLOSE cPointer
		DEALLOCATE cPointer
  RETURN
  --select * from @tbl
END    

