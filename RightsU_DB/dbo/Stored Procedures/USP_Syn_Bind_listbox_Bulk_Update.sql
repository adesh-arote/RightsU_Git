CREATE PROCEDURE [dbo].[USP_Syn_Bind_listbox_Bulk_Update]
(
	@Right_Codes VARCHAR(MAX),
	@Type CHAR(2),
	@ChangeFor CHAR(2)
)
AS
-- =============================================
-- Author:	Anchal Sikarwar
-- Create DATE: 19-Jul-2016
-- Description:	For Populating Listboxes
-- Updated by :
-- Date :
-- Reason:
-- =============================================
BEGIN
	Create TABLE #RightCodes(Right_Code INT);
	Create TABLE #TitleCodes(Title_Code INT);
	Create TABLE #PlatformCodes(Platform_Code INT);
	Create TABLE #temp1(Display_Text VARCHAR(50),Display_Value INT,PlatformCodes VARCHAR(MAX));
	Create TABLE #temp(RequiredCodes VARCHAR(MAX),SubTitle_Lang_Code VARCHAR(MAX),Dubb_Lang_Code VARCHAR(MAX));
	CREATE TABLE #FinalListData
		(
			RowID INT IDENTITY(1,1),
			Display_Value INT,
			Display_Text NVARCHAR(MAX)
		)
	DECLARE @RCount INT,@TitleCode VARCHAR(MAX),@Is_Theatrical CHAR(1)='',@Syn_Deal_Code INT,@Platform_Codes VARCHAR(MAX),@RequiredCodes VARCHAR(MAX),
	@SubTitle_Lang_Code VARCHAR(MAX),@Dubb_Lang_Code VARCHAR(MAX)
	INSERT INTO #RightCodes
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Right_Codes,',') WHERE number!=''
	SELECT @Is_Theatrical=Is_Theatrical_Right,@Syn_Deal_Code=Syn_Deal_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code IN(SELECT TOP 1 Right_Code FROM #RightCodes)
	SELECT @RCount=COUNT(*) FROM #RightCodes
	INSERT INTO #TitleCodes
	SELECT Title_Code FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes)
	SELECT @TitleCode = Stuff((SELECT ',' + Cast(rc.Title_Code AS VARCHAR(MAX))	FROM #TitleCodes rc FOR XML PATH('')), 1, 2, '')

	IF(@ChangeFor='A')
	BEGIN
		IF(@Is_Theatrical='N')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,'','PL','','','',@Syn_Deal_Code
		END
		ELSE
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,'','TPL','','','',@Syn_Deal_Code
		END
		SELECT @Platform_Codes=RequiredCodes FROM #temp
		DELETE FROM #temp
		IF(@Type='P')
		BEGIN
			INSERT INTO #temp1(PlatformCodes)
			SELECT @Platform_Codes
		END
		ELSE IF(@Type='I')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','C','','',@Syn_Deal_Code
			SELECT @RequiredCodes=RequiredCodes FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Country_Name,Country_Code FROM Country WHERE Country_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@RequiredCodes,',') WHERE number!='')
		END

		ELSE IF(@Type='T')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','T','','',@Syn_Deal_Code
			SELECT @RequiredCodes=RequiredCodes FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Territory_Name,Territory_Code FROM Territory WHERE Territory_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@RequiredCodes,',') WHERE number!='')
		END

		ELSE IF(@Type='I' AND @Is_Theatrical='Y')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','THC','','',@Syn_Deal_Code
		END
		ELSE IF(@Type='T' AND @Is_Theatrical='Y')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','THT','','',@Syn_Deal_Code
		END

		ELSE IF(@Type='SL')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','','SL','',@Syn_Deal_Code
			SELECT @SubTitle_Lang_Code=SubTitle_Lang_Code FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Language_Name,Language_Code FROM Language WHERE Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@SubTitle_Lang_Code,',') WHERE number!='')
		END
		ELSE IF(@Type='SG')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','','SG','',@Syn_Deal_Code
			SELECT @SubTitle_Lang_Code=SubTitle_Lang_Code FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Language_Group_Name,Language_Group_Code FROM Language_Group WHERE Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@SubTitle_Lang_Code,',') WHERE number!='')
		END

		ELSE IF(@Type='DL')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','','SL','',@Syn_Deal_Code
			SELECT @Dubb_Lang_Code=Dubb_Lang_Code FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Language_Name,Language_Code FROM Language WHERE Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Dubb_Lang_Code,',') WHERE number!='')
		END

		ELSE IF(@Type='DG')
		BEGIN
			INSERT INTO #temp
			EXEC [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES] @TitleCode,@Platform_Codes,'','','SG','',@Syn_Deal_Code
			SELECT @Dubb_Lang_Code=Dubb_Lang_Code FROM #temp
			INSERT INTO #temp1(Display_Text,Display_Value)
			SELECT Language_Group_Name,Language_Group_Code FROM Language_Group WHERE Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Dubb_Lang_Code,',') WHERE number!='')
		END
	END
	else IF(@ChangeFor='D')
	BEGIN
		IF(@Type='P')
		BEGIN
		INSERT INTO #temp(RequiredCodes)
		SELECT DISTINCT Platform_Code FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Platform_Code having COUNT(*)=@RCount
		SELECT @RequiredCodes=RequiredCodes FROM #temp
		DELETE FROM #temp
		IF(@Type='P')
		BEGIN
		INSERT INTO #temp1(PlatformCodes)
		SELECT @RequiredCodes
		END
		END

		IF(@Type='I')
		BEGIN
		INSERT INTO #temp(RequiredCodes)
		SELECT DISTINCT Country_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Country_Code having COUNT(*)=@RCount

		SELECT @RequiredCodes=RequiredCodes FROM #temp
		INSERT INTO #temp1(Display_Text,Display_Value)
		SELECT Country_Name,Country_Code FROM Country WHERE Country_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@RequiredCodes,',') WHERE number!='')
	
		END

		ELSE IF(@Type='T')
		BEGIN
		INSERT INTO #temp(RequiredCodes)
		SELECT DISTINCT Territory_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Territory_Code having COUNT(*)=@RCount

		SELECT @RequiredCodes=RequiredCodes FROM #temp
		INSERT INTO #temp1(Display_Text,Display_Value)
		SELECT Territory_Name,Territory_Code FROM Territory WHERE Territory_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@RequiredCodes,',') WHERE number!='')

		END

		ELSE IF(@Type='I' AND @Is_Theatrical='Y')
		BEGIN
		INSERT INTO #temp(RequiredCodes)
		SELECT DISTINCT Country_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Country_Code having COUNT(*)=@RCount
		END

		ELSE IF(@Type='T' AND @Is_Theatrical='Y')
		BEGIN
		INSERT INTO #temp(RequiredCodes)
		SELECT DISTINCT Territory_Code FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Territory_Code having COUNT(*)=@RCount
		END

		ELSE IF(@Type='SL')
		BEGIN
		INSERT INTO #temp(SubTitle_Lang_Code)
		SELECT DISTINCT Language_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Language_Code having COUNT(*)=@RCount

		SELECT @SubTitle_Lang_Code=SubTitle_Lang_Code FROM #temp
		INSERT INTO #temp1(Display_Text,Display_Value)
		SELECT Language_Name,Language_Code FROM Language WHERE Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@SubTitle_Lang_Code,',') WHERE number!='')
		END

		ELSE IF(@Type='SG')
		BEGIN
		INSERT INTO #temp(SubTitle_Lang_Code)
		SELECT DISTINCT Language_Group_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Language_Group_Code having COUNT(*)=@RCount

		SELECT @SubTitle_Lang_Code=SubTitle_Lang_Code FROM #temp
		INSERT INTO #temp1(Display_Text,Display_Value)
		SELECT Language_Group_Name,Language_Group_Code FROM Language_Group WHERE Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@SubTitle_Lang_Code,',') WHERE number!='')
		END

		ELSE IF(@Type='DL')
		BEGIN
		INSERT INTO #temp(SubTitle_Lang_Code)
		SELECT DISTINCT Language_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Language_Code having COUNT(*)=@RCount

		SELECT @Dubb_Lang_Code=Dubb_Lang_Code FROM #temp
		INSERT INTO #temp1(Display_Text,Display_Value)
		SELECT Language_Name,Language_Code FROM Language WHERE Language_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Dubb_Lang_Code,',') WHERE number!='')
		END

		ELSE IF(@Type='DG')
		BEGIN
		INSERT INTO #temp(SubTitle_Lang_Code)
		SELECT DISTINCT Language_Group_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code IN(SELECT Right_Code FROM #RightCodes) 
		GROUP BY Language_Group_Code having COUNT(*)=@RCount

		SELECT @Dubb_Lang_Code=Dubb_Lang_Code FROM #temp
		SELECT Language_Group_Name,Language_Group_Code FROM Language_Group WHERE Language_Group_Code IN(SELECT number FROM dbo.[fn_Split_withdelemiter](@Dubb_Lang_Code,',') WHERE number!='')
		END
	END
	SELECT Display_Text AS DisplayText,Display_Value AS DisplayValue,PlatformCodes AS PlatformCodes FROM #temp1

	IF OBJECT_ID('tempdb..#FinalListData') IS NOT NULL DROP TABLE #FinalListData
	IF OBJECT_ID('tempdb..#PlatformCodes') IS NOT NULL DROP TABLE #PlatformCodes
	IF OBJECT_ID('tempdb..#RightCodes') IS NOT NULL DROP TABLE #RightCodes
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	IF OBJECT_ID('tempdb..#TitleCodes') IS NOT NULL DROP TABLE #TitleCodes
END