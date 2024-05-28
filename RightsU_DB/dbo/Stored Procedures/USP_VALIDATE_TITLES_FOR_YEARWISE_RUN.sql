CREATE Procedure [dbo].[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]
	@TITLE_CODES VARCHAR(MAX),
	@DEAL_CODE INT	
AS
/*
-- Author:	 Bhavesh Desai	
-- Create DATE: 22 Oct 2014
-- Description: It is used for validating TITLES with the RIGHT Combination i.e are they from the same right or not
*/

BEGIN
Declare @Loglevel int
select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]', 'Step 1', 0, 'Started Procedure', 0, ''
	Create Table #Temp(
		Title_Code Int,
		Title_Count int
	)

	--Insert InTo #Temp Values (56,3)

	--Select Title_Code,Title_Count  From #Temp
	
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	--DECLARE @TITLE_CODES VARCHAR(MAX), @DEAL_CODE INT	
	--SELECT @TITLE_CODES = '3105,2994', @DEAL_CODE = 342
	--SELECT @TITLE_CODES = '6270, 2099, 6417', @DEAL_CODE = 348

	--IF( (select COUNT(number) from dbo.fn_Split_withdelemiter(@Title_Codes,','))  > 1)
	BEGIN

		DECLARE @Deal_Type_Code_Movie INT = 0, @Selected_Deal_Type_Code INT = 0
		SELECT TOP 1 @Deal_Type_Code_Movie = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Movie'
		SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @DEAL_CODE

		DECLARE @tableTemp as TABLE 
		(
			Title_Code INT
		)

		IF(@Selected_Deal_Type_Code = @Deal_Type_Code_Movie)
		BEGIN
			
			INSERT INTO @tableTemp(Title_Code) 
			SELECT  DISTINCT ADRT.Title_Code from Acq_Deal_Rights ADR (NOLOCK) --ADRT.Title_Code
			inner join Acq_Deal_Rights_Title ADRT (NOLOCK) on ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) on ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
			where ADR.Acq_Deal_Code = @Deal_Code 
			AND ADRT.Title_Code in 
			(
				select number from dbo.fn_Split_withdelemiter(@Title_Codes,',') 
			)
			AND ADR.Right_Type != 'U'
			GROUP BY ADRT.Title_Code ,ADR.Acq_Deal_Rights_Code,ADR.Right_Type
			having Count(ADRT.Title_Code ) = Count(ADR.Acq_Deal_Rights_Code) 
		END
		ELSE
		BEGIN
			INSERT INTO @tableTemp(Title_Code) 
			SELECT  DISTINCT ADM.Acq_Deal_Movie_Code from Acq_Deal_Rights ADR (NOLOCK) --ADM.Acq_Deal_Movie_Code
			inner join Acq_Deal_Rights_Title ADRT (NOLOCK) on ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Movie ADM (NOLOCK) on ADM.Acq_Deal_Code = @DEAL_CODE AND ADM.Episode_Starts_From = ADRT.Episode_From 
			INNER JOIN Acq_Deal_Rights_Platform ADRP (NOLOCK) on ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			INNER JOIN Platform P (NOLOCK) ON P.Platform_Code = ADRP.Platform_Code AND p.Is_No_Of_Run = 'Y'
			AND ADM.Episode_End_To = ADRT.Episode_To AND ADM.Title_Code = ADRT.Title_Code
			where ADR.Acq_Deal_Code = @Deal_Code 
			AND ADM.Acq_Deal_Movie_Code in
			(
				select number from dbo.fn_Split_withdelemiter(@Title_Codes,',') 
			)
			AND ADR.Right_Type != 'U'
			GROUP BY ADM.Acq_Deal_Movie_Code,  ADR.Acq_Deal_Rights_Code, ADR.Right_Type
			having Count(ADM.Acq_Deal_Movie_Code) = Count(ADR.Acq_Deal_Rights_Code) 

		END

		insert into #Temp 
		select 0,Title_Code 
		from  @tableTemp
		--select 0,count(number) as Title_Code   from dbo.fn_Split_withdelemiter(@Title_Codes,',')
		--where number in (select Title_Code from  @tableTemp )
	END
	--ELSE 
	--	insert into #temp values (0,0)

	--declare @Title_Code int
	--set @Title_Code=5
	--return  @Title_Code
	--Select 1 Title_Code
	select * from #Temp
	--Drop Table #Temp
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END