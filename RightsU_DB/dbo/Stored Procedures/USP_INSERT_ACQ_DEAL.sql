

CREATE PROCEDURE [dbo].[USP_INSERT_ACQ_DEAL]
( 
 @Version VARCHAR(50)
,@Agreement_Date DATETIME
,@Deal_Desc NVARCHAR(1000)
,@Deal_Type_Code INT
,@Year_Type CHAR(2)
,@Entity_Code INT
,@Is_Master_Deal CHAR(1)
,@Category_Code INT
,@Vendor_Code INT
,@Vendor_Contacts_Code INT
,@Currency_Code INT
,@Exchange_Rate numeric(10,3)
,@Ref_No NVARCHAR(100)
,@Attach_Workflow CHAR(1)
,@Deal_Workflow_Status VARCHAR(50)
,@Parent_Deal_Code INT
,@Work_Flow_Code INT
,@Amendment_Date DATETIME
,@Is_Released CHAR(1)
,@Release_On DATETIME
,@Release_By INT
,@Is_Completed CHAR(1)
,@Is_Active CHAR(1)
,@Content_Type CHAR(2)
,@Payment_Terms_Conditions NVARCHAR(4000)
,@Status CHAR(1)
,@Is_Auto_Generated CHAR(1)
,@Is_Migrated CHAR(1)
,@Cost_Center_Id INT
,@Master_Deal_Movie_Code_ToLink INT
,@BudgetWise_Costing_Applicable VARCHAR(2)
,@Validate_CostWith_Budget VARCHAR(2)
,@Deal_Tag_Code INT
,@Business_Unit_Code INT
,@Ref_BMS_Code VARCHAR(100)
,@Remarks NVARCHAR(4000)
,@Rights_Remarks NVARCHAR(4000)
,@Payment_Remarks NVARCHAR(4000)
,@Inserted_By INT
,@Inserted_On DATETIME
,@Last_Updated_Time DATETIME
,@Last_Action_By INT
,@Lock_Time DATETIME
,@Role_Code Int
,@Channel_Cluster_Code Int
,@Is_Auto_Push CHAR(1)
,@Deal_Segment_Code INT
,@Revenue_Vertical_Code INT
,@Confirming_Party NVARCHAR(MAX)
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 07-October-2014
-- Description:	Inserts Acq Deal Call From EF Table Mapping
-- =============================================
BEGIN

INSERT INTO [Acq_Deal]
		([Agreement_No]
		,[Version]
		,[Agreement_Date]
		,[Deal_Desc]
		,[Deal_Type_Code]
		,[Year_Type]
		,[Entity_Code]
		,[Is_Master_Deal]
		,[Category_Code]
		,[Vendor_Code]
		,[Vendor_Contacts_Code]
		,[Currency_Code]
		,[Exchange_Rate]
		,[Ref_No]
		,[Attach_Workflow]
		,[Deal_Workflow_Status]
		,[Parent_Deal_Code]
		,[Work_Flow_Code]
		,[Amendment_Date]
		,[Is_Released]
		,[Release_On]
		,[Release_By]
		,[Is_Completed]
		,[Is_Active]
		,[Content_Type]
		,[Payment_Terms_Conditions]
		,[Status]
		,[Is_Auto_Generated]
		,[Is_Migrated]
		,[Cost_Center_Id]
		,[Master_Deal_Movie_Code_ToLink]
		,[BudgetWise_Costing_Applicable]
		,[Validate_CostWith_Budget]
		,[Deal_Tag_Code]
		,[Business_Unit_Code]
		,[Ref_BMS_Code]
		,[Remarks]
		,[Rights_Remarks]
		,[Payment_Remarks]
		,[Deal_Complete_Flag]
		,[Inserted_By]
		,[Inserted_On]
		,[Last_Updated_Time]
		,[Last_Action_By]
		,[Lock_Time]
		,[Role_Code]
		,[Channel_Cluster_Code]
		,[Is_Auto_Push]
		,[Deal_Segment_Code]
		,[Revenue_Vertical_Code]
		,[Confirming_Party] )
	Select [dbo].[UFN_Auto_Genrate_Agreement_No]('A', @Agreement_Date, ISNULL(@Master_Deal_Movie_Code_ToLink, 0)) [Agreement_No]
		,@Version
		,@Agreement_Date
		,@Deal_Desc
		,@Deal_Type_Code
		,@Year_Type
		,@Entity_Code
		,@Is_Master_Deal
		,@Category_Code
		,@Vendor_Code
		,@Vendor_Contacts_Code
		,@Currency_Code
		,@Exchange_Rate
		,@Ref_No
		,@Attach_Workflow
		,@Deal_Workflow_Status
		,@Parent_Deal_Code
		,@Work_Flow_Code
		,@Amendment_Date
		,@Is_Released
		,@Release_On
		,@Release_By
		,@Is_Completed
		,@Is_Active
		,@Content_Type
		,@Payment_Terms_Conditions
		,@Status
		,@Is_Auto_Generated
		,@Is_Migrated
		,@Cost_Center_Id
		,@Master_Deal_Movie_Code_ToLink
		,@BudgetWise_Costing_Applicable
		,@Validate_CostWith_Budget
		,@Deal_Tag_Code
		,@Business_Unit_Code
		,NULL--@Ref_BMS_Code
		,@Remarks
		,@Rights_Remarks
		,@Payment_Remarks
		,(Select Parameter_Value From System_Parameter_New Where Parameter_Name = 'Deal_Complete_Flag')
		,@Inserted_By
		,GETDATE()
		,Getdate()
		,@Last_Action_By
		,@Lock_Time
		,@Role_Code
		,@Channel_Cluster_Code
		,@Is_Auto_Push
		,@Deal_Segment_Code
		,@Revenue_Vertical_Code
		,@Confirming_Party

		SELECT Acq_Deal_Code,Agreement_No
		FROM Acq_Deal WHERE Acq_Deal_Code=SCOPE_IDENTITY()
END
