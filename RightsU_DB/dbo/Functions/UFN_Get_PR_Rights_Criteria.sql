CREATE Function [dbo].[UFN_Get_PR_Rights_Criteria](@DataCodes Varchar(2000), @DataType VARCHAR(10), @DataFor VARCHAR(10))
Returns @Tbl_Ret TABLE (
	Data_Code Int,
	Criteria_Name NVarchar(MAX),
	Data_Type NVarchar(MAX)
) AS
Begin
--DECLARE  @Tbl_Ret TABLE (
--	Data_Code INT IDENTITY(1,1),
--	Criteria_Name NVarchar(MAX),
--	Data_Type NVarchar(MAX)
--	)
--DECLARE @DataCodes Varchar(2000) ='10,50,64,8', @DataType VARCHAR(10)='I', @DataFor VARCHAR(10)='RG'
	
	IF(@DataType = 'I' AND @DataFor = 'RG')
	BEGIN
		INSERT INTO @Tbl_Ret(Criteria_Name,Data_Type)
		Select STUFF((Select DISTINCT ',' +  CAST(Country_Name AS NVARCHAR(MAX)) from  Country  
		WHERE Country_Code IN(select number from fn_Split_withdelemiter(@DataCodes,','))
		FOR XML PATH('')),1,1,''),'I'
	END
	ELSE IF(@DataType = 'G' AND @DataFor = 'RG')
	BEGIN
		INSERT INTO @Tbl_Ret(Criteria_Name,Data_Type)
		Select STUFF((Select DISTINCT ',' +  CAST(Territory_Name AS NVARCHAR(MAX)) from  Territory  
		WHERE Territory_Code IN(select number from fn_Split_withdelemiter(@DataCodes,','))
		FOR XML PATH('')),1,1,''),'G'
	END
	ELSE IF(@DataType = 'L' AND (@DataFor = 'SL' OR @DataFor = 'DB'))
	BEGIN
		INSERT INTO @Tbl_Ret(Criteria_Name,Data_Type)
		Select STUFF((Select DISTINCT ',' +  CAST(Language_Name AS NVARCHAR(MAX)) from  Language  
		WHERE Language_Code IN(select number from fn_Split_withdelemiter(@DataCodes,','))
		FOR XML PATH('')),1,1,''),'L'
	END
	ELSE IF(@DataType = 'G' AND (@DataFor = 'SL' OR @DataFor = 'DB'))
	BEGIN
		INSERT INTO @Tbl_Ret(Criteria_Name,Data_Type)
		Select STUFF((Select DISTINCT ',' +  CAST(Language_Group_Name AS NVARCHAR(MAX)) from  Language_Group  
		WHERE Language_Group_Code IN(select number from fn_Split_withdelemiter(@DataCodes,','))
		FOR XML PATH('')),1,1,''),'G'
	END

	--Select * from @Tbl_Ret
	RETURN 
END