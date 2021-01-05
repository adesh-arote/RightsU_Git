CREATE PROCEDURE USPTATSLAList  
(  
	 @TATSLACode INT = 0,  
	 @Action VARCHAR(10) = ''  
)  
  
AS  
BEGIN  
  
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
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1ToDays,  
		  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
		  INNER JOIN Users U ON U.Users_Code = TMD.UserCode  
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
			  ).value('/MyString[1]','nvarchar(max)')     
			 , 1, 1, '') As SLA1Users,  
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2ToDays,  
		  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
		  INNER JOIN Users U ON U.Users_Code = TMD.UserCode  
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
			  ).value('/MyString[1]','nvarchar(max)')     
			 , 1, 1, '') As SLA2Users,  
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3ToDays,  
		  STUFF(( select ',' +U.First_Name from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
		  INNER JOIN Users U ON U.Users_Code = TMD.UserCode  
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH(''),root('MyString'), type     
			  ).value('/MyString[1]','nvarchar(max)')     
			 , 1, 1, '') As SLA3Users,  
		  STUFF((select ','+CAST(TM1.TATSLAMatrixCode as nvarchar(max)) from TATSLAMatrix TM1 where TM1.TATSLACode = TM.TATSLACode and TM1.TATSLAStatusCode = TM.TATSLAStatusCode  
		  For XML PATH('') ),1,1, '') As TATSLAMatixCodes   
		  FROM TATSLAMatrix TM   
		  LEFT JOIN TATSLAStatus TS ON TS.TATSLAStatusCode = TM.TATSLAStatusCode  
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
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA1ToDays,  
		  STUFF(( select ','+CAST(TMD.UserCode as VARCHAR(MAX)) from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode    
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=1 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')   
			 ), 1, 1, '') As SLA1Users,  
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA2ToDays,  
		  STUFF(( select ',' +CAST(TMD.UserCode as VARCHAR(MAX)) from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode    
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=2 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')         
				 ), 1, 1, '') As SLA2Users,  
		  (select TOP 1 TM1.FromDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3FromDays,  
		  (select TOP 1 TM1.ToDay from TATSLAMatrix TM1 Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode) SLA3ToDays,  
		  STUFF(( select ',' +CAST(TMD.UserCode AS VARCHAR(MAX)) from TATSLAMatrixDetails TMD INNER JOIN TATSLAMatrix TM1 ON TM1.TATSLAMatrixCode =TMD.TATSLAMatrixCode  
		  Where TM1.TATSLACode = TM.TATSLACode and TM1.LevelNo=3 and TM1.TATSLAStatusCode = TM.TATSLAStatusCode FOR XML PATH('')   
			 ), 1, 1, '') As SLA3Users,  
			 STUFF((select ','+CAST(TM1.TATSLAMatrixCode as nvarchar(max)) from TATSLAMatrix TM1 where TM1.TATSLACode = TM.TATSLACode and TM1.TATSLAStatusCode = TM.TATSLAStatusCode  
		  For XML PATH('') ),1,1, '') As TATSLAMatixCodes  
		  FROM TATSLAMatrix TM   
		  LEFT JOIN TATSLAStatus TS ON TS.TATSLAStatusCode = TM.TATSLAStatusCode  
		  Where TM.TATSLACode = @TATSLACode  
  
	END   
  Select TATSLAStatusName, SLA1FromDays, SLA1ToDays, SLA1Users, SLA2FromDays, SLA2ToDays, SLA2Users, SLA3FromDays, SLA3ToDays, SLA3Users, TATSLAMatixCodes from #TempData  

  IF OBJECT_ID('tempdb..#TempData') IS NOT NULL DROP TABLE #TempData
END  
  
--select * from TATSLA  
----INSERT INTO TATSLA(TATSLAName,BusinessUnitCode,DealTypeCode,IsActive,InsertedOn,InsertedBy)  
----select 'SLA For Movie',1,1,'Y',GETDATE(),143  
--select * from TATSLAMatrixDetails  
  
--INSERT INTO TATSLAMatrix(TATSLACode,TATSLAStatusCode,LevelNo,FromDay,ToDay,InsertedOn,InsertedBy)  
--select 3,3,1,1,2,GETDATE(),143  
--select 3,3,2,3,4,GETDATE(),143  
--select 3,3,3,4,5,GETDATE(),143  
  
-- select * from TATSLAMatrix  
--select * from TATSLAMatrixDetails  
--INSERT INTO TATSLAMatrixDetails  
--Values(11,176,GETDATE(),143,null,null)  
--select * from Users  
  
--exec USPTATSLAList 3,'Edit'  