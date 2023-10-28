CREATE PROCEDURE [dbo].[USP_Users_Activity_Log_List]          
 @Generic_Search NVARCHAR(MAX),          
 @Sql NVARCHAR(MAX)          
AS            
BEGIN     
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'   
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Users_Activity_Log_List]', 'Step 1', 0, 'Started Procedure', 0, ''        
	 IF OBJECT_ID('tempdb..#Data') IS NOT NULL          
	 DROP TABLE #Data          
      
	--DECLARE @Sql NVARCHAR(MAX) = '', @Generic_Search NVARCHAR(MAX)=  ''      
            
	 CREATE TABLE #Data(          
	  Users_Name NVARCHAR(MAX),          
	  Module_Name NVARCHAR(MAX),          
	  Inserted_ON Varchar(MAx),          
	  Inserted_By INT,          
	  Record_Code INT,          
	  Json_Data NVARCHAR(MAX),      
	  User_Activity_Log_Code INT      
	  )          
          
	 Declare @Query NVARCHAR(MAX)= '';          
	 IF(@Generic_Search = '' AND @Sql = '')      
	 BEGIN      
	  SET @Query = 'INSERT INTO #Data          
	  SELECT U.Login_Name,UAL.Class_Name,UAL.Inserted_On,UAL.Inserted_By,UAL.Record_Code,UAL.Json_Data,UAL.Users_Activity_Log_Code FROM Users_Activity_Log UAL (NOLOCK)         
	  INNER JOIN Users U (NOLOCK) ON U.Users_Code = UAL.Inserted_BY  
	  where Command_Type <> ''GetById''
	  '           
	  PRINT(@Query)          
	  EXEC(@Query)       
	 END      
	 ELSE      
	 BEGIN      
	  SET @Query = 'INSERT INTO #Data          
	  SELECT U.Login_Name,UAL.Class_Name,UAL.Inserted_On,UAL.Inserted_By,UAL.Record_Code,UAL.Json_Data,UAL.Users_Activity_Log_Code FROM Users_Activity_Log UAL (NOLOCK)          
	  INNER JOIN Users U (NOLOCK) ON U.Users_Code = UAL.Inserted_BY    
  
	  WHERE 1=1  and Command_Type <> ''GetById''and '+@Sql+''           
	  PRINT(@Query)          
	  EXEC(@Query)          
	 END      
	 SELECT Users_Name,Module_Name,Inserted_ON AS Inserted_On,Inserted_By,ISNull(Record_Code,0) AS 'Record_Code',Json_Data,User_Activity_Log_Code FROM #Data     
   
	 IF OBJECT_ID('tempdb..#Data') IS NOT NULL          
	 DROP TABLE #Data          
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Users_Activity_Log_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''  
END