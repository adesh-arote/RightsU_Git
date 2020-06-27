alter PROCEDURE [dbo].[USP_Music_Usage_Report]  
(  
	 @Title_Code VARCHAR(500)='', @Channel VARCHAR(500)='', @StartDate VARCHAR(12), @EndDate VARCHAR(12), @TitleType VARCHAR(500)='', @Genre VARCHAR(500)='',  
	 @MusicLabel VARCHAR(500)='', @StarCast VARCHAR(500)='', @Theme VARCHAR(500)='', @BuCode VARCHAR(100)='', @EpisodeFrom INT,
	 @EpisodeTo INT
)  
AS  
/*=============================================  
Author:			Anchal Sikarwar  
Create DATE:	12 Aug, 2016  
Description:	Consumption Report - Embedded Music   
=============================================*/
BEGIN  
	--DECLARE 
	--@Title_Code VARCHAR(500)='', @Channel VARCHAR(500)='', @StartDate VARCHAR(10), @EndDate VARCHAR(10),@TitleType VARCHAR(500)='',@Genre VARCHAR(500)='',  
	--@MusicLabel VARCHAR(500)='',@StarCast VARCHAR(500)='',@Theme VARCHAR(500)='',@BuCode VARCHAR(100)='',@EpisodeFrom	INT,
	--@EpisodeTo INT  

	IF(OBJECT_ID('tempdb..#TEMP') IS NOT NULL)  
		DROP TABLE #TEMP
	
	IF(OBJECT_ID('tempdb..#Talent') IS NOT NULL)  
		DROP TABLE #Talent  

	CREATE TABLE #TEMP  
	(  
		Title_Name NVARCHAR(500),  
		Episode_No INT,   
		Version_Name NVARCHAR(500),  
		Airing_Date DATETIME,
		Channel NVARCHAR(500),  
		Music_Track NVARCHAR(500),  
		Album NVARCHAR(500),   
		Music_Label NVARCHAR(500),  
		Singer NVARCHAR(MAX),  
		Music_Composer NVARCHAR(MAX),  
		Lyricist NVARCHAR(MAX),  
		Music_Track_Duration VARCHAR(500),  
		Title_Duration  VARCHAR(500),  
		Genres_Name  NVARCHAR(500),  
		Star_Cast  NVARCHAR(MAX),  
		Music_Type NVARCHAR(500),  
		Music_Theme_Name NVARCHAR(500),
		Program_Name NVARCHAR(MAX),
		TC_IN VARCHAR(500),
		TC_OUT VARCHAR(500)
	)  

	SELECT TA.Talent_Name, MTT.Music_Title_Code, MTT.Role_Code
	INTO #Talent
	FROM Music_Title_Talent MTT  
	INNER JOIN Role R ON R.Role_Code = MTT.Role_Code  
	INNER JOIN Talent TA ON MTT.Talent_Code=TA.Talent_Code  

	INSERT INTO #TEMP (
		Title_Name, Episode_No, Version_Name, Airing_Date, Channel, Music_Track, Album,Music_Label, 
		Music_Type, Genres_Name, Music_Track_Duration, Title_Duration,
		Singer, Music_Composer, Lyricist, Star_Cast, Music_Theme_Name ,Program_Name,TC_IN,TC_OUT 
	)  
	SELECT DISTINCT
		CASE WHEN ISNULL(TC.Episode_Title,'') = '' THEN T.Title_Name ELSE TC.Episode_Title END AS Title_Name, TC.Episode_No, V.Version_Name,
		--CONVERT(VARCHAR(12),FORMAT(Convert(datetime,BST.Schedule_Item_Log_Date,0),'dd-MMM-yyyy'),0) AS Airing_Date, 
		--CAST(BST.Schedule_Item_Log_Date AS DATETIME) AS Airing_Date,
		Convert(Datetime,(Convert(varchar(50),BST.Schedule_Item_Log_Date,106) + ' ' + Schedule_Item_Log_Time),120) AS Airing_Date, 
		C.Channel_Name, MT.Music_Title_Name, 
		CASE WHEN ISNULL(MT.Music_Album_Code, 0) = 0 THEN MT.Movie_Album ELSE MA.Music_Album_Name END Movie_Album, ML.Music_Label_Name, MTY.Music_Type_Name, 
		ISNULL(G.Genres_Name, '') AS Genres_Name,  
		CONVERT(VARCHAR,CML.[Duration],108) + ':' + CAST(CML.Duration_Frame AS VARCHAR) Music_Track_Duration,  
		CASE WHEN ISNULL(TC.Duration,'0') = 0 THEN T.Duration_In_Min ELSE TC.Duration END AS Title_Duration,  
		REVERSE( STUFF(REVERSE(STUFF((
			SELECT Tn.Talent_Name+', ' FROM #Talent Tn WHERE Tn.Role_Code=13 AND Tn.Music_Title_Code = MT.Music_Title_Code
			ORDER BY Tn.Talent_Name
			FOR XML PATH(''), root('Singer'), type  
		).value('/Singer[1]','Nvarchar(max)'),2,0, '')), 1, 2, '')) AS Singer,
		REVERSE(STUFF(REVERSE(STUFF((
			SELECT Tn.Talent_Name+', ' FROM #Talent Tn WHERE Tn.Role_Code=21 AND Tn.Music_Title_Code = MT.Music_Title_Code
			ORDER BY Tn.Talent_Name
			FOR XML PATH(''), root('Music_Composer'), type  
		).value('/Music_Composer[1]','Nvarchar(max)'),2,0, '')), 1, 2, ''))  AS Music_Composer,  
		REVERSE(STUFF(REVERSE(STUFF((
			SELECT Tn.Talent_Name+', ' FROM #Talent Tn WHERE Tn.Role_Code=15 AND Tn.Music_Title_Code = MT.Music_Title_Code
			ORDER BY Tn.Talent_Name
			FOR XML PATH(''), root('Lyricist'), type  
		).value('/Lyricist[1]','Nvarchar(max)'),2,0, '')), 1, 2, ''))  AS Lyricist,  
		REVERSE(STUFF(REVERSE(STUFF((
			SELECT Tn.Talent_Name+', ' FROM #Talent Tn WHERE Tn.Role_Code=2 AND Tn.Music_Title_Code = MT.Music_Title_Code
			ORDER BY Tn.Talent_Name
			FOR XML PATH('')
		),1,0, '')),1,2,'')) AS Star_Cast,  
		REVERSE(STUFF(REVERSE(STUFF((   
			SELECT CAST(MT1.Music_Theme_Name  AS NVARCHAR(MAX)) + ', '   
			FROM Music_Title_Theme MTT3  
			INNER JOIN Music_Theme MT1 ON MT1.Music_Theme_Code=MTT3.Music_Theme_Code  
			WHERE MTT3.Music_Title_Code = MT.Music_Title_Code    
			ORDER BY MT1.Music_Theme_Name 			 
			FOR XML PATH('')
		),1,0, '')),1,2,'')) AS Music_Theme_Name ,
		P.Program_Name as [Progarm Name],
		CONVERT(VARCHAR,CML.[From],108) + ':' + CAST(CML.From_Frame AS VARCHAR) TC_IN,  
		CONVERT(VARCHAR,CML.[To],108) + ':' + CAST(CML.To_Frame AS VARCHAR) TC_OUT
	FROM   
		Content_Music_Link CML  
		INNER JOIN Title_Content TC ON TC.Title_Content_Code = CML.Title_Content_Code 
		INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code AND TCV.Title_Content_Code = TC.Title_Content_Code
		INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code

		--INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
		--INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code  
		 
		INNER JOIN Content_Channel_Run CCR ON CCR.Title_Content_Code = TC.Title_Content_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code  
		INNER JOIN Title T ON T.Title_Code = CCR.Title_Code   
		INNER JOIN Music_Title MT ON MT.Music_Title_Code = CML.Music_Title_Code  
		INNER JOIN Music_Title_Label MTL ON MTL.Music_Title_Code=MT.Music_Title_Code  
		LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
		LEFT JOIN Music_Type MTY ON MT.Music_Type_Code=MTY.Music_Type_Code  
		LEFT JOIN Program P ON T.Program_Code = P.Program_Code
		LEFT JOIN Music_Title_Theme MTT ON MTT.Music_Title_Code = MT.Music_Title_Code  
		LEFT JOIN BV_Schedule_Transaction BST ON Tc.Title_Code = BST.Title_Code AND TC.Episode_No = BST.Program_Episode_Number  
		AND IsNull(BST.IsRevertCnt_OnAsRunLoad,'N') = 'N'  
		AND ((@Channel<>'' AND BST.Channel_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Channel +'',','))) OR @Channel='')  
		AND ((@StartDate<>'' AND @EndDate <> '' AND CONVERT(DATE,BST.Schedule_Item_Log_Date,103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103))   
		OR (@StartDate<>'' AND @EndDate = '' AND CONVERT(DATE,BST.Schedule_Item_Log_Date,103) >= CONVERT(DATE,@StartDate,103))   
		OR (@StartDate='' AND @EndDate <> '' AND CONVERT(DATE,BST.Schedule_Item_Log_Date,103) <= CONVERT(DATE,@EndDate,103))  
		OR (ISNULL(@StartDate, '') = '' AND ISNULL(@EndDate, '') = ''))  
		AND CONVERT(DATE,BST.Schedule_Item_Log_Date,103) BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, GETDATE())   
		LEFT JOIN Channel C ON C.channel_code = BST.Channel_Code  
		LEFT JOIN Genres G ON G.Genres_Code = MT.Genres_Code  
		LEFT JOIN Music_Label ML ON MTL.Music_Label_Code = ML.Music_Label_Code   
	WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND (@Title_Code='' OR (@Title_Code<>''AND TC.Title_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Title_Code +'',','))))  
		AND (@MusicLabel='' OR @MusicLabel='0' OR ML.Music_Label_Code in (SELECT number FROM dbo.fn_Split_withdelemiter('' + @MusicLabel +'',',')))  
		AND (@Genre = '' OR @Genre = '0' OR MT.Genres_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter('' + @Genre + '',',')))  
		AND (@TitleType = '' OR @TitleType = '0' OR MT.Music_Type_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter('' + @TitleType + '',',')) )  
		AND (@Theme = '' OR @Theme='0' OR MTT.Music_Theme_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter('' + @Theme +'',','))  )
		AND (@BuCode = '' OR (AD.Business_Unit_Code=CONVERT(int,@BuCode)))  
		AND (Episode_No >= ISNULL(@EpisodeFrom, 0) OR ISNULL(@EpisodeFrom, 0) = 0) AND (Episode_No <= ISNULL(@EpisodeTo, 0)  OR ISNULL(@EpisodeTo, 0) = 0 )
		AND IsNull(CONVERT(DATE,BST.Schedule_Item_Log_Date,103), getdate()) BETWEEN MTL.Effective_From AND ISNULL(MTL.Effective_To, GETDATE())   
		AND (MT.Music_Title_Code IN 
		(SELECT MTT_TMP.Music_Title_Code FROM Music_Title_Talent MTT_TMP WHERE MTT_TMP.Talent_Code IN 
		(SELECT number FROM dbo.fn_Split_withdelemiter('' + @StarCast +'',','))) OR @StarCast = '' OR @StarCast='0' ) 

	SELECT * FROM #TEMP ORDER BY Title_Name, Episode_No
	
END  

--select * from Title Where Title_Name IN('SAAT PHERON KI HERA PHERIE','SUPER DANCER -  CHAPTER 2')