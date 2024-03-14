CREATE PROCEDURE [dbo].[USP_INSERT_SYN_DEAL]  
(   
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
 @Payment_Terms_Conditions NVARCHAR(400) ,  
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
 @Last_Action_By INT ,  
 @Deal_Segment_Code INT,  
 @Revenue_Vertical_Code INT,
 @Material_Remarks NVARCHAR(400)
)  
AS  
-- =============================================  
-- Author:  Pavitar Dua  
-- Create DATE: 27-October-2014  
-- Description: Inserts Syn Deal Call From EF Table Mapping  
-- =============================================   
BEGIN  
 Declare @Loglevel int;  
  
 select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'  
  
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_SYN_DEAL]', 'Step 1', 0, 'Started Procedure', 0, ''  
 INSERT INTO [Syn_Deal]  
      --([Agreement_No]  
      ([Deal_Type_Code]  
      ,[Business_Unit_Code]  
      ,[Other_Deal]  
      ,[Version]  
      ,[Agreement_Date]  
      ,[Deal_Description]  
      ,[Status]  
      ,[Total_Sale]  
      ,[Year_Type]  
      ,[Customer_Type]  
      ,[Vendor_Code]  
      ,[Vendor_Contact_Code]  
      ,[Sales_Agent_Code]  
      ,[Sales_Agent_Contact_Code]  
      ,[Entity_Code]  
      ,[Currency_Code]  
      ,[Exchange_Rate]  
      ,[Ref_No]  
      ,[Attach_Workflow]  
      ,[Deal_Workflow_Status]  
      ,[Work_Flow_Code]  
      ,[Is_Completed]  
      ,[Category_Code]  
      ,[Parent_Syn_Deal_Code]  
      ,[Is_Migrated]  
      ,[Payment_Terms_Conditions]  
      ,[Deal_Tag_Code]  
      ,[Ref_BMS_Code]  
      ,[Remarks]  
      ,[Rights_Remarks]  
      ,[Payment_Remarks]  
      ,[Is_Active]  
      ,[Deal_Complete_Flag]  
      ,[Inserted_On]  
      ,[Inserted_By]  
      ,[Lock_Time]  
      ,[Last_Updated_Time]  
      ,[Last_Action_By]  
      ,[Deal_Segment_Code]  
      ,[Revenue_Vertical_Code]
	  ,[Material_Remarks])  
   --SELECT [dbo].[UFN_Auto_Genrate_Agreement_No]('S', @Agreement_Date, 0) [Agreement_No]  
       SELECT
	   @Deal_Type_Code  
      ,@Business_Unit_Code  
      ,@Other_Deal             
      ,@Version  
      ,@Agreement_Date  
      ,@Deal_Description  
      ,@Status  
      ,@Total_Sale  
      ,@Year_Type  
      ,@Customer_Type  
      ,@Vendor_Code  
      ,@Vendor_Contact_Code  
      ,@Sales_Agent_Code  
      ,@Sales_Agent_Contact_Code  
      ,@Entity_Code  
      ,@Currency_Code  
      ,@Exchange_Rate  
      ,@Ref_No  
      ,@Attach_Workflow  
      ,@Deal_Workflow_Status  
      ,@Work_Flow_Code  
      ,@Is_Completed  
      ,@Category_Code  
      ,@Parent_Syn_Deal_Code  
      ,@Is_Migrated  
      ,@Payment_Terms_Conditions  
      ,@Deal_Tag_Code  
      ,@Ref_BMS_Code  
      ,@Remarks  
      ,@Rights_Remarks  
      ,@Payment_Remarks  
      ,@Is_Active  
      ,(Select Parameter_Value From System_Parameter_New Where Parameter_Name = 'Deal_Complete_Flag')  
      ,GETDATE()  
      ,@Inserted_By  
      ,@Lock_Time  
      ,GETDATE()  
      ,@Last_Action_By  
      ,@Deal_Segment_Code  
      ,@Revenue_Vertical_Code  
      ,@Material_Remarks
	   
      SELECT Syn_Deal_Code,Agreement_No  
      FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code=SCOPE_IDENTITY()  
       
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_INSERT_SYN_DEAL]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''  
END
