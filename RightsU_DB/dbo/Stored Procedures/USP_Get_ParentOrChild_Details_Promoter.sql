CREATE PROCEDURE [dbo].[USP_Get_ParentOrChild_Details_Promoter]       
(        
	@Promoter_Group_Codes VARCHAR(MAX) , 
	@Type CHAR(1)
)    
AS    
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_ParentOrChild_Details_Promoter]', 'Step 1', 0, 'Started Procedure', 0, ''
	IF(@Type = 'P')
	BEGIN
		SET NOCOUNT ON
		IF(OBJECT_ID('TEMPDB..#Promoter_Group_Parent') IS NOT NULL)
			DROP TABLE #Promoter_Group

		IF(OBJECT_ID('TEMPDB..#Parent_Group') IS NOT NULL)
			DROP TABLE #Parent_Group

		CREATE TABLE #Parent_Group
		(
			Parent_Group_Code INT
		)

		CREATE TABLE #Promoter_Group_Parent        
		(        
		Promoter_Group_Code INT,
		Parent_Group_Code INT  
		)        

		INSERT INTO #Promoter_Group_Parent (Promoter_Group_Code)
		SELECT number FROM fn_Split_withdelemiter(@Promoter_Group_Codes,',') WHERE number <> '' AND number > 0

		UPDATE TPG
		SET TPG.Parent_Group_Code= PG.Parent_Group_Code
		FROM #Promoter_Group_Parent TPG
		INNER JOIN Promoter_Group PG ON (TPG.Promoter_Group_code = PG.Promoter_Group_code)


		INSERT INTO #Parent_Group(Parent_Group_Code)
		SELECT DISTINCT Parent_Group_Code from #Promoter_Group_Parent WHERE Parent_Group_Code > 0

		DECLARE @selectedCount INT, @totalCount INT,@ParentCode INT = 0, @ImmediateParentCode INT = 0
		SELECT TOP 1 @ParentCode = Parent_Group_Code FROM #Parent_Group


		WHILE(@ParentCode > 0)
		BEGIN
			/*Start Logic*/
			SELECT @selectedCount = COUNT(Promoter_Group_Code) FROM #Promoter_Group_Parent WHERE Parent_Group_Code = @ParentCode
			SELECT @totalCount = COUNT(Promoter_Group_Code) FROM Promoter_Group (NOLOCK) WHERE Parent_Group_Code = @ParentCode
			IF(@selectedCount = @totalCount)
			BEGIN
				SELECT @ImmediateParentCode = Parent_Group_Code FROM Promoter_Group (NOLOCK) where Promoter_Group_Code = @ParentCode
				DELETE FROM #Promoter_Group_Parent WHERE Parent_Group_Code = @ParentCode
				INSERT INTO #Promoter_Group_Parent(Promoter_Group_Code,Parent_Group_Code)
				SELECT @ParentCode,@ImmediateParentCode			

				IF(@ImmediateParentCode > 0)
				BEGIN
					INSERT INTO #Parent_Group(Parent_Group_Code) VALUES(@ImmediateParentCode)
				END
			END
			/*End Logic*/

			/*Fetch next Record*/
			DELETE #Parent_Group where Parent_Group_Code = @ParentCode
			SELECT @ParentCode = 0, @ImmediateParentCode = 0
			SELECT TOP 1 @ParentCode = Parent_Group_Code FROM #Parent_Group
		END

		SELECT  STUFF((SELECT ', ' + CAST(Promoter_Group_Code AS VARCHAR) FROM #Promoter_Group_Parent FOR XML PATH('')),1,1,'') AS Promoter_Group_Codes
		END
		ELSE
		BEGIN
		IF(OBJECT_ID('TEMPDB..#Promoter_Group_Child') IS NOT NULL)
			DROP TABLE #Promoter_Group_Child


		CREATE TABLE #Promoter_Group_Child        
		(        
		Promoter_Group_Code INT,
		Is_Last_Level CHAR(1)  
		)        

		INSERT INTO #Promoter_Group_Child (Promoter_Group_Code)
		SELECT number FROM fn_Split_withdelemiter(@Promoter_Group_Codes,',') WHERE number <> '' AND number > 0

		UPDATE TPG
		SET TPG.Is_Last_Level = PG.Is_Last_Level
		FROM #Promoter_Group_Child TPG
		INNER JOIN Promoter_Group PG ON (TPG.Promoter_Group_code = PG.Promoter_Group_code)

		DECLARE @PromoterGroupCode INT = 0
		SELECT TOP 1 @PromoterGroupCode = Promoter_Group_Code FROM #Promoter_Group_Child WHERE Is_Last_Level = 'N'


		WHILE(@PromoterGroupCode > 0)
		BEGIN
			/*Start Logic*/
				DELETE FROM #Promoter_Group_Child WHERE Promoter_Group_Code = @PromoterGroupCode
				INSERT INTO #Promoter_Group_Child(Promoter_Group_Code, Is_Last_Level)
				SELECT Promoter_Group_Code,	Is_Last_Level FROM Promoter_Group (NOLOCK) WHERE Parent_Group_Code = @PromoterGroupCode				
			/*End Logic*/

			/*Fetch next Record*/
			SELECT @PromoterGroupCode = 0
			SELECT TOP 1 @PromoterGroupCode = Promoter_Group_Code FROM #Promoter_Group_Child WHERE Is_Last_Level = 'N'
		END

		SELECT  STUFF((SELECT ', ' + CAST(Promoter_Group_Code AS VARCHAR) FROM #Promoter_Group_Child FOR XML PATH('')),1,1,'') AS Promoter_Group_Codes

		END

		IF OBJECT_ID('tempdb..#Parent_Group') IS NOT NULL DROP TABLE #Parent_Group
		IF OBJECT_ID('tempdb..#Promoter_Group') IS NOT NULL DROP TABLE #Promoter_Group
		IF OBJECT_ID('tempdb..#Promoter_Group_Child') IS NOT NULL DROP TABLE #Promoter_Group_Child
		IF OBJECT_ID('tempdb..#Promoter_Group_Parent') IS NOT NULL DROP TABLE #Promoter_Group_Parent
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_ParentOrChild_Details_Promoter]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END