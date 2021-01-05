CREATE Procedure [dbo].[USP_Get_PlatformCodes_For_Ancillary]
	@Title_Codes Varchar(1000),
	@Platform_Codes Varchar(MAX),
	@Platform_Type Varchar(10),   ----- PL / TPL / ''
	@Acq_Deal_Code Int = 0,
	@Call_From_Rights CHAR(1) = 'N',
	@Deal_Rights_Code INT
As
-- =============================================
-- Author:		Akshay Rane
-- Create date:	29 Mar 2018
-- Description:	Get Platform Codes For Titles
-- =============================================
Begin
	--DECLARE 
	--@Title_Codes Varchar(1000) = '24157',
	--@Platform_Codes Varchar(MAX)= '',
	--@Platform_Type Varchar(10) = 'PL',  
	--@Acq_Deal_Code Int =15120,
	--@Call_From_Rights CHAR(1) = 'Y',
	--@Deal_Rights_Code INT = 26104

	Declare @Parent_Country_Code Int =0

	Set NOCOUNT ON;
	Set FMTONLY OFF;
-- =============================================Delete Temp Tables =============================================

	If OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL
	Begin
		Drop Table #Deal_Rights_Lang   
	End
-- =============================================CREATE Temp Tables =============================================
		Declare @Deal_Rights_Title  Table 
		(
			Title_Code Int,
			Episode_FROM Int,
			Episode_To Int
		)
-- ============================================= -- ============================================= 
	Declare @Selected_Deal_Type_Code Int ,@Deal_Type_Condition Varchar(MAX) = ''
	Declare @TitCnt Int = 0
	Select Top 1 @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal Where Acq_Deal_Code = @Acq_Deal_Code
	Select @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	If(@Deal_Type_Condition = 'DEAL_PROGRAM')
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_Starts_From ,Episode_End_To From Acq_Deal_Movie 
		Where Acq_Deal_Movie_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Acq_Deal_Code = @Acq_Deal_Code
	End
	Else
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_Starts_From ,Episode_End_To  From Acq_Deal_Movie 
		Where Title_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Acq_Deal_Code = @Acq_Deal_Code
	End

	Declare @Required_Codes Varchar(max) = '' ,@Total_Title_Count  Int = 0
	Select @Total_Title_Count += (Episode_To - Episode_FROM) + 1 From @Deal_Rights_Title
	--Here PL Means 'Platform' 
	-- Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
	If(@Platform_Type = 'PL' Or @Platform_Type = 'TPL')
	Begin
		
		Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

		Select Distinct adrt.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To 
		InTo #AcquiredTitles 
		From Acq_Deal_Rights_Title adrt
		Inner Join Acq_Deal_Rights adr ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code 
		Inner Join Acq_Deal ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code And ADR.Actual_Right_Start_Date IS NOT NULL
		Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
		(
			drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
			drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
			adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
			adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
		)
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ad.Acq_Deal_Code = @Acq_Deal_Code
			
		Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitles

		--SELECT * FROM @Deal_Rights_Title
		--SELECT * FROM #AcquiredTitles
		--DELETE FROM  #AcquiredTitles WHERE Episode_FROM = 2
		--SELECT * FROM #AcquiredTitles

		If(@Deal_Type_Condition = 'DEAL_PROGRAM')
		BEGIN
			DELETE FROM #AcquiredTitles  WHERE Episode_FROM NOT IN (SELECT Episode_FROM FROM @Deal_Rights_Title) AND
			Episode_To NOT IN (SELECT Episode_To FROM @Deal_Rights_Title) 	
			
			Select @TitCnt = Count(Title_Code) From @Deal_Rights_Title
			--Select @Total_Title_Count = Count(Acq_Deal_Rights_Code) From #AcquiredTitles

			Select 
				 @Total_Title_Count = Count(*) 
			From
			(
				Select distinct Title_Code, Episode_FROM, Episode_To From #AcquiredTitles -- Group By Title_Code, Episode_FROM, Episode_To
			) As a

			--SELECT * FROM @Deal_Rights_Title
			--SELECT * FROM #AcquiredTitles
		END

		If(@TitCnt = @Total_Title_Count)
		Begin
			Select 
				@Total_Title_Count = Count(*) 
			From
			(
				Select Title_Code, Episode_FROM, Episode_To From #AcquiredTitles Group By Title_Code, Episode_FROM, Episode_To
			) As a

			--Select @Total_Title_Count
			Select @Required_Codes = ''
			If(@Platform_Type = 'PL')
			Begin
				Select 
					@Required_Codes = @Required_Codes + Platform_Code + ','
				From 
				(
					Select Distinct Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
					IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
					From #AcquiredTitles adr 
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code					
				)  As TEMP
				Group By TEMP.Platform_Code
				Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
			End
			Else If(@Platform_Type = 'TPL')
			Begin
				Select 
					@Required_Codes = @Required_Codes + Platform_Code + ','
				From 
				(
					Select Distinct 
					Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
					IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
					From #AcquiredTitles adr 
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
					Inner Join Platform P ON adrp.Platform_Code = P.Platform_Code And Applicable_For_Demestic_Territory = 'Y'
				)  As TEMP
				Group By TEMP.Platform_Code
				Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
			End
			Set @Required_Codes = Substring(@Required_Codes, 0, Len(@Required_Codes))
		End
		Else
		Begin
			Set @Required_Codes = ''
		End			
		Drop Table #AcquiredTitles			
	End
	  
	IF(@Call_From_Rights = 'N')
	BEGIN
		SELECT @Required_Codes As RequiredCodes
	END
	ELSE
	BEGIN
		SELECT @Required_Codes =  STUFF((
			SELECT DISTINCT ',' + cast(Platform_Code as varchar(max))
			FROM Acq_deal_Rights_Platform where Acq_deal_Rights_cODE = @Deal_Rights_Code
		FOR XML PATH('')
		), 1, 1, '');

		IF OBJECT_ID('TEMPDB..#RequiredCodes') IS NOT NULL       
			DROP TABLE #RequiredCodes 

		DECLARE @AncPlatformCodes VARCHAR(MAX) = '';
		SELECT  @AncPlatformCodes = Dbo.UFN_Get_Selected_Ancillary_Platform(@Deal_Rights_Code,@Acq_Deal_Code, @Title_Codes)
		CREATE TABLE #RequiredCodes( PlatformCodes INT)

		INSERT INTO #RequiredCodes(PlatformCodes)
        SELECT number  FROM ( 
			SELECT number  FROM dbo.fn_Split_withdelemiter(@Required_Codes,',') WHERE number <> ''
			INTERSECT
			SELECT number  FROM dbo.fn_Split_withdelemiter(ISNULL(@AncPlatformCodes,''),',') WHERE number <> ''
		) AS PlatformCodes

		SELECT ISNULL( STUFF((SELECT DISTINCT ',' + CAST(PlatformCodes as varchar(max)) FROM #RequiredCodes FOR XML PATH('')), 1, 1, '') ,'') AS RequiredCodes
	END

	IF OBJECT_ID('tempdb..#AcquiredTitles') IS NOT NULL DROP TABLE #AcquiredTitles
	IF OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL DROP TABLE #Deal_Rights_Lang
	IF OBJECT_ID('tempdb..#RequiredCodes') IS NOT NULL DROP TABLE #RequiredCodes
End

/*
EXEC USP_Get_PlatformCodes_For_Ancillary '23080,23098,23096','','PL',15073
*/

--select * from acq_deal_rights_title where acq_deal_rights_code =  26057