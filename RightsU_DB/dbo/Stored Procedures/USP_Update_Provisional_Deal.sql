CREATE PROC [USP_Update_Provisional_Deal]                  
(                  
 @Provisional_Deal_Code INT                
,@Agreement_Date DATETIME                  
,@Version VARCHAR(50)                  
,@Business_Unit_Code INT                    
,@Content_Type  NVARCHAR(25)                 
,@Entity_Code INT                  
,@Deal_Desc NVARCHAR(4000)                  
,@Deal_Type_Code INT                  
,@Deal_Workflow_Status NVARCHAR(25)                  
,@Right_Start_Date DATETIME                  
,@Right_End_Date DATETIME                  
,@Term VARCHAR(12)                  
,@Remarks NVARCHAR(4000)                  
,@Last_Action_By INT            
,@Lock_Time DATETIME              
)                  
AS                  
BEGIN        
 --SET XACT_ABORT OFF             
 SET NOCOUNT ON              
  --BEGIN TRY                    
  --BEGIN TRANSACTION;                      
                  
 UPDATE Provisional_Deal                   
 SET [Version] = @Version,                  
  [Content_Type] = @Content_Type,                  
  [Agreement_Date] = @Agreement_Date,                  
  [Deal_Type_Code] = @Deal_Type_Code,                  
  [Entity_Code] = @Entity_Code,                  
  [Deal_Workflow_Status] = @Deal_Workflow_Status,                  
  [Business_Unit_Code] = @Business_Unit_Code,                  
  [Remarks] = @Remarks,                  
  [Deal_Desc] = @Deal_Desc,                  
  [Right_Start_Date] = @Right_Start_Date,                  
  [Right_End_Date] = @Right_End_Date,                  
  [Term] = @Term,                  
  [Last_Updated_Time] = GETDATE(),                  
  [Last_Action_By] = @Last_Action_By,            
  [Lock_Time]  = null             
 WHERE Provisional_Deal_Code = @Provisional_Deal_Code  
  
  IF NOT EXISTS(Select * from Process_Provisional_Deal WHERE Provisional_Deal_Code = @Provisional_Deal_Code AND Record_Status ='P')
	 INSERT INTO Process_Provisional_Deal(Provisional_Deal_Code, Record_Status, Created_On)    
	 SELECT @Provisional_Deal_Code,'P',GETDATE()
END