CREATE PROCEDURE [dbo].[USP_UPDATE_ACQ_DEAL]
(
 @Acq_Deal_Code INT
,@Version varchar(50)
,@Agreement_Date datetime
,@Deal_Desc NVARCHAR(1000)
,@Deal_Type_Code int
,@Year_Type char(2)
,@Entity_Code int
,@Is_Master_Deal char(1)
,@Category_Code int
,@Vendor_Code int
,@Vendor_Contacts_Code int
,@Currency_Code int
,@Exchange_Rate numeric(10,3)
,@Ref_No NVARCHAR(100)
,@Attach_Workflow char(1)
,@Deal_Workflow_Status varchar(50)
,@Parent_Deal_Code int
,@Work_Flow_Code int
,@Amendment_Date datetime
,@Is_Released char(1)
,@Release_On datetime
,@Release_By int
,@Is_Completed char(1)
,@Is_Active char(1)
,@Content_Type char(2)
,@Payment_Terms_Conditions NVARCHAR(4000)
,@Status char(1)
,@Is_Auto_Generated char(1)
,@Is_Migrated char(1)
,@Cost_Center_Id int
,@Master_Deal_Movie_Code_ToLink int
,@BudgetWise_Costing_Applicable varchar(2)
,@Validate_CostWith_Budget varchar(2)
,@Deal_Tag_Code int
,@Business_Unit_Code int
,@Ref_BMS_Code varchar(100)
,@Remarks NVARCHAR(4000)
,@Rights_Remarks NVARCHAR(4000)
,@Payment_Remarks NVARCHAR(4000)
,@Inserted_By int
,@Inserted_On datetime
,@Last_Updated_Time datetime
,@Last_Action_By int
,@Lock_Time datetime
,@Role_Code Int
,@Channel_Cluster_Code Int
,@Is_Auto_Push CHAR(1)
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	Updates Acq Deal Call From EF Table Mapping
-- =============================================
BEGIN

UPDATE [Acq_Deal]
   SET [Version] = @Version
      ,[Agreement_Date] = @Agreement_Date
      ,[Deal_Desc] = @Deal_Desc
      ,[Deal_Type_Code] = @Deal_Type_Code
      ,[Year_Type] = @Year_Type
      ,[Entity_Code] = @Entity_Code
      ,[Is_Master_Deal] = @Is_Master_Deal
      ,[Category_Code] = @Category_Code
      ,[Vendor_Code] = @Vendor_Code
      ,[Vendor_Contacts_Code] = @Vendor_Contacts_Code
      ,[Currency_Code] = @Currency_Code
      ,[Exchange_Rate] = @Exchange_Rate
      ,[Ref_No] = @Ref_No
      ,[Attach_Workflow] = @Attach_Workflow
      ,[Deal_Workflow_Status] = @Deal_Workflow_Status
      ,[Parent_Deal_Code] = @Parent_Deal_Code
      ,[Work_Flow_Code] = @Work_Flow_Code
      ,[Amendment_Date] = @Amendment_Date
      ,[Is_Released] = @Is_Released
      ,[Release_On] = @Release_On
      ,[Release_By] = @Release_By
      ,[Is_Completed] = @Is_Completed
      ,[Is_Active] = @Is_Active
      ,[Content_Type] = @Content_Type
      ,[Payment_Terms_Conditions] = @Payment_Terms_Conditions
      ,[Status] = @Status
      ,[Is_Auto_Generated] = @Is_Auto_Generated
      ,[Is_Migrated] = @Is_Migrated
      ,[Cost_Center_Id] = @Cost_Center_Id
      ,[Master_Deal_Movie_Code_ToLink] = @Master_Deal_Movie_Code_ToLink
      ,[BudgetWise_Costing_Applicable] = @BudgetWise_Costing_Applicable
      ,[Validate_CostWith_Budget] = @Validate_CostWith_Budget
      ,[Deal_Tag_Code] = @Deal_Tag_Code
      ,[Business_Unit_Code] = @Business_Unit_Code
      ,[Ref_BMS_Code] = @Ref_BMS_Code
      ,[Remarks] = @Remarks
      ,[Rights_Remarks] = @Rights_Remarks
      ,[Payment_Remarks] = @Payment_Remarks
      ,[Inserted_By] = @Inserted_By
      ,[Inserted_On] = @Inserted_On
      ,[Last_Updated_Time] = @Last_Updated_Time
      ,[Last_Action_By] = @Last_Action_By
      ,[Lock_Time] = @Lock_Time
	  ,[Role_Code] = @Role_Code
	  ,[Channel_Cluster_Code] = @Channel_Cluster_Code
	  ,[Is_Auto_Push] = @Is_Auto_Push
 WHERE Acq_Deal_Code = @Acq_Deal_Code

END