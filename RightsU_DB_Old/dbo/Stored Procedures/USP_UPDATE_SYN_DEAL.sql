
CREATE PROCEDURE [dbo].[USP_UPDATE_SYN_DEAL]
(
    @Syn_Deal_Code INT ,
	@Deal_Type_Code INT ,
	@Business_Unit_Code INT ,
	@Other_Deal VARCHAR(100) ,
	@Agreement_No VARCHAR(50) ,
	@Version VARCHAR(50) ,
	@Agreement_Date DATETIME ,
	@Deal_Description NVARCHAR(250) ,
	@Status CHAR(1) ,
	@Total_Sale float ,
	@Year_Type CHAR(2) ,
	@Customer_Type INT ,
	@Vendor_Code INT ,
	@Vendor_Contact_Code INT ,
	@Sales_Agent_Code INT ,
	@Sales_Agent_Contact_Code INT ,
	@Entity_Code INT ,
	@Currency_Code INT ,
	@Exchange_Rate numeric(10, 3) ,
	@Ref_No NVARCHAR(50) ,
	@Attach_Workflow CHAR(1) ,
	@Deal_Workflow_Status VARCHAR(50) ,
	@Work_Flow_Code INT ,
	@Is_Completed CHAR(1) ,
	@Category_Code INT ,
	@Parent_Syn_Deal_Code INT ,
	@Is_Migrated CHAR(1) ,
	@Payment_Terms_Conditions NVARCHAR(4000) ,
	@Deal_Tag_Code INT ,
	@Ref_BMS_Code VARCHAR(100) ,
	@Remarks NVARCHAR(4000) ,
	@Rights_Remarks NVARCHAR(4000) ,
	@Payment_Remarks NVARCHAR(4000) ,
	@Is_Active CHAR(1) ,
	@Inserted_On DATETIME ,
	@Inserted_By INT ,
	@Lock_Time DATETIME ,
	@Last_Updated_Time DATETIME ,
	@Last_Action_By INT 
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 27-October-2014
-- Description:	Updates SYN Deal Call From EF Table Mapping
-- =============================================
BEGIN
UPDATE [Syn_Deal]
   SET [Deal_Type_Code] = @Deal_Type_Code
      ,[Business_Unit_Code] = @Business_Unit_Code
      ,[Other_Deal] = @Other_Deal
      ,[Agreement_No] = @Agreement_No
      ,[Version] = @Version
      ,[Agreement_Date] = @Agreement_Date
      ,[Deal_Description] = @Deal_Description
      ,[Status] = @Status
      ,[Total_Sale] = @Total_Sale
      ,[Year_Type] = @Year_Type
      ,[Customer_Type] = @Customer_Type
      ,[Vendor_Code] = @Vendor_Code
      ,[Vendor_Contact_Code] = @Vendor_Contact_Code
      ,[Sales_Agent_Code] = @Sales_Agent_Code
      ,[Sales_Agent_Contact_Code] = @Sales_Agent_Contact_Code
      ,[Entity_Code] = @Entity_Code
      ,[Currency_Code] = @Currency_Code
      ,[Exchange_Rate] = @Exchange_Rate
      ,[Ref_No] = @Ref_No
      ,[Attach_Workflow] = @Attach_Workflow
      ,[Deal_Workflow_Status] = @Deal_Workflow_Status
      ,[Work_Flow_Code] = @Work_Flow_Code
      ,[Is_Completed] = @Is_Completed
      ,[Category_Code] = @Category_Code
      ,[Parent_Syn_Deal_Code] = @Parent_Syn_Deal_Code
      ,[Is_Migrated] = @Is_Migrated
      ,[Payment_Terms_Conditions] = @Payment_Terms_Conditions
      ,[Deal_Tag_Code] = @Deal_Tag_Code
      ,[Ref_BMS_Code] = @Ref_BMS_Code
      ,[Remarks] = @Remarks
      ,[Rights_Remarks] = @Rights_Remarks
      ,[Payment_Remarks] = @Payment_Remarks
      ,[Is_Active] = @Is_Active
      --,[Inserted_On] = @Inserted_On
      --,[Inserted_By] = @Inserted_By
      ,[Lock_Time] = @Lock_Time
      ,[Last_Updated_Time] = @Last_Updated_Time
      ,[Last_Action_By] = @Last_Action_By
  WHERE Syn_Deal_Code = @Syn_Deal_Code
END