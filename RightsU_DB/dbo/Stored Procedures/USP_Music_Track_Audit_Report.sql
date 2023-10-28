CREATE PROCEDURE [dbo].[USP_Music_Track_Audit_Report]      
	@User_Id VARCHAR(1000),      
	@Date_From VARCHAR(50),      
	@Date_To VARCHAR(50),
	@SysLanguageCode INT
AS       
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Track_Audit_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE
		--@User_Id VARCHAR(1000)=1219,     
		--@Date_From VARCHAR(50)='',     
		--@Date_To VARCHAR(50)='',
		--@SysLanguageCode INT=1,
		@Col_Head01 NVARCHAR(MAX) = '',  
		@Col_Head02 NVARCHAR(MAX) = '',  
		@Col_Head03 NVARCHAR(MAX) = ''	

		SELECT U.Login_Name AS [User Name], convert(date,REPLACE(CONVERT(VARCHAR(11),MT.Inserted_On,106), ' ', '-'),120) As [Date],        
		COUNT(MT.Music_Title_Code) As [Music Track Added]   
		INTO #TempMusicTrackData
		FROM Music_Title MT  (NOLOCK)      
		INNER JOIN Users U (NOLOCK) ON U.Users_Code = MT.Inserted_By        
		WHERE         
		((@Date_From <> '' AND CONVERT(DATE, MT.Inserted_On,103) >= CONVERT(DATE, @Date_From,103)) OR @Date_From = '')        
		AND ((@Date_To <> '' AND CONVERT(DATE,MT.Inserted_On,103) <= CONVERT(DATE,@Date_To,103)) OR @Date_To = '')        
		AND 
		((MT.Inserted_By IN((SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@User_Id, ',') WHERE NUMBER <> '')) AND @User_Id <> '')
			OR @User_Id = '')
		GROUP BY convert(date,REPLACE(CONVERT(VARCHAR(11),MT.Inserted_On,106), ' ', '-'),120), U.Login_Name        
		ORDER BY U.Login_Name, Convert(date,REPLACE(CONVERT(VARCHAR(11),MT.Inserted_On,106), ' ', '-'),120)

		SELECT 
		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'UserName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
		 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Date' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
		 @Col_Head03 = CASE WHEN  SM.Message_Key = 'MusicTrackAdded' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END

		  FROM System_Message SM  (NOLOCK)
			 INNER JOIN System_Module_Message SMM (NOLOCK) ON SMM.System_Message_Code = SM.System_Message_Code  
			 AND SM.Message_Key IN ('UserName','Date','MusicTrackAdded')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

			IF EXISTS(SELECT TOP 1 * FROM #TempMusicTrackData)
			BEGIN
				 SELECT [User Name], [Date], [Music Track Added]
				 FROM (
					SELECT
					sorter = 1,
					CAST([User Name] AS NVARCHAR(MAX)) AS [User Name], 
					CAST([date] AS VARCHAR(100)) AS [Date], 
					CAST([Music Track Added] AS VARCHAR(100)) AS [Music Track Added]
					From #TempMusicTrackData
					UNION ALL
					  SELECT 0, @Col_Head01, @Col_Head02, @Col_Head03
					) X   
					ORDER BY Sorter
					END
					ELSE
			BEGIN
				SELECT * FROM #TempMusicTrackData
			END

				--DROP TABLE #TempMusicTrackData
				IF OBJECT_ID('tempdb..#TempMusicTrackData') IS NOT NULL DROP TABLE #TempMusicTrackData
			 
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_Music_Track_Audit_Report]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END