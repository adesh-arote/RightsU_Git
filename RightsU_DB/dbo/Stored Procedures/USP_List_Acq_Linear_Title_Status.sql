
CREATE PROCEDURE [dbo].[USP_List_Acq_Linear_Title_Status]
(
	@Acq_Deal_Code INT
)
AS
-- =============================================
-- Author:	Akshay Rane
-- Create date: 25 Oct 2017
-- Description: Get List Of Linear
-- =============================================

BEGIN


	SET FMTONLY OFF;
	SET NOCOUNT ON;
	
	--DECLARE @Acq_Deal_Code INT = (select top 1 Acq_Deal_Code from Acq_Deal where Agreement_No = 'A-2018-00356')

	IF OBJECT_ID('tempdb..#Linear_Title_Status') IS NOT NULL
		DROP TABLE #Linear_Title_Status

	CREATE TABLE #Linear_Title_Status(
		Title_Code INT,
		Title_Name NVARCHAR(MAX),
		Title_Added VARCHAR(10),
		Runs_Added VARCHAR(10)
	)

	DECLARE @DealTypeName NVARCHAR(1000), @COUNT INT = 0

	SELECT @DealTypeName =  dt.Deal_Type_Name 
	FROM acq_deal ad INNER JOIN Deal_Type dt ON ad.Deal_Type_Code = dt.Deal_Type_Code AND ad.Acq_Deal_Code = @Acq_Deal_Code

	IF(UPPER(@DealTypeName) = 'PROGRAM')
	BEGIN
		PRINT 'Deal Type name is Program'
		--DECLARE @COUNT INT = 0
		
		select @COUNT = Count(*) from (SELECT Title_Code,Episode_From,Episode_To 
		from Acq_Deal_Run_Title 
		where Acq_Deal_Run_Code in (select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)) as a
		
		IF(@COUNT > 0)
		BEGIN
			PRINT '		If atleast one linear rights title has run defination'

			INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
			Select T.Title_Code,t.Title_Name +' ('+ CAST(a.Episode_From AS VARCHAR(100)) +' - '+ CAST(a.Episode_To AS VARCHAR(100)) +')' ,'Yes','No' from (
				SELECT DISTINCT Title_Code,Episode_From,Episode_To from Acq_Deal_Rights_Title ADRT
				INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
				INNER JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code
				WHERE -- P.Base_Platform_Code = 35 AND
				ADRT.Acq_Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = 15327)
				EXCEPT
				select distinct Title_Code,Episode_From,Episode_To from Acq_Deal_Run_Title where Acq_Deal_Run_Code in (select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)
			) as a inner join Title t on t.Title_Code = a.Title_Code
		END
		ELSE
		BEGIN
			PRINT '		If no other linear rights title has run defination'

			INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
			SELECT DISTINCT T.Title_Code , t.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR(100)) +' - '+ CAST(ADRT.Episode_To AS VARCHAR(100)) +')' ,'Yes','No'
			FROM  Acq_Deal_Rights_Title ADRT  
			INNER JOIN Title t on t.Title_Code = ADRT.Title_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code
			WHERE -- P.Base_Platform_Code = 35 AND
			 ADRT.Acq_Deal_Rights_Code  IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code)

			--INSERT INTO #Linear_Title_Status (Title_Name, Title_Added, Runs_Added)
			--Select t.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR(100)) +' - '+ CAST(ADRT.Episode_To AS VARCHAR(100)) +')' ,'Yes','No'
			--from  Acq_Deal_Rights_Title ADRT  inner join Title t on t.Title_Code = ADRT.Title_Code
			--where Acq_Deal_Rights_Code  in (
			--select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)

		END
		
		INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
		select distinct T.Title_Code, t.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR(100)) +' - '+ CAST(ADRT.Episode_To AS VARCHAR(100)) +')' ,'Yes','Yes' 
		from Acq_Deal_Run_Title ADRT
		inner join Title t on t.Title_Code = ADRT.Title_Code
		where ADRT.Acq_Deal_Run_Code in (select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)

		INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
		Select T.Title_Code, t.Title_Name +' ('+ CAST(a.Episode_Starts_From AS VARCHAR(100)) +' - '+ CAST(a.Episode_End_To AS VARCHAR(100)) +')' ,'No','No' from(
		select Title_Code, Episode_Starts_From, Episode_End_To from Acq_Deal_Movie where Acq_Deal_Code  = @Acq_Deal_Code
		except
		select distinct Title_Code, Episode_From, Episode_To from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code in (select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
		) as a inner join Title t on t.Title_Code = a.Title_Code

	END
	ELSE
	BEGIN
		PRINT 'Deal Type name is not PROGRAM'
		select @COUNT = Count(*) from (SELECT Title_Code
		from Acq_Deal_Run_Title 
		where Acq_Deal_Run_Code in (select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)) as a
		
		IF(@COUNT > 0)
		BEGIN
			PRINT '		If atleast one linear rights title has run defination'

			INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
			Select T.Title_Code, t.Title_Name ,'Yes','No' from(
				SELECT DISTINCT Title_Code FROM Acq_Deal_Rights_Title ADRT
				INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
				INNER JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code
				WHERE -- P.Base_Platform_Code = 35 AND
				ADRT.Acq_Deal_Rights_Code IN (select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
				EXCEPT
				select distinct Title_Code from Acq_Deal_Run_Title where Acq_Deal_Run_Code in (select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)
			) as a inner join Title t on t.Title_Code = a.Title_Code

		END
		ELSE
		BEGIN
			PRINT '		If no other linear rights title has run defination'

			INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
			SELECT DISTINCT  T.Title_Code, t.Title_Name ,'Yes','No' 
			FROM  Acq_Deal_Rights_Title ADRT  
			INNER JOIN Title t on t.Title_Code = ADRT.Title_Code
			INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code
			WHERE  --P.Base_Platform_Code = 35 AND
			ADRT.Acq_Deal_Rights_Code  in (select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)

		END

		INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
		select distinct  T.Title_Code, t.Title_Name ,'Yes','Yes' from Acq_Deal_Run_Title ADRT inner join Title t on t.Title_Code = ADRT.Title_Code
		where ADRT.Acq_Deal_Run_Code in (
		select Acq_Deal_Run_Code from Acq_Deal_Run where Acq_Deal_Code = @Acq_Deal_Code)


		INSERT INTO #Linear_Title_Status (Title_Code, Title_Name, Title_Added, Runs_Added)
		Select  T.Title_Code,  t.Title_Name ,'No','No' from(
		select Title_Code from Acq_Deal_Movie where Acq_Deal_Code  = @Acq_Deal_Code
		except
		select distinct Title_Code from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code in (select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
		) as a inner join Title t on t.Title_Code = a.Title_Code

	END

	UPDATE A SET A.Title_Added =  CASE WHEN A.Runs_Added <> 'Yes' THEN 'Yes~' ELSE 'Yes' END  
	FROM #Linear_Title_Status A
	INNER JOIN (
		SELECT DISTINCT LTS.Title_Code FROM #Linear_Title_Status LTS
		INNER JOIN  Acq_Deal_Rights_Title ADRT ON LTS.Title_Code = ADRT.Title_Code 
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		LEFT JOIN [Platform] P ON P.Platform_Code = ADRP.Platform_Code
		WHERE P.Is_No_Of_Run = 'Y' AND ADRT.Acq_Deal_Rights_Code  in (select Acq_Deal_Rights_Code from acq_deal_rights where Acq_Deal_Code = @Acq_Deal_Code)
	) AS B ON A.Title_Code = B.Title_Code
	
	SELECT Title_Name, Title_Added, Runs_Added FROM #Linear_Title_Status order by Title_Name

	DROP Table #Linear_Title_Status

	--SELECT '' as Title_Name,'' as Title_Added, '' as Runs_Added
END

--exec [USP_List_Acq_Linear_Title_Status] 15342

