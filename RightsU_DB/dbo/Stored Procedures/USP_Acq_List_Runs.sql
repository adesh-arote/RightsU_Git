
CREATE Proc [dbo].[USP_Acq_List_Runs]
(
	--DECLARE
	@Deal_Code Int=23940,
	@Title_Codes VARCHAR(MAX)='',
	@Channel_Codes VARCHAR(MAX)='',
	@Acq_Deal_Run_Codes NVARCHAR(MAX)=''
)
AS
---- =============================================
---- Author:		Rajesh J Godse
---- Create DATE: 04 June 2015
---- Description:	Get Acquisition Run List page
---- Updated By : Akshay K
---- Description: Added search by channel as well as added @Acq_Deal_Run_Codes so the checked boxes
---- in  Bulk Update/Delete list remain checked.
---- ============================================= 
Begin

	--DECLARE
	--@Deal_Code Int=15375,
	--@Title_Codes VARCHAR(MAX)='24585',
	--@Channel_Codes VARCHAR(MAX)='',
	--@Acq_Deal_Run_Codes NVARCHAR(MAX)=''

	IF @Title_Codes <> '' AND @Channel_Codes = ''
	BEGIN
		SET @Channel_Codes = ','
	END

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
		DROP TABLE #temp

	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
	SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal WHERE Acq_Deal_Code = @Deal_Code
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	Select DISTINCT ADR.Acq_Deal_Run_Code , AD.Acq_Deal_Code AS Acq_Deal_Code,
	dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, t.Title_Name, ADRT.Episode_From, ADRT.Episode_To) AS [Title_Name], ADM.Acq_Deal_Movie_Code ,	ADRC1.Channel_Code,
	STUFF(
			(Select Distinct ', ' + CAST(C.Channel_Name as NVARCHAR) From Channel C
			INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Channel_Code = C.Channel_Code
				Where ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			FOR XML PATH('')), 1, 1, '') as ChannelNames
	    ,Run_Definition_Type ,Run_Type,No_Of_Runs,Is_Rule_Right ,
	--(select SUM(Schedule_Runs) from Content_Channel_Run CCR Where CCR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND Schedule_Runs 
	--IS NOT NULL AND ISNULL(CCR.Is_Archive,'N') != 'Y') No_Of_Runs_Sched 
	ADR.No_Of_Runs_Sched
	,ADRS.Data_For ,[dbo].[UFN_Check_SubLicense](ADR.Acq_Deal_Run_Code) AS Is_SubLicense,
	ISNULL(ADR.Syndication_Runs, 0) AS Syndication_Runs,
	ADR.Last_updated_Time,ADR.Inserted_On
	INTO #temp
	FROM Acq_Deal_Run ADR
	  INNER JOIN Acq_Deal_Run_Title ADRT ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
	  INNER JOIN Acq_Deal_Run_Channel ADRC1 ON ADRT.Acq_Deal_Run_Code=ADRC1.Acq_Deal_Run_Code
	  INNER JOIN Title t ON ADRT.Title_Code = t.Title_Code
	  INNER JOIN Acq_Deal_Movie ADM ON ADR.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADRT.Title_Code = ADM.Title_Code
	  INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code=AD.Acq_Deal_Code
	  LEFT JOIN Acq_Deal_Run_Shows ADRS ON ADR.Acq_Deal_Run_Code = ADRS.Acq_Deal_Run_Code	
	WHERE ADR.Acq_Deal_Code = @Deal_Code 
	
	
	IF @Title_Codes <> '' AND @Channel_Codes <> ','
	BEGIN
		SELECT distinct Acq_Deal_Run_Code,Acq_Deal_Code,Title_Name,Acq_Deal_Movie_Code,ChannelNames,Run_Definition_Type,Run_Type,No_Of_Runs,Is_Rule_Right,No_Of_Runs_Sched,Data_For,Is_SubLicense,Syndication_Runs FROM #temp
		WHERE(
			   (Acq_Deal_Movie_Code IN (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) OR @Title_Codes='0') 
				 and (Channel_Code in (select number from dbo.fn_Split_withdelemiter(@Channel_Codes,','))  OR  @Channel_Codes = '')	
			 )
     		 OR
		 Acq_Deal_Run_Code  IN ((select number from dbo.fn_Split_withdelemiter(@Acq_Deal_Run_Codes,','))) 	
	END
	ELSE
	BEGIN
		SELECT distinct Acq_Deal_Run_Code,Acq_Deal_Code,Title_Name,Acq_Deal_Movie_Code,ChannelNames,Run_Definition_Type,Run_Type,No_Of_Runs,Is_Rule_Right,No_Of_Runs_Sched,Data_For,Is_SubLicense,Syndication_Runs FROM #temp
		WHERE(
			   (Acq_Deal_Movie_Code IN (select number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) OR @Title_Codes='0') 
				 or (Channel_Code in (select number from dbo.fn_Split_withdelemiter(@Channel_Codes,','))  OR  @Channel_Codes = '')	
			 )
     		 OR
		  Acq_Deal_Run_Code  IN ((select number from dbo.fn_Split_withdelemiter(@Acq_Deal_Run_Codes,','))) 		
	END

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
END
