CREATE PROCEDURE [dbo].[USP_Update_Music_Deal]
( 
	@Music_Deal_Code INT,
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
-- Description:	Ùpdate Music Deal Call From EF Table Mapping
-- =============================================
BEGIN

	UPDATE [Music_Deal] 
	SET 
		[Version] = @Version, 
		[Agreement_Date] = @Agreement_Date, 
		[Description] = @Description, 
		[Deal_Tag_Code] = @Deal_Tag_Code, 
		[Reference_No] = @Reference_No, 
		[Entity_Code] = @Entity_Code, 
		[Primary_Vendor_Code] = @Primary_Vendor_Code,
		[Music_Label_Code] = @Music_Label_Code, 
		[Title_Type] = @Title_Type, 
		[Duration_Restriction] = @Duration_Restriction, 
		[Rights_Start_Date] = @Rights_Start_Date, 
		[Rights_End_Date] = @Rights_End_Date, 
		[Term] = @Term, 
		[Run_Type] = @Run_Type, 
		[No_Of_Songs] = @No_Of_Songs,
		[Channel_Type] = @Channel_Type, 
		[Right_Rule_Code] = @Right_Rule_Code, 
		[Link_Show_Type] = @Link_Show_Type, 
		[Business_Unit_Code] = @Business_Unit_Code, 
		[Deal_Type_Code] = @Deal_Type_Code, 
		[Deal_Workflow_Status] = @Deal_Workflow_Status, 
		[Parent_Deal_Code] = @Parent_Deal_Code,
		[Work_Flow_Code] = @Work_Flow_Code,
		[Last_Updated_Time] = GETDATE(), 
		[Last_Action_By] = @Last_Action_By,
		[Remarks] = @Remarks,
		[Agreement_Cost] = @Agreement_Cost,
		[Channel_Or_Category] = @Channel_Or_Category,
		[Channel_Category_Code] = @Channel_Category_Code,
		[Right_Rule_Type] = @Right_Rule_Type
	WHERE 
		Music_Deal_Code = @Music_Deal_Code

END
