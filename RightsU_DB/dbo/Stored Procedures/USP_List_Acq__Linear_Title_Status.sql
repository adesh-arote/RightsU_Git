CREATE PROCEDURE [dbo].[USP_List_Acq	_Linear_Title_Status]
(
	@Acq_Deal_Code INT
)
---- =============================================
---- Author:	Akshay Rane
---- Create date: 25 Oct 2018
---- Description: Get List Of Linear 
---- =============================================
AS
BEGIN
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq	_Linear_Title_Status]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	--DECLARE @Acq_Deal_Code INT = 21930

	IF OBJECT_ID('tempdb..#Linear_Title_Status') IS NOT NULL
		DROP TABLE #Linear_Title_Status

	CREATE TABLE #Linear_Title_Status(
		Title_Name NVARCHAR(MAX),
		Linear_Status VARCHAR(10)
	)

	DECLARE @DealTypeName NVARCHAR(1000)

	SELECT @DealTypeName =  dt.Deal_Type_Name 
	FROM acq_deal ad INNER JOIN Deal_Type dt ON ad.Deal_Type_Code = dt.Deal_Type_Code AND ad.Acq_Deal_Code = @Acq_Deal_Code

	IF(UPPER(@DealTypeName) = 'PROGRAM')
	BEGIN

		INSERT INTO #Linear_Title_Status (Title_Name, Linear_Status)
		Select t.Title_Name +'('+ CAST(a.Episode_From AS VARCHAR(100)) +' - '+ CAST(a.Episode_To AS VARCHAR(100)) +')' ,'Yes' from (
		select distinct Title_Code,Episode_From,Episode_To from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code in 
		(	select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
			EXCEPT
			select distinct Title_Code,Episode_From,Episode_To from Acq_Deal_Run_Title where Acq_Deal_Run_Code in (
			select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)
		) as a inner join Title t on t.Title_Code = a.Title_Code

		INSERT INTO #Linear_Title_Status (Title_Name, Linear_Status)
		select distinct t.Title_Name +'('+ CAST(ADRT.Episode_From AS VARCHAR(100)) +' - '+ CAST(ADRT.Episode_To AS VARCHAR(100)) +')' ,'No' 
		from Acq_Deal_Run_Title ADRT
		inner join Title t on t.Title_Code = ADRT.Title_Code
		where ADRT.Acq_Deal_Run_Code in (
		select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)

	END
	ELSE
	BEGIN

		INSERT INTO #Linear_Title_Status (Title_Name, Linear_Status)
		Select t.Title_Name ,'Yes' from(
		select distinct Title_Code from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code in 
		(	select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
			EXCEPT
			select distinct Title_Code from Acq_Deal_Run_Title where Acq_Deal_Run_Code in (
			select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)
		) as a inner join Title t on t.Title_Code = a.Title_Code

		INSERT INTO #Linear_Title_Status (Title_Name, Linear_Status)
		select distinct  t.Title_Name ,'No' from Acq_Deal_Run_Title ADRT 
		inner join Title t on t.Title_Code = ADRT.Title_Code
		where ADRT.Acq_Deal_Run_Code in (
		select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)

	END

	SELECT Title_Name, Linear_Status FROM #Linear_Title_Status order by Title_Name

	IF OBJECT_ID('tempdb..#Linear_Title_Status') IS NOT NULL DROP TABLE #Linear_Title_Status
 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq	_Linear_Title_Status]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END