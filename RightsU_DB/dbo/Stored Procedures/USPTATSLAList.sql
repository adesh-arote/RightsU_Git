CREATE PROCEDURE [dbo].[USPTATSLAList]  
(  
	 @TATSLACode INT = 0,  
	 @Action VARCHAR(10) = ''  
)  
  
AS  
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPTATSLAList]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(OBJECT_ID('TEMPDB..#TempData') IS NOT NULL)  
		DROP TABLE #TempData  
  
		CREATE Table #TempData  
		(  
			  TATSLAStatusName VARCHAR(MAX),  
			  SLA1FromDays INT,  
			  SLA1ToDays INT,  
			  SLA1Users VARCHAR(MAX),  
			  SLA2FromDays INT,  
			  SLA2ToDays INT,  
			  SLA2Users VARCHAR(MAX),  
			  SLA3FromDays INT,  
			  SLA3ToDays INT,  
			  SLA3Users VARCHAR(MAX),  
			  TATSLAMatixCodes NVARCHAR(MAX)  
		)  
  
		If(@Action = 'List')  
		BEGIN   
		INSERT INTO #TempData  
		(  
			TATSLAStatusName, SLA1FromDays, SLA1ToDays, SLA1Users, SLA2FromDays, SLA2ToDays, SLA2Users, SLA3FromDays, SLA3ToDays, SLA3Users, TATSLAMatixCodes  
		)   
			  Select DISTINCT  
			  TS.TATSLAStatusName,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1ToDays,  
			  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
			  INNER JOIN Users U  (NOLOCK) ON U.Users_Code = TMD.UserCode  
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
				  ).value('/MyString[1]','nvarchar(max)')     
				 , 1, 1, '') As SLA1Users,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2ToDays,  
			  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
			  INNER JOIN Users U (NOLOCK) ON U.Users_Code = TMD.UserCode  
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
				  ).value('/MyString[1]','nvarchar(max)')     
				 , 1, 1, '') As SLA2Users,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3ToDays,  
			  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
			  INNER JOIN Users U (NOLOCK) ON U.Users_Code = TMD.UserCode  
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
				  ).value('/MyString[1]','nvarchar(max)')     
				 , 1, 1, '') As SLA3Users,  
			  STUFF((select ','+CAST(TM1.TATSLAMatrixCode as nvarchar(max)) from TATSLAMatrix TM1 (NOLOCK) where TM1.TATSLACode = TM.TATSLACode and TM1.TATSLAStatusCode = TM.TATSLAStatusCode  
			  For XML PATH('') ),1,1, '') As TATSLAMatixCodes   
			  FROM TATSLAMatrix TM  (NOLOCK)  
			  LEFT JOIN TATSLAStatus TS (NOLOCK) ON TS.TATSLAStatusCode = TM.TATSLAStatusCode  
			  Where  @TATSLACode = 0 OR TM.TATSLACode = @TATSLACode  
		 END  
		If(@Action = 'Edit')  
		BEGIN  
			  INSERT INTO #TempData  
			  (  
			   TATSLAStatusName, SLA1FromDays, SLA1ToDays, SLA1Users, SLA2FromDays, SLA2ToDays, SLA2Users, SLA3FromDays, SLA3ToDays, SLA3Users, TATSLAMatixCodes  
			  )   
			  Select DISTINCT  
			  TS.TATSLAStatusName,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1ToDays,  
			  STUFF(( select ','+CAST(TMD.UserCode as VARCHAR(MAX)) from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode    
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')   
				 ), 1, 1, '') As SLA1Users,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2ToDays,  
			  STUFF(( select ',' +CAST(TMD.UserCode as VARCHAR(MAX)) from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode    
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')         
					 ), 1, 1, '') As SLA2Users,  
			  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3FromDays,  
			  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 (NOLOCK) Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3ToDays,  
			  STUFF(( select ',' +CAST(TMD.UserCode AS VARCHAR(MAX)) from TATSLAMatrixDetails TMD (NOLOCK) INNER JOIN TATSLAMatrix TM1 (NOLOCK) ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
			  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')   
				 ), 1, 1, '') As SLA3Users,  
				 STUFF((select ','+CAST(TM1.TATSLAMatrixCode as nvarchar(max)) from TATSLAMatrix TM1 (NOLOCK) where TM1.TATSLACode = TM.TATSLACode and TM1.TATSLAStatusCode = TM.TATSLAStatusCode  
			  For XML PATH('') ),1,1, '') As TATSLAMatixCodes  
			  FROM TATSLAMatrix TM    (NOLOCK)
			  LEFT JOIN TATSLAStatus TS (NOLOCK) ON TS.TATSLAStatusCode = TM.TATSLAStatusCode  
			  Where TM.TATSLACode = @TATSLACode  
  
		END   
	  Select TATSLAStatusName, SLA1FromDays, SLA1ToDays, SLA1Users, SLA2FromDays, SLA2ToDays, SLA2Users, SLA3FromDays, SLA3ToDays, SLA3Users, TATSLAMatixCodes from #TempData  

	  IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
  
	if(@Loglevel< 2) Exec [USPLogSQLSteps] '[USPTATSLAList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END