-- =============================================
-- Author:		RESHMA KUNJAL
-- Create date: 15 SEP 2015
-- Description:	RUN EXPIRY REPORT
-- =============================================
ALTER PROCEDURE [dbo].[USP_Acq_Run_Expiry_Report]
@BU_Code VARCHAR(100),
@Channel_Codes VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET FMTONLY OFF;
	--SELECT * FROM System_Parameter_New 
	
	SELECT DISTINCT CASE WHEN Allow_less_Than = 'Y' THEN 0 ELSE Mail_alert_days END AS Start_Range, Mail_alert_days AS End_Range INTO #Alert_Range
	FROM Deal_Expiry_Email WHERE Alert_Type = 'E'
	--SELECT * FROM Deal_Expiry_Email
	

	SELECT DISTINCT 
		ad.Acq_Deal_Code, 
		ad.Agreement_No, 
		ad.Deal_Desc,
		ad.Vendor_Code,
		adrt.Title_Code, 
		adr.Acq_Deal_Rights_Code,
		CASE WHEN  adrun.Is_Yearwise_Definition = 'Y' THEN adry.Start_Date ELSE adr.Actual_Right_Start_Date END AS Actual_Right_Start_Date, 
		CASE WHEN  adrun.Is_Yearwise_Definition = 'Y' THEN adry.End_Date ELSE adr.Actual_Right_End_Date END AS Actual_Right_End_Date,  
		adrun.Is_Yearwise_Definition, 
		adrc.Channel_Code, 
		adrun.Run_Definition_Type,
		adrun.Acq_Deal_Run_Code ,
		CASE WHEN adrun.Run_Definition_Type = 'S'  THEN adrun.No_Of_Runs / tmp_Run_Channel.No_Of_Channels 
		WHEN adrun.Run_Definition_Type = 'N'  THEN adrun.No_Of_Runs / tmp_Run_Channel.No_Of_Channels
		ELSE adrc.Min_Runs END Channel_No_Of_Runs
		,DATEDIFF(dd, GETDATE(), ISNULL(CASE WHEN  adrun.Is_Yearwise_Definition = 'Y' THEN adry.End_Date ELSE adr.Actual_Right_End_Date END, '31Dec9999')) AS Expire_In_Days
		,ISNULL(adry.No_Of_Runs, 0) Yearwise_No_Of_Runs
		,adrun.No_Of_Runs
		,adm.Acq_Deal_Movie_Code
	INTO #Tmp_Rights_Run
	FROM Acq_Deal AD
	INNER JOIN Acq_Deal_Run adrun ON adrun.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN Acq_Deal_Run_Title adrunt ON adrunt.Acq_Deal_Run_Code = adrun.Acq_Deal_Run_Code 
	INNER JOIN Acq_Deal_Movie adm ON adm.Acq_Deal_Code = ad.Acq_Deal_Code AND adm.Title_Code = adrunt.Title_Code
	INNER JOIN Acq_Deal_Run_Channel adrc ON adrc.Acq_Deal_Run_Code = adrunt.Acq_Deal_Run_Code 
	INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
	INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrunt.Title_Code = adrt.Title_Code
	INNER JOIN 
		(
			SELECT Acq_Deal_Run_Code, COUNT(Channel_Code) No_Of_Channels 
			FROM Acq_Deal_Run_Channel 
			GROUP BY Acq_Deal_Run_Code
		) AS tmp_Run_Channel ON tmp_Run_Channel.Acq_Deal_Run_Code =  adrun.Acq_Deal_Run_Code
	LEFT JOIN Acq_Deal_Run_Yearwise_Run adry ON adry.Acq_Deal_Run_Code = adrun.Acq_Deal_Run_Code
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND adrun.Run_Type = 'C'  
	AND adrc.Channel_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Channel_Codes, ',') WHERE number NOT IN ('', '0'))
	AND adrun.Is_Channel_Definition_Rights = 'Y'
	AND ad.Business_Unit_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@BU_Code, ',') WHERE number NOT IN ('', '0'))	
	AND adr.Acq_Deal_Rights_Code IN
		(
			SELECT adrp.Acq_Deal_Rights_Code 
			FROM Acq_Deal_Rights_Platform adrp 
			INNER JOIN Platform p ON p.Platform_Code = adrp.Platform_Code 
			WHERE p.Applicable_For_Asrun_Schedule = 'Y'
		)
	AND GETDATE() BETWEEN (CASE WHEN  adrun.Run_Definition_Type = 'Y' THEN adry.Start_Date ELSE adr.Actual_Right_Start_Date END)
	AND (CASE WHEN  adrun.Run_Definition_Type = 'Y' THEN adry.End_Date ELSE adr.Actual_Right_End_Date END)

	--Select * from Acq_Deal
	--SELECT * FROM #Tmp_Rights_Run where Title_Code =6157
	--SELECT * FROM Title where Title_Name like 'jab tak%'

	SELECT DISTINCT 
		trr.Agreement_No AS Agreement_No,
		t.Title_Name AS Title_Name,  
		trr.Actual_Right_Start_Date AS Right_Start_Date,  
		trr.Actual_Right_End_Date AS Right_End_Date, 
		c.Channel_Name AS Channel_Name,
		CASE WHEN Is_Yearwise_Definition = 'Y' THEN (trr.Channel_No_Of_Runs * trr.Yearwise_No_Of_Runs) / trr.No_Of_Runs ELSE trr.Channel_No_Of_Runs END AS No_Of_Runs,
		ISNULL(COUNT(bst.Channel_Code), 0) AS Scheduled_Runs ,
		trr.Deal_Desc AS Deal_Desc,
		v.Vendor_Name AS Vendor_Name
		,trr.Expire_In_Days
	FROM 
	#Tmp_Rights_Run trr 
	INNER JOIN Channel c on c.Channel_Code = trr.Channel_Code
	INNER JOIN Title t ON t.Title_Code = trr.Title_Code
	INNER JOIN Vendor v ON v.Vendor_Code = trr.Vendor_Code
	LEFT JOIN BV_Schedule_Transaction bst ON trr.Acq_Deal_Rights_Code = bst.Deal_Movie_Rights_Code AND trr.Acq_Deal_Movie_Code = bst.Deal_Movie_Code
		AND trr.Title_Code = bst.Title_Code AND trr.Channel_Code = bst.Channel_Code
		AND CONVERT(DATETIME,bst.Schedule_Item_Log_Date,106) BETWEEN trr.Actual_Right_Start_Date AND trr.Actual_Right_End_Date
	WHERE ISNULL(IsIgnore, 'N') = 'N'
	AND EXISTS (SELECT 1 FROM #Alert_Range tmp WHERE trr.Expire_In_Days BETWEEN tmp.Start_Range AND tmp.End_Range)
	--AND trr.Title_Code=2416
	--AND trr.Acq_Deal_Code=42
	GROUP BY trr.Agreement_No,
			t.Title_Name, 
			trr.Actual_Right_Start_Date, 
			trr.Actual_Right_End_Date, 
			c.Channel_Name,
			trr.Title_Code,
			trr.Acq_Deal_Code,
			trr.Channel_Code,
			trr.No_Of_Runs,
			trr.Deal_Desc,
			v.Vendor_Name
			,trr.Expire_In_Days
			,trr.Is_Yearwise_Definition
			,trr.Channel_No_Of_Runs
			,trr.Yearwise_No_Of_Runs

	/*
	select * from Channel 
	select * from Acq_Deal_Run
	select DISTINCT Run_Definition_Type from Acq_Deal_Run
	select * from Acq_Deal_Run_Channel
	select * from Acq_Deal_Run_Title
	select * from Acq_Deal_Run_Yearwise_Run
	select * from Deal_Expiry_Email
	*/

	DROP TABLE #Tmp_Rights_Run

END
--Select * from System_Parameter_New
--EXEC [USP_Acq_Run_Expiry_Report] '2','24'