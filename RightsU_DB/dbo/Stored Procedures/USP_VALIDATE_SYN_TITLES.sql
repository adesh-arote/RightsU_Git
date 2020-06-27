CREATE PROCEDURE [dbo].[USP_VALIDATE_SYN_TITLES]
(
	@TITLE_CODES VARCHAR(MAX),
	@DEAL_CODE INT
)
As
Begin
	SET FMTONLY OFF
	Create Table #Temp(
		Title_Code Int,
		Title_Count int
	)

	
	--Insert InTo #Temp Values (56,3)

	--Select Title_Code,Title_Count  From #Temp
	
	--SET ANSI_NULLS ON
	--SET QUOTED_IDENTIFIER ON
	--SET NOCOUNT ON;

	--DECLARE @TITLE_CODES VARCHAR(MAX), @DEAL_CODE INT	
	--SELECT @TITLE_CODES = '3105,2994', @DEAL_CODE = 342
	--SELECT @TITLE_CODES = '6270, 2099, 6417', @DEAL_CODE = 348

	IF( (select COUNT(number) from dbo.fn_Split_withdelemiter(@Title_Codes,','))  > 1)
	BEGIN

		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Syn_Deal WHERE Syn_Deal_Code = @DEAL_CODE
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

		DECLARE @tableTemp as TABLE 
		(
			Title_Code INT
		)

		IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')
		BEGIN
			INSERT INTO #Temp--@tableTemp(Title_Code) 
			SELECT  DISTINCT SDR.Syn_Deal_Rights_Code,COUNT(SDRT.Syn_Deal_Rights_Code) from Syn_Deal_Rights SDR
			inner join Syn_Deal_Rights_Title SDRT on SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
			INNER JOIN Syn_Deal_Movie SDM on SDM.Syn_Deal_Code = @DEAL_CODE AND SDM.Episode_From = SDRT.Episode_From 
			AND SDM.Episode_End_To = SDRT.Episode_To AND SDM.Title_Code = SDRT.Title_Code
			where SDR.Syn_Deal_Code = @Deal_Code 
			AND SDM.Syn_Deal_Movie_Code in
			(
				select number from dbo.fn_Split_withdelemiter(@Title_Codes,',') 
			)
			AND SDR.Right_Type != 'U'
			GROUP BY SDR.Syn_Deal_Rights_Code, SDR.Right_Type
			having Count(SDM.Syn_Deal_Movie_Code) = Count(SDR.Syn_Deal_Rights_Code) 
		END
		ELSE
		BEGIN
			INSERT INTO #Temp--@tableTemp(Title_Code) 
			SELECT DISTINCT SDR.Syn_Deal_Rights_Code,COUNT(SDRT.Syn_Deal_Rights_Code) from Syn_Deal_Rights SDR
			inner join Syn_Deal_Rights_Title SDRT on SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
			where SDR.Syn_Deal_Code = @Deal_Code 
			AND SDRT.Title_Code in 
			(
				select number from dbo.fn_Split_withdelemiter(@Title_Codes,',') 
			)
			AND SDR.Right_Type != 'U'
			GROUP BY SDR.Syn_Deal_Rights_Code,SDR.Right_Type
			having Count(SDRT.Title_Code ) = Count(SDR.Syn_Deal_Rights_Code) 
		END

		--insert into #Temp 
		--select 0,count(number) as Title_Code   from dbo.fn_Split_withdelemiter(@Title_Codes,',')
		--where number in (select Title_Code from  @tableTemp )
	END
	ELSE 
		insert into #temp values (0,0)
	

	select Title_Code, Title_Count from #Temp
	Drop Table #Temp
End