CREATE PROC [dbo].[USP_Syn_Rights_Autopush_Delete_Validation]  
(  
 @SynDealRightsCode INT  
)  
AS  
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Rights_Autopush_Delete_Validation]', 'Step 1', 0, 'Started Procedure', 0, '' 
 
		 DECLARE  
		 --@SynDealRightsCode INT = 1674,   
		 @ISERROR CHAR(1),  
		 @NewAcqDealRightsCode_S INT  
  
		 IF EXISTS(SELECT TOP 1 SecondaryDataCode FROM AcqPreReqMappingData (NOLOCK)  WHERE PrimaryDataCode = @SynDealRightsCode)  
		 BEGIN  
		  PRINT 'CHECK FOR VALIDATION'  
		  SELECT TOP 1 @NewAcqDealRightsCode_S = SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD (NOLOCK)  WHERE MD.MappingFor = 'ACQDEALRIGHTS' AND PrimaryDataCode = @SynDealRightsCode  
    
  
		  IF(OBJECT_ID('TEMPDB..#SynDealRights') IS NOT NULL)  
		  DROP TABLE #SynDealRights  
		  CREATE TABLE #SynDealRights(DestSynDealRightSCode INT)  
  
		  INSERT INTO #SynDealRights(DestSynDealRightSCode)  
		  SELECT Syn_Deal_Rights_Code  
		  FROM RightsU_Broadcast.dbo.Syn_Acq_Mapping (NOLOCK)  WHERE Deal_Rights_Code = @NewAcqDealRightsCode_S  
  
		  IF EXISTS(SELECT *  FROM #SynDealRights)  
		  BEGIN  
		   SET @ISERROR = 'Y'  
		  END  
		  ELSE  
		  BEGIN  
		   SET @ISERROR = 'N'  
		  END  
		 END  
		 ELSE  
		 BEGIN  
		  PRINT 'NO VALIDATION'  
		  SET @ISERROR = 'N'  
		 END  
		 Select @ISERROR  

		 IF OBJECT_ID('tempdb..#SynDealRights') IS NOT NULL DROP TABLE #SynDealRights
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Rights_Autopush_Delete_Validation]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END