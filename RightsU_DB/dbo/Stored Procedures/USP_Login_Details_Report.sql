CREATE PROCEDURE [dbo].[USP_Login_Details_Report]      
      @StrSearch Varchar(Max),
      @PageNo Int,
      @OrderByCndition Varchar(100),
      @IsPaging VARCHAR(2),
      @PageSize INT,
      @RecordCount INT OUT    
AS
-- =============================================
-- Author:        Sagar Mahajan
-- Create date: 8 DEC 2014
-- Description:   To Get Data All Login And Logout USers
-- =============================================
BEGIN 
Declare @Loglevel int;
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Login_Details_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
      SET NOCOUNT ON;
      SET FMTONLY OFF

      CREATE TABLE #Temp(
            RowNum Int,
            IntCode Varchar(200),   
            first_name  NVARCHAR(200),
            middle_Name NVARCHAR(200),
            last_name NVARCHAR(200),
            login_name NVARCHAR(200),
            LoginTime DATETIME ,
            LogoutTime DATETIME,
            security_group_name NVARCHAR(200),
            duration INT
      );    
      DECLARE @SqlPageNo VARCHAR(MAX)=''  
      ;SET @SqlPageNo =
      'WITH Y AS (
      SELECT k = ROW_NUMBER() OVER (ORDER BY Login_Details_Code desc),LD.Login_Details_Code,first_name,middle_Name,last_name
      ,login_name,CONVERT(VARCHAR,LD.Login_Time,113) AS LoginTime, CONVERT(VARCHAR,LD.Logout_Time,113) AS LogoutTime,SG.security_group_name
      ,DATEDIFF(MI,Login_Time,Logout_Time) as duration
      FROM Login_Details LD (NOLOCK)
      INNER JOIN Users U (NOLOCK) ON U.users_code = LD.Users_Code
      INNER JOIN Security_Group SG (NOLOCK) ON U.security_group_code = SG.security_group_code
      WHERE 1 =1 '+ @StrSearch + '
      )
      INSERT INTO #Temp SELECT k, Login_Details_Code,first_name,middle_Name,last_name,login_name,LoginTime,LogoutTime,security_group_name,duration FROM Y'
      --PRINT @SqlPageNo
      EXEC(@SqlPageNo)  
      
      SELECT @RecordCount = Count(IntCode) FROM #Temp 
      
      If(@IsPaging = 'Y')
      BEGIN       
            Delete FROM #Temp WHERE RowNum < (((@PageNo - 1) * @PageSize) + 1) Or RowNum > @PageNo * @PageSize
      END         
      SELECT first_name,middle_Name,last_name,login_name,LoginTime,LogoutTime,security_group_name,duration
      FROM #Temp
      --DROP Table #Temp

      IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
      
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Login_Details_Report]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END