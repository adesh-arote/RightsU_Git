
BEGIN

	DECLARE @Is_Allow_Perpetual_Date_Logic CHAR(1) = 'N',  @Perpertuity_Term_In_Year INT

	SELECT @Is_Allow_Perpetual_Date_Logic = Parameter_Value from System_Parameter_New where Parameter_Name = 'Is_Allow_Perpetual_Date_Logic'
	SELECT @Perpertuity_Term_In_Year = Parameter_Value from System_Parameter_New where Parameter_Name = 'Perpertuity_Term_In_Year'

	IF(@Is_Allow_Perpetual_Date_Logic = 'Y')
	BEGIN
			SELECT * FROM Acq_Deal_Rights ADR 
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code
			_Title WHERE Right_Type = 'U'
			SELECT * FROM Title_Release WHERE 

		
	END

END

select * from syn_Deal where Agreement_No = 'S-2019-00003'

	Select * from Acq_Deal AD
	Inner Join Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	Where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADM.Title_Code in (Select Title_Code from Syn_Deal_Movie Where Syn_Deal_Code = 46)
	and AD.Deal_Workflow_Status <> 'A'

	sp_helptext USP_Deal_Process


	CREATE PROCEDURE [dbo].[USP_Deal_Process]      
AS      
-- =============================================      
-- Author:  Akshay Rane      
-- Create date: 11 Oct 2017      
-- =============================================      
BEGIN      
 SET NOCOUNT ON      
 --W- Working In Progress      
 --E- Error      
 --D- Done      
 --p- Pending      
   
 DECLARE @RowNo INT = 0,@Error_Message VARCHAR(1000),@sql NVARCHAR(MAX),@DB_Name VARCHAR(1000),@Agreement_No VARCHAR(100);  
 SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process WHERE [Record_Status] = 'P'  
  
 WHILE(@RowNo > 0)  
 BEGIN  
  DECLARE @Is_Error char(1) = 'N', @Deal_Process_Code INT = 0, @Module_Code INT = 0,  @Deal_Code INT = 0, @EditWithoutApproval  CHAR(1) = '', @Action  CHAR(1) = '',  @Record_Status  CHAR(1) = '', @User_Code INT = 0  
  
  SELECT TOP 1 @Deal_Process_Code = Deal_Process_Code, @Module_Code = Module_Code, @Deal_Code = Deal_Code, @EditWithoutApproval = EditWithoutApproval, @Action = Action,  @Record_Status = Record_Status, @User_Code = User_Code  
  FROM Deal_Process WHERE Record_Status = 'P'  
      
  UPDATE Deal_Process SET [Record_Status] = 'W', Process_Start = GETDATE() WHERE Deal_Process_Code = @Deal_Process_Code  
  BEGIN TRY   
  
   IF(@Module_Code = 30)  
   BEGIN  
    IF(@Action = 'A')  
    BEGIN  
     SET @Error_Message = 'USP_AT_Acq_Deal'  
     EXEC [dbo].[USP_AT_Acq_Deal] @Deal_Code, @Is_Error OUT, @EditWithoutApproval  
  
     IF(@Is_Error <> 'N')  
     BEGIN  
      UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code  
  
      SELECT @Agreement_No = Agreement_No FROM Acq_Deal WHERE Acq_Deal_Code = @Deal_Code  
      INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)  
      SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error Generate in USP_AT_Acq_Deal','DB'   
       
      SELECT @sql = 'Agreement No : '+ @Agreement_No +' '+'in error state : - Error Generate in USP_AT_Acq_Deal'  
      SELECT @DB_Name = DB_Name()  
      EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'  
      PRINT 'TEST 1'  
     END  
     ELSE  
     BEGIN  
      UPDATE Deal_Process SET Record_Status  = 'D' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code  
     END  
    END  
    ELSE IF(@Action = 'R')  
    BEGIN  
     EXEC [dbo].[USP_RollBack_Acq_Deal] @Deal_Code, @User_Code, @EditWithoutApproval  
    END  
    SET @Error_Message = 'USP_Content_Channel_Run_Data_Generation'  
    EXEC USP_Content_Channel_Run_Data_Generation @Deal_Code  
    EXEC [dbo].[USP_Schedule_Run_Save_Process] @Deal_Code  
  
   END  
   ELSE IF(@Module_Code = 35)  
   BEGIN  
    IF(@Action = 'A')  
    BEGIN  
     SET @Error_Message = '[USP_AT_Syn_Deal]'  
     EXEC [dbo].[USP_AT_Syn_Deal] @Deal_Code, @Is_Error OUT  
     IF(@Is_Error <> 'N')  
     BEGIN  
      UPDATE Deal_Process SET Record_Status  = 'E' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code  
  
      -------INSERTION IN  ERROR LOG TABLE---------------------------------------------------------  
      SELECT @Agreement_No = Agreement_No FROM Syn_Deal WHERE Syn_Deal_Code = @Deal_Code  
      INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)  
      SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error Generate in USP_AT_Syn_Deal','DB'   
      ---change erro  
      SELECT @sql = 'Agreement No : '+ @Agreement_No +' '+'in error state : - Error Generate in USP_AT_Syn_Deal'  
      SELECT @DB_Name = DB_Name()  
      EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'  
     END  
     ELSE  
     BEGIN  
      UPDATE Deal_Process SET Record_Status  = 'D' , Porcess_End = GETDATE() WHERE  Deal_Process_Code = @Deal_Process_Code  
     END  
     EXEC [dbo].[USP_AutoPushAcqDeal] @Deal_Code, 143, '',''  
    END  
    ELSE IF(@Action = 'R')  
    BEGIN  
     EXEC [dbo].[USP_RollBack_Syn_Deal] @Deal_Code, @User_Code  
    END  
   END  
  
  END TRY        
  BEGIN CATCH      
   SELECT ERROR_MESSAGE()   
   PRINT 'CACTH testing'  
    SELECT @Agreement_No = Agreement_No FROM Acq_Deal WHERE Acq_Deal_Code = @Deal_Code  
     INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)  
     SELECT GETDATE(),null,null,'USP_Deal_Process','Agreement No : '+ @Agreement_No +' '+'in error state','NA','Error in '+@Error_Message,'DB'   
  
    Select * from UTO_ExceptionLog  
     
    SELECT @sql = 'Agreement No : '+ @Agreement_No +' '+'in error state. Error : -'+ ERROR_MESSAGE()  
    SELECT @DB_Name = DB_Name()  
    EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Deal_Process','AN','VN',@sql,'DB','IP','FR','TI'  
  END CATCH;      
  
  SELECT @RowNo = 0      
  SELECT TOP 1 @RowNo = COUNT(*) FROM Deal_Process WHERE Record_Status = 'P'      
 END     
END  
  
--exec USP_Deal_Process  

select * from syn_deal where agreement_no = 'S-2019-00003'
EXEC [dbo].[USP_AutoPushAcqDeal] 4051, 143, '',''  

--Procedure or function 'USP_INSERT_ACQ_DEAL' expects parameter '@Confirming_Party', which was not supplied.
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Acq_Deal_Movie_Title". The conflict occurred in database "RightsU_Broadcast", table "dbo.Title", column 'Title_Code'.
--select * from Acq_Deal where Agreement_No = 'A-2021-00190'
sp_help USP_INSERT_ACQ_DEAL

SELECT * FROM Acq_Deal 
SELECT * FROM  RightsU_Broadcast.dbo.Title T
							WHERE  T.Deal_Type_Code = 32
							SELECT * FROM Deal_Type


							SELECT * FROM RightsU_Broadcast.dbo.Title T
							WHERE T.Title_Name LIKE '%Boots%' AND T.Deal_Type_Code = 0
CREATE TABLE #SynDealMovieCode
						(
							SynDealMovieCode INT,
							DestAcqDealMovieCode INT,
							StatusFlag CHAR(1)
						)

							CREATE TABLE #CurrentTitles
					(
						Title_Code		INT,
						NewTitleCode	INT DEFAULT(0),
						Episode_From	INT,
						Episode_To	INT
					)
					select * from Title where title_code = 1359
					insert into #CurrentTitles select 1359	,0	,1	,10
					insert into  #SynDealMovieCode select 5639, 0,'I'
					
					INSERT INTO RightsU_Broadcast.dbo.Acq_Deal_Movie(
							Acq_Deal_Code, Title_Code, No_Of_Episodes, Title_Type, Episode_Starts_From, Episode_End_To
						)
	SELECT 10868, CT.NewTitleCode, SDM.No_Of_Episode, SDM.Syn_Title_Type, SDM.Episode_From, SDM.Episode_End_To
						FROM Syn_Deal_Movie SDM
						INNER JOIN #SynDealMovieCode SDMC ON SDMC.SynDealMovieCode = SDM.Syn_Deal_Movie_Code
						INNER JOIN #CurrentTitles CT ON SDM.Title_Code = CT.Title_Code AND SDM.Episode_From = CT.Episode_From AND SDM.Episode_End_To = CT.Episode_To
						WHERE SDM.Syn_Deal_Code = 4051 AND SDMC.StatusFlag = 'I'


						SELECT * FROM AcqPreReqMappingData WHERE MappingFor = 'DLTY'

						insert into AcqPreReqMappingData (MappingFor,PrimaryDataCode, SecondaryDataCode)
						select	  'DLTY', 31,31
						union all select 'DLTY', 32,32
						union all select 'DLTY', 33,33
						union all select 'DLTY', 34,34



						Select ADM.*, Ad.* from Acq_Deal AD
	Inner Join Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	Where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADM.Title_Code in (Select Title_Code from Syn_Deal_Movie Where Syn_Deal_Code = 46)
	and AD.Deal_Workflow_Status <> 'A'

	exec USP_Check_Acq_Deal_Status_For_Syn 46

	SELECT * FROM Title WHERE Title_Code IN (1424
,1428
,1440)