CREATE PROCEDURE [dbo].[USP_Last_Month_Utilization_Report]
(
	@Title_Codes VARCHAR(1000),
	@BU_Code INT,
	@Channel_Codes VARCHAR(1000)
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 16 Sept 2015
-- Description:	Last Month Utilization Report(Task ID - RightsU -3508)
-- =============================================
BEGIN	
	SET NOCOUNT ON;
	IF(@BU_Code = 0)
		SET  @BU_Code = 1
	------------------------------------------- DELETE TEMP TABLES -------------------------------------------	   	
	--IF OBJECT_ID('tempdb..#Result') IS NOT NULL
	--BEGIN
	--	DROP TABLE #Result
	--END	
	IF OBJECT_ID('tempdb..#Temp_Channel_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Channel_Code
	END	
	IF OBJECT_ID('tempdb..#Temp_Rights_Run') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Run
	END	
	------------------------------------------- CREATE TEMP TABLES -------------------------------------------	
	CREATE TABLE #Temp_Rights_Run
	(
		Deal_no VARCHAR(250), 
		Deal_Code INT, 
		Deal_Desc NVARCHAR(MAX),
		Vendor_Code INT,
		Deal_Movie_Code INT,		 
		Title_Code INT, 
		Deal_Right_Code INT,
		[Start_Date] DATETIME,                       
		End_Date DATETIME,                       		
		Channel_Code INT, 		
		Is_Yearwise_Definition CHAR(1),				
		Channel_No_Of_Runs VARCHAR(50),
		No_Of_Runs VARCHAR(50),
		Yearwise_No_Of_Runs VARCHAR(50),
		Run_Type CHAR(1)		
	)
	--CREATE TABLE #Result
	--(
	--	Deal_no VARCHAR(250), 
	--	Title_Name NVARCHAR(250), 
	--	Rights_Period VARCHAR(50),                       
	--	Deal_Movie_Code INT,		 
	--	Channel_Code INT, 
	--	Channel_Name NVARCHAR(50), 												
	--	Schedule_Run INT,
	--	No_Of_Runs VARCHAR(50),
	--	Balance_Runs VARCHAR(50),
	--	Count_No_Of_Schedule INT
	--)
	CREATE Table  #Temp_Channel_Code
	(
		ChannelCode INT
	)
	DECLARE @BV_Schedule_Transaction_Codes VARCHAR(MAX) = '',@First_day_Of_Last_Month DateTime = GETDATE()
	,@Last_day_Of_Last_Month DATETIME
	
	--SET @First_day_Of_Last_Month = DATEADD(dd,-(DAY(GETDATE())-1),GETDATE())
	--SET @Last_day_Of_Last_Month = DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))),DATEADD(mm,1,GETDATE()))
	
	SET @First_day_Of_Last_Month = DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0))
	SET @Last_day_Of_Last_Month =DATEADD(d,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
	
	------------------------------------------ INSERT TEMP TABLES(BV_Trans)-----------------------------------------
	IF (@Channel_Codes<>'') 
	BEGIN
		INSERT INTO #Temp_Channel_Code
		SELECT number FROM fn_Split_withdelemiter(@Channel_Codes,',')
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Channel_Code
		SELECT Channel_Code FROM Channel
	END
	------------------------------------------- SELECT FROM Temp Table -------------------------------------------	
	
	------------------------------------------- END DROP TEMP TABLES -------------------------------------------	
	INSERT INTO #Temp_Rights_Run
	(
		Deal_no,
		Deal_Code, 
		Deal_Desc ,
		Vendor_Code,
		Title_Code, 
		[Start_Date], 
		[End_Date],
		Deal_Movie_Code ,		
		Deal_Right_Code, 
		Channel_Code , 		
		Is_Yearwise_Definition ,		
		Channel_No_Of_Runs, 
		No_Of_Runs ,
		Yearwise_No_Of_Runs,
		Run_Type		
	)
	SELECT   AD.Agreement_No,AD.Acq_Deal_Code,AD.Deal_Desc ,AD.Vendor_Code,ADM.Title_Code,
	CASE WHEN  ADMR.Is_Yearwise_Definition = 'Y' THEN ADRY.[Start_Date] ELSE ADR.Actual_Right_Start_Date END AS Actual_Right_Start_Date, 
	CASE WHEN  ADMR.Is_Yearwise_Definition = 'Y' THEN ADRY.End_Date ELSE ADR.Actual_Right_End_Date END AS Actual_Right_End_Date,  
	ADM.Acq_Deal_Movie_Code,ADR.Acq_Deal_Rights_Code,ADMRC.Channel_Code,ADMR.Is_Yearwise_Definition				
	,CASE WHEN ADMR.Run_Definition_Type = 'S'  THEN ADMR.No_Of_Runs / tmp_Run_Channel.No_Of_Channels 
		WHEN ADMR.Run_Definition_Type = 'N'  THEN ADMR.No_Of_Runs / tmp_Run_Channel.No_Of_Channels
		ELSE ADMRC.Min_Runs 
	END Channel_No_Of_Runs
	,ADMR.No_Of_Runs,ISNULL(ADRY.No_Of_Runs, 0) Yearwise_No_Of_Runs,ADMR.Run_Type
	FROM Acq_Deal AD		
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code= AD.Acq_Deal_Code --AND ADM.Acq_Deal_Movie_Code IN(SELECT Deal_Movie_Code FROM #BV_Trans)	
	INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code= ADM.Acq_Deal_Code --AND ADR.Acq_Deal_Rights_Code IN(SELECT Deal_Right_Code FROM #BV_Trans)	                       
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code= ADRT.Acq_Deal_Rights_Code AND  ADRT.title_code = ADM.Title_Code
	INNER JOIN Acq_Deal_Run ADMR ON ADMR.Acq_Deal_Code= ADR.Acq_Deal_Code 
	INNER JOIN Acq_Deal_Run_Title ADMRT ON ADMR.Acq_Deal_Run_Code= ADMRT.Acq_Deal_Run_Code AND ADMRT.title_code  = ADRT.Title_Code
	INNER JOIN Acq_Deal_Run_Channel ADMRC on ADMR.Acq_Deal_Run_Code= ADMRC.Acq_Deal_Run_Code 
	AND ADMRC.Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)


	--INNER JOIN #Temp_Channel_Code TCC ON ADMRC.Channel_Code = TCC.ChannelCode	
	INNER JOIN 
		(
			SELECT Acq_Deal_Run_Code, COUNT(Channel_Code) No_Of_Channels 
			FROM Acq_Deal_Run_Channel 
			GROUP BY Acq_Deal_Run_Code
		) AS tmp_Run_Channel ON tmp_Run_Channel.Acq_Deal_Run_Code =  ADMR.Acq_Deal_Run_Code
	LEFT JOIN Acq_Deal_Run_Yearwise_Run ADRY ON ADRY.Acq_Deal_Run_Code = ADMR.Acq_Deal_Run_Code		
	WHERE 1=1 	and  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	


	--SELECT * FROM #Temp_Rights_Run
	-- RETURN 
	-----------------------------------------------------------------------------------------------
	SELECT  DISTINCT 
		trr.Deal_no AS Agreement_No,trr.Deal_Desc,V.Vendor_Name,Deal_Right_Code,t.Title_Name AS Title_Name,  
		trr.[Start_Date] AS Right_Start_Date, trr.End_Date AS Right_End_Date, 
	c.Channel_Name AS Channel_Name,
	CASE 
		WHEN Is_Yearwise_Definition = 'Y' AND trr.No_Of_Runs > 0 THEN (CAST(trr.Channel_No_Of_Runs AS INT) * CAST(trr.Yearwise_No_Of_Runs AS INT)) / CAST(ISNULL(trr.No_Of_Runs,0) AS INT) 
		--WHEN Is_Yearwise_Definition = 'N' AND trr.Run_Type = 'U' THEN 'Unlimited' 	
		ELSE CAST(trr.Channel_No_Of_Runs AS INT) 
	END AS No_Of_Runs
	,ISNULL(COUNT(bst.Channel_Code), 0) AS Scheduled_Runs
	,CASE 
		WHEN trr.Run_Type = 'U' THEN 'Unlimited' 
		ELSE		
			CAST(CASE 
				WHEN Is_Yearwise_Definition = 'Y' AND CAST(trr.No_Of_Runs AS INT) > 0 THEN (CAST(trr.Channel_No_Of_Runs AS INT) * CAST(trr.Yearwise_No_Of_Runs AS INT)) / CAST(trr.No_Of_Runs AS INT) 
				ELSE CAST(ISNULL(trr.Channel_No_Of_Runs,0) AS INT)
			END 
			- ISNULL(COUNT(bst.Channel_Code), 0) AS VARCHAR)  
	END	Balance_Runs
	--,0
	--,dbo.UFN_Get_Count_Schedule_Movie_Channel_Wise(trr.Deal_Movie_Code,trr.Deal_Right_Code,trr.Channel_Code) AS Count_Schedule_Movie_Channel_Wise
	,tmp_Run_Channel.Deal_Movie_Code_Count
	--,0
	FROM #Temp_Rights_Run trr 
	INNER JOIN Channel c on c.Channel_Code = trr.Channel_Code
	INNER JOIN Title t ON t.Title_Code = trr.Title_Code	
	INNER JOIN Vendor V ON V.Vendor_Code= trr.Vendor_Code	
	LEFT JOIN BV_Schedule_Transaction BST ON  trr.Deal_Right_Code = bst.Deal_Movie_Rights_Code AND trr.Deal_Movie_Code = bst.Deal_Movie_Code
	INNER JOIN 
	(
		SELECT Channel_Code,Deal_Movie_Code,Deal_Movie_Rights_Code,COUNT(Deal_Movie_Code) Deal_Movie_Code_Count 
		FROM BV_Schedule_Transaction
		--WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  DATEADD(MONTH, -1, GETDATE()) AND GETDATE() 				
		WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  CONVERT(DATETIME,@First_day_Of_Last_Month,106) 
		AND CONVERT(DATETIME,@Last_day_Of_Last_Month,106)
		AND Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)
		GROUP BY Deal_Movie_Code ,Channel_Code,Deal_Movie_Rights_Code
	) AS tmp_Run_Channel 
	ON tmp_Run_Channel.Channel_Code =  trr.Channel_Code AND trr.Deal_Movie_Code=tmp_Run_Channel.Deal_Movie_Code 
	AND trr.Deal_Right_Code=tmp_Run_Channel.Deal_Movie_Rights_Code
	AND trr.Channel_Code = bst.Channel_Code 	
	AND ISNULL(IsProcessed,'') = 'Y' 
	AND ISNULL(IsIgnore,'N') = 'N'		
	AND CONVERT(DATETIME,Schedule_Item_Log_Date,106)   BETWEEN TRR.[Start_Date] AND TRR.End_Date
	AND ((trr.No_Of_Runs > 0 AND trr.Run_Type ='C') OR trr.Run_Type ='U')
	--	AND trr.Title_Code = bst.Title_Code AND trr.Channel_Code = bst.Channel_Code
	--WHERE Deal_No like  'A-2012-00024'--'A-2010-00015'
	--	AND Title_Name like 'jab tak%'
	--	-- No_Of_Runs =3
	--	AND Channel_NAme like 'MAX Middle East'
	GROUP BY trr.Deal_no,
			t.Title_Name, 
			trr.Start_Date, 
			trr.End_Date, 
			c.Channel_Name,
			trr.Title_Code,
			trr.Deal_Code,
			trr.Deal_Right_Code,
			trr.Channel_Code,
			trr.No_Of_Runs,			
			trr.Is_Yearwise_Definition,
			trr.Channel_No_Of_Runs,
			trr.Yearwise_No_Of_Runs,
			trr.Run_Type
			,trr.Deal_Movie_Code
			,tmp_Run_Channel.Deal_Movie_Code_Count
			,trr.Deal_Desc,V.Vendor_Name
	ORDER BY trr.End_Date

--	SELECT * FROM #Temp_Rights_Run

	SELECT  DISTINCT AD.Agreement_No AS Agreement_No, AD.Deal_Desc, V.Vendor_Name, 0 AS Deal_Right_Code, t.Title_Name AS Title_Name, CCR.Rights_Start_Date AS Right_Start_Date, 
	CCR.Rights_End_Date AS Right_End_Date, c.Channel_Name AS Channel_Name, CCR.Defined_Runs AS No_Of_Runs, CCR.Schedule_Runs AS Scheduled_Runs,
	CASE WHEN CCR.Run_Type = 'U' THEN 'Unlimited'
	ELSE
		CASE WHEN ISNULL(CCR.Defined_Runs,0) > 0 THEN (ISNULL(CCR.Defined_Runs,0) - ISNULL(CCR.Schedule_Runs,0)) 
		ELSE 'Unlimited' END
	END
	AS Balance_Runs, tmp_Run_Channel.Content_Channel_Run_Count
	FROM Content_Channel_Run CCR
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
	INNER JOIN Channel c on c.Channel_Code = CCR.Channel_Code
	INNER JOIN Title t ON t.Title_Code = CCR.Title_Code	
	INNER JOIN Vendor V ON V.Vendor_Code= AD.Vendor_Code	
	LEFT JOIN BV_Schedule_Transaction BST ON BST.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code 
	INNER JOIN 
	(
		SELECT Content_Channel_Run_Code, COUNT(Content_Channel_Run_Code) Content_Channel_Run_Count
		FROM BV_Schedule_Transaction			
		WHERE CONVERT(DATETIME,Schedule_Item_Log_Date,106) BETWEEN  CONVERT(DATETIME,@First_day_Of_Last_Month,106) 
		AND CONVERT(DATETIME,@Last_day_Of_Last_Month,106)
		AND Channel_Code IN(SELECT ChannelCode FROM #Temp_Channel_Code)
		GROUP BY Content_Channel_Run_Code 
	) AS tmp_Run_Channel 
	ON tmp_Run_Channel.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code
	AND ISNULL(IsProcessed,'') = 'Y' 
	AND ISNULL(IsIgnore,'N') = 'N'		
	AND CONVERT(DATETIME,Schedule_Item_Log_Date,106)   BETWEEN CCR.Rights_Start_Date AND CCR.Rights_End_Date
	AND ((CCR.Defined_Runs > 0 AND CCR.Run_Type ='C') OR CCR.Run_Type ='U')
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')
	--	AND trr.Title_Code = bst.Title_Code AND trr.Channel_Code = bst.Channel_Code
	--WHERE Deal_No like  'A-2012-00024'--'A-2010-00015'
	--	AND Title_Name like 'jab tak%'
	--	-- No_Of_Runs =3
	--	AND Channel_NAme like 'MAX Middle East'
	GROUP BY AD.Agreement_No,
			t.Title_Name, 
			CCR.Rights_Start_Date, 
			CCR.Rights_End_Date, 
			c.Channel_Name,
			CCR.Title_Code,
			CCR.Acq_Deal_Code,
			CCR.Channel_Code,
			CCR.Defined_Runs,
			CCR.Run_Type
			,tmp_Run_Channel.Content_Channel_Run_Count
			,AD.Deal_Desc,V.Vendor_Name
	ORDER BY trr.End_Date

	------------------------------------------- DROP  TEMP TABLES -------------------------------------------		
	DROP TABLE #Temp_Rights_Run
	--DROP TABLE #Result
	DROP TABLE #Temp_Channel_Code
	------------------------------------------- END DROP TEMP TABLES -------------------------------------------	

	IF OBJECT_ID('tempdb..#BV_Trans') IS NOT NULL DROP TABLE #BV_Trans
	IF OBJECT_ID('tempdb..#Result') IS NOT NULL DROP TABLE #Result
	IF OBJECT_ID('tempdb..#Temp_Channel_Code') IS NOT NULL DROP TABLE #Temp_Channel_Code
	IF OBJECT_ID('tempdb..#Temp_Rights_Run') IS NOT NULL DROP TABLE #Temp_Rights_Run
END
/*
--EXEC USP_Last_Month_Utilization_Report '' ,1 ,'23'
*/