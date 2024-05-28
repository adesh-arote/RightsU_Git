CREATE PROCEDURE [dbo].[USP_Insert_Music_Deal]
( 
	@Version VARCHAR(50),
	@Agreement_Date DATETIME,
	@Description NVARCHAR(4000),
	@Deal_Tag_Code INT,
	@Reference_No NVARCHAR(100),
	@Entity_Code INT,
	@Primary_Vendor_Code INT,
	@Music_Label_Code INT,
	@Title_Type CHAR(1),
	@Duration_Restriction DECIMAL(18, 2),
	@Rights_Start_Date DATETIME,
	@Rights_End_Date DATETIME,
	@Term VARCHAR(12),
	@Run_Type CHAR(1),
	@No_Of_Songs INT,
	@Channel_Type CHAR(1),
	@Right_Rule_Code INT,
	@Link_Show_Type CHAR(2),
	@Business_Unit_Code INT,
	@Deal_Type_Code INT,
	@Deal_Workflow_Status VARCHAR(5),
	@Parent_Deal_Code INT,
	@Work_Flow_Code INT,
	@Inserted_By INT,
	@Last_Action_By INT,
	@Remarks NVARCHAR(MAX),
	@Agreement_Cost DECIMAL(38,3),
	@Channel_Or_Category CHAR(1),
	@Channel_Category_Code INT,
	@Right_Rule_Type CHAR(1)
)
AS
-- =============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create DATE: 01 March 2017
-- Description:	Inserts Music Deal Call From EF Table Mapping
-- =============================================
BEGIN

	INSERT INTO [Music_Deal] 
	(
		[Agreement_No], 
		[Version], [Agreement_Date], [Description], [Deal_Tag_Code], [Reference_No], [Entity_Code], [Primary_Vendor_Code], [Music_Label_Code], 
		[Title_Type], [Duration_Restriction], [Rights_Start_Date], [Rights_End_Date], [Term], [Run_Type], [No_Of_Songs], [Channel_Type], [Right_Rule_Code], 
		[Link_Show_Type], [Business_Unit_Code], [Deal_Type_Code], [Deal_Workflow_Status], [Work_Flow_Code], [Parent_Deal_Code],
		[Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By], [Remarks], [Agreement_Cost], [Channel_Or_Category], [Channel_Category_Code], [Right_Rule_Type]
	)
	SELECT	
		[dbo].[UFN_Auto_Genrate_Agreement_No]('M', @Agreement_Date, 0) AS [Agreement_No],
		@Version, @Agreement_Date, @Description, @Deal_Tag_Code, @Reference_No, @Entity_Code, @Primary_Vendor_Code, @Music_Label_Code, 
		@Title_Type, @Duration_Restriction, @Rights_Start_Date, @Rights_End_Date, @Term, @Run_Type, @No_Of_Songs, @Channel_Type, @Right_Rule_Code, 
		@Link_Show_Type, @Business_Unit_Code, @Deal_Type_Code, @Deal_Workflow_Status, @Work_Flow_Code, @Parent_Deal_Code,
		@Inserted_By, GETDATE(), GETDATE(), @Last_Action_By, @Remarks, @Agreement_Cost, @Channel_Or_Category, @Channel_Category_Code, @Right_Rule_Type

	SELECT Music_Deal_Code, Agreement_No FROM Music_Deal WHERE Music_Deal_Code = SCOPE_IDENTITY()
END
