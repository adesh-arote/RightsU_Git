CREATE PROCEDURE [dbo].[USP_Music_Assignment_Audit_Report_Test]   
@User_Id varchar(100),  
@Date_From varchar(50),  
@Date_To varchar(50)  
AS   
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Assignment_Audit_Report_Test]', 'Step 1', 0, 'Started Procedure', 0, ''
	 SELECT   
	   convert(datetime,REPLACE(CONVERT(VARCHAR(11),CAST(CML.Inserted_On as date),106), ' ', '-'),120) AS CONTENT_DATE,   
	  FORMAT(CONVERT(DATE,CML.Inserted_On,103), 'dddd') AS CONTENT_DAY,  
	  U.Login_Name AS USERS_NAME, COUNT(CML.Music_Title_Code) AS Total_Count   
	 FROM Content_Music_Link CML (NOLOCK) 
	 INNER JOIN Users U (NOLOCK)  ON CML.Inserted_By = U.Users_Code  
	 WHERE   
	  ((@Date_From <> '' AND CONVERT(DATE, CML.Inserted_On,103) >= CONVERT(DATE, @Date_From,103)) OR @Date_From = '')  
		 AND ((@Date_To <> '' AND CONVERT(DATE,CML.Inserted_On,103) <= CONVERT(DATE,@Date_To,103)) OR @Date_To = '')  
	  OR CML.Inserted_By IN((SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@User_Id, ',') WHERE NUMBER <> ''))  
	 GROUP BY  convert(datetime,REPLACE(CONVERT(VARCHAR(11),CAST(CML.Inserted_On as date),106), ' ', '-'),120) , U.Login_Name, FORMAT(CONVERT(DATE,CML.Inserted_On,103), 'dddd')  
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Assignment_Audit_Report_Test]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
