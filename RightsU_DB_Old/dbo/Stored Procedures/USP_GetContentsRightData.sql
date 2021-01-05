alter PROC USP_GetContentsRightData
(
	@Title_Content_Code BIGINT
)
As
/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	11 Jan 2017
Description:	Get Content Deal data
===============================================*/

BEGIN
	DECLARE   @Title_Code INT
	IF(OBJECT_ID('TEMPDB..#PlatformForRun') IS NOT NULL)
		DROP TABLE #PlatformForRun

	IF(OBJECT_ID('TEMPDB..#TempRun') IS NOT NULL)
		DROP TABLE #TempRun

	SELECT Platform_Code INTO #PlatformForRun FROM [Platform] WHERE ISNULL(Is_No_Of_Run, 'N') = 'Y'
	SELECT Acq_Deal_Code,Runs_Type_Desc,Yearwise_Definition,Scheduled_Run,Channel_Names,Deal_Type INTO #TempRun
	 From(
	SELECT ADR.Acq_Deal_Code,
	CASE 
		WHEN ADR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(ADR.No_Of_Runs AS VARCHAR) + ')' 
	END AS Runs_Type_Desc,
	CASE 
		WHEN ADR.Is_Yearwise_Definition = 'Y' THEN 'Yes' 
		ELSE 'No' 
	END [Yearwise_Definition],
	ADR.No_Of_Runs_Sched AS Scheduled_Run,
	STUFF((
		SELECT  DISTINCT ',' + C.Channel_Name
        FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code	
        WHERE  ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
        FOR XML PATH('')
	), 1, 1, '') AS Channel_Names,
	'A' AS Deal_Type
	FROM Title_Content TC
	INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To
	INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
	UNION
	SELECT PDT.Provisional_Deal_Code,
	CASE 
		WHEN PDR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(PDR.No_Of_Runs AS VARCHAR) + ')' 
	END AS Runs_Type_Desc,
	CASE 
		WHEN PDR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(PDR.No_Of_Runs AS VARCHAR) + ')' 
	END AS [Yearwise_Definition],
	PDR.No_Of_Runs AS Scheduled_Run,
	STUFF((
		SELECT  DISTINCT ',' + C.Channel_Name
        FROM Provisional_Deal_Run_Channel PDRC
		INNER JOIN Channel C ON C.Channel_Code = PDRC.Channel_Code	
        WHERE  PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
        FOR XML PATH('')
	), 1, 1, '') AS Channel_Names,
	'P' AS Deal_Type
	FROM Title_Content TC
	INNER JOIN Provisional_Deal_Title PDT ON PDT.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN PDT.Episode_From AND PDT.Episode_To
	INNER JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Title_Code = PDT.Provisional_Deal_Title_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
	) B
	--Select @Title_Code = Title_Code From Title_Content where Title_Content_Code = @Title_Content_Code
	--Print @Title_Code
	--IF EXISTS(Select Title_Code From Acq_Deal_Movie where Title_Code = @Title_Code)
	--BEGIN
	SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Agreement_Date, V.Vendor_Name AS Licensor,
	CASE 
		WHEN A.Right_Type != 'U' THEN REPLACE(CONVERT(VARCHAR(11),A.Actual_Right_Start_Date,106), ' ', '-') + ' To ' + 
			REPLACE(Convert(VARCHAR(11),A.Actual_Right_End_Date,106), ' ', '-')
		WHEN Right_Type = 'U' THEN 'Perpetuity From ' + REPLACE(Convert(VARCHAR(11),A.Actual_Right_Start_Date,106), ' ', '-')
	END AS Rights_Period,
	RUN.Runs_Type_Desc,
	RUN.Scheduled_Run,
	RUN.Yearwise_Definition,
	RUN.Channel_Names
	FROM Title_Content TC 
	INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code 
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	LEFT JOIN 
	(
		SELECT ADR.Acq_Deal_Code, ADRC.Title_Code, ADRC.Episode_From , ADRC.Episode_To, Adr.Actual_Right_Start_Date , 
		Adr.Actual_Right_End_Date, adr.Right_Type FROM 
		Acq_Deal_Rights_Title ADRC 
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRC.Acq_Deal_Rights_Code 
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code 
			AND ADRP.Platform_Code IN (SELECT Platform_Code FROM #PlatformForRun)
	) AS A ON A.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN A.Episode_From AND A.Episode_To
	AND A.Acq_Deal_Code = Ad.Acq_Deal_Code
	LEFT  JOIN #TempRun RUN ON RUN.Acq_Deal_Code = A.Acq_Deal_Code AND RUN.Deal_Type = 'A'
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND TC.Title_Content_Code = @Title_Content_Code
	--END
	UNION
	SELECT DISTINCT PD.Agreement_No, PD.Deal_Desc, PD.Agreement_Date, V.Vendor_Name AS Licensor,
	REPLACE(CONVERT(VARCHAR(11),PDRC.Right_Start_Date,106), ' ', '-') + ' To ' + 
			REPLACE(Convert(VARCHAR(11),PDRC.Right_End_Date,106), ' ', '-')	AS Rights_Period,
	RUN.Runs_Type_Desc,
	RUN.Scheduled_Run,
	RUN.Yearwise_Definition,
	RUN.Channel_Names
	FROM  #TempRun RUN,Title_Content TC 
	INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Title_Code = TCM.Provisional_Deal_Title_Code 
	INNER JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code
	INNER JOIN Provisional_Deal_Licensor PDL ON PD.Provisional_Deal_Code = PDL.Provisional_Deal_Code
	INNER JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Title_Code = PDT.Provisional_Deal_Title_Code
	INNER JOIN Provisional_Deal_Run_Channel PDRC ON PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
	INNER JOIN Vendor V ON V.Vendor_Code = PDL.Vendor_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code AND RUN.Deal_Type = 'P' 
END
GO