CREATE PROC [dbo].[USP_Insert_Provisional_Deal]              
(              
  @Agreement_Date DATETIME              
 ,@Version VARCHAR(50)              
 ,@Business_Unit_Code INT                
 ,@Content_Type NVARCHAR(25)              
 ,@Entity_Code INT                
 ,@Deal_Desc NVARCHAR(4000)              
 ,@Deal_Type_Code INT              
 ,@Deal_Workflow_Status NVARCHAR(25)              
 ,@Right_Start_Date DATETIME              
 ,@Right_End_Date DATETIME              
 ,@Term VARCHAR(12)              
 ,@Remarks NVARCHAR(4000)              
 ,@Is_Active CHAR(1)              
 ,@Inserted_By INT           
 ,@Last_Action_By INT        
 ,@Lock_Time DATETIME        
)              
AS              
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Provisional_Deal]', 'Step 1', 0, 'Started Procedure', 0, ''            
	 SET NOCOUNT ON          
	 BEGIN TRY                
	  BEGIN TRANSACTION;                  
	  INSERT INTO Provisional_Deal              
	  (              
	   [Agreement_No], [Version], [Content_Type], [Agreement_Date], [Deal_Type_Code],   
	   [Entity_Code], [Deal_WorkFlow_Status], [Is_Active], [Business_Unit_Code], [Remarks], [Deal_Desc], [Right_Start_Date], [Right_End_Date], [Term],              
	   [Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By], [Lock_Time]              
	  )              
	  Select [dbo].[UFN_Auto_Genrate_Agreement_No]('P', @Agreement_Date,0) [Agreement_No], @Version, @Content_Type, @Agreement_Date, @Deal_Type_Code,              
	   @Entity_Code, @Deal_Workflow_Status, @Is_Active, @Business_Unit_Code, @Remarks, @Deal_Desc, @Right_Start_Date, @Right_End_Date, @Term,              
	   @Inserted_By, GETDATE(), GETDATE(), @Last_Action_By, null  

	   DECLARE @Provisional_Deal_Code INT = SCOPE_IDENTITY()  
            
	  SELECT Provisional_Deal_Code, Agreement_No FROM Provisional_Deal (NOLOCK) WHERE Provisional_Deal_Code = @Provisional_Deal_Code 
  
	  --insertion in Process_Provisional_Deal for Data Generation------  
	  INSERT INTO Process_Provisional_Deal(Provisional_Deal_Code, Record_Status, Created_On)  
	   SELECT @Provisional_Deal_Code,'P',GETDATE()  
  
	  COMMIT TRANSACTION  
	 END TRY  
	 BEGIN CATCH                 
	 ROLLBACK TRANSACTION;                
	 END CATCH      
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Provisional_Deal]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''         
END
