CREATE FUNCTION [dbo].[UFN_Get_Bu_Wise_User] (@Key VARCHAR(4))    
RETURNS @tbl TABLE (id int identity(1,1), BuCode INT, Users_Code INT, User_Mail_Id NVARCHAR(MAX), Channel_Codes VARCHAR(MAX)) AS    
BEGIN
	DECLARE @Business_Unit_Codes VARCHAR(MAX), @User_Codes VARCHAR(MAX), @Security_Group_Code INT, @User_Type CHAR(1), @Email_Config_Code INT,
	@Channel_Codes VARCHAR(MAX)

	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = @Key
	
	DECLARE cPointer CURSOR FOR 
	select ECDU.Business_Unit_Codes, ECDU.User_Codes, ECDU.Security_Group_Code, User_Type, ECDU.Channel_Codes
	from Email_Config EC INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
	INNER JOIN Email_Config_Detail_User ECDU ON ECDU.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	where [Key] = @Key
		OPEN cPointer
			FETCH NEXT FROM cPointer INTO @Business_Unit_Codes, @User_Codes, @Security_Group_Code, @User_Type, @Channel_Codes
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--DECLARE @tempInner Table (Bu_Code INT,User_Code INT)
				
				IF EXISTS(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
				IF(@User_Type = 'U')
				BEGIN
					INSERT INTO @tbl(BuCode, Users_Code, Channel_Codes, User_Mail_Id)
					select UBU.Business_Unit_Code, U.Users_Code, @Channel_Codes, U.Email_Id
					from Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
					where U.Users_Code IN(SELECT number FROM fn_Split_withdelemiter(@User_Codes,','))
					AND (UBU.Business_Unit_Code IN(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'
					OR ISNULL(@Business_Unit_Codes,'0') = '0'
					)
				END
				ELSE
				BEGIN
					INSERT INTO @tbl(BuCode, Users_Code, Channel_Codes, User_Mail_Id)
					select UBU.Business_Unit_Code,U.Users_Code,@Channel_Codes,U.Email_Id
					from Users U
					INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code=U.Users_Code
					where U.Security_Group_Code IN(@Security_Group_Code)
					AND (UBU.Business_Unit_Code IN(SELECT number from fn_Split_withdelemiter(@Business_Unit_Codes,','))
					AND U.Is_Active = 'Y'
					OR ISNULL(@Business_Unit_Codes,'0') = '0')
				END

				--INSERT INTO @tbl(BuCode,Users_Code,Channel_Codes)
				--SELECT Bu_Code,User_Code,@Channel_Codes FROM @tempInner
				
				--UPDATE T SET T.User_Mail_Id=U.Email_Id from @tbl AS T
				--INNER JOIN Users U ON U.Users_Code=T.Users_Code
				
				--DELETE FROM @tempInner

			FETCH NEXT FROM cPointer INTO @Business_Unit_Codes, @User_Codes, @Security_Group_Code, @User_Type, @Channel_Codes
			END
			CLOSE cPointer
		DEALLOCATE cPointer
  RETURN
END
