CREATE FUNCTION UFN_Get_UsernName_Last_Approved (
	@Deal_Code INT,
	@Module_Code INT,
	@Template_For VARCHAR
)
RETURNS NVARCHAR(MAX) AS
BEGIN
	DECLARE @return_value NVARCHAR(MAX) = '', @Is_RU_Content_Category CHAR(1) = 'N'
	DECLARE @User_Name NVARCHAR(MAX), @MWD_SG_Name NVARCHAR(MAX), @MSH_SG_Name NVARCHAR(MAX), @Role_Level INT = 0
	
	SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

	IF(@Is_RU_Content_Category = 'Y')
	BEGIN
		SELECT TOP 1
			@User_Name =  ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
				+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), ''),
			@MWD_SG_Name = SG.Security_Group_Name
		FROM Module_Status_History MSH 
			INNER JOIN Users U on MSH.Status_Changed_By = U.Users_Code
			INNER JOIN Security_Group SG ON U.Security_Group_Code = SG.Security_Group_Code
		WHERE Record_Code = @Deal_Code AND Status = 'A' AND Module_Code = @Module_Code
		ORDER BY MSH.Module_Status_Code DESC

		SELECT @MSH_SG_Name = SG.Security_Group_Name, @Role_Level = MWD.Role_Level
		FROM Module_Workflow_Detail MWD 
			INNER JOIN Security_Group SG ON MWD.Group_Code = SG.Security_Group_Code
		WHERE 
			MWD.Record_Code = @Deal_Code AND
			MWD.Role_Level = (SELECT MAX(Role_Level) FROM Module_Workflow_Detail WHERE Record_Code = @Deal_Code  And Is_Done = 'Y' AND Module_Code = @Module_Code)

		IF(@MWD_SG_Name = @MSH_SG_Name)
		BEGIN
			SELECT @return_value ='approved by ' + @User_Name + ' (' + @MWD_SG_Name + ') ' 
			IF @Template_For = 'I'
				SET @return_value = @return_value + 'and '
		END
	END

    RETURN @return_value
END