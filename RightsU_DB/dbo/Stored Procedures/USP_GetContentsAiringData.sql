CREATE PROC [dbo].[USP_GetContentsAiringData]  
(  
 @Title_Content_Code BIGINT =1,  
 @Start_Date VARCHAR(20) = '',  
 @End_Date VARCHAR(20) ='',  
 @Version_ID VARCHAR(500) = '',  
 @Channel_Codes VARCHAR(1000) =''   
)  
AS   
-- =============================================  
-- Author:  Abhaysingh N. Rajpurohit 
-- Create date: 11 January 2017  
-- Description: Get Content Airing data  
-- =============================================  
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsAiringData]', 'Step 1', 0, 'Started Procedure', 0, '' 
 
		 SELECT X.Airing_Date, X.Airing_Time, X.Channel_Code, X.Channel_Name, x.Version_Code, V.Version_Name, X.IsIgnore, ISNULL(X.Play_Day,0) AS Play_Day, ISNULL(X.Play_Run,0) AS Play_Run,X.Error   
		 from Version V (NOLOCK) INNER JOIN  
		 (SELECT   
		  Convert(varchar(10),Convert(datetime,BST.Schedule_Item_Log_Date),103) [Airing_Date],   
		  Convert(VARCHAR(11),Convert(Time,BST.Schedule_Item_Log_Time)) [Airing_Time],   
		  C.Channel_Code, C.Channel_Name,   
		  (select TOP 1 Version_Code FROm Title_Content_Version TCV (NOLOCK) where TCV.Title_Content_Code =TC.Title_Content_Code ) AS Version_Code,  
		  CASE WHEN BST.IsIgnore = 'Y' THEN 'Yes' ELSE 'No' END AS IsIgnore,  
		  BST.Play_Day, BST.Play_Run, 
		  CASE WHEN ISNULL(BSE.Email_Notification_Msg_Code,0) = 0 THEN ''   
		  ELSE (select Msg.Email_Msg from Email_Notification_Msg Msg (NOLOCK) WHERE Msg.Email_Notification_Msg_Code = BSE.Email_Notification_Msg_Code) END [Error]  
		 FROM Title_Content TC (nolock)  
		 INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Title_Content_Code = TC.Title_Content_Code AND CCR.Title_Content_Code = @Title_Content_Code  
		 INNER JOIN BV_Schedule_Transaction BST (nolock) ON BST.Title_Code = CCR.Title_Code --BST.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code  
		 INNER JOIN Channel C (nolock) ON C.Channel_Code = BST.Channel_Code  
		 LEFT JOIN BMS_Schedule_Exception BSE (NOLOCK) ON BSE.BV_Schedule_Transaction_Code = BST.BV_Schedule_Transaction_Code  
		 WHERE   
		(BST.Channel_Code IN (select number from dbo.fn_Split_withdelemiter(@Channel_Codes,',')) OR @Channel_Codes = '')  
		 AND   
		 (  
		  (  
		   Convert(varchar(10),Convert(datetime,Schedule_Item_Log_Date),121) BETWEEN   
		   Convert(varchar(10),Convert(datetime,@Start_Date),121) AND Convert(varchar(10),Convert(datetime,@End_Date),121)  
		  )OR  
		  (ISNULL(@Start_Date, '') = '' AND ISNULL(@End_Date,'') = '')  
		 )  
		 ) AS X  
		 ON X.Version_Code = V.Version_Code  
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsAiringData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END