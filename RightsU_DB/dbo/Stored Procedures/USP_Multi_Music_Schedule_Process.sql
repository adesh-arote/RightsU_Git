CREATE PROCEDURE [dbo].[USP_Multi_Music_Schedule_Process]
	@Music_Content_Assignment_UDT  Music_Content_Assignment_UDT READONLY
AS

-- =============================================
-- Author:		Akshay R. Rane
-- Create DATE: 15-February-2017
-- Description:	Get Multi Music Schedule Process for Music Track Assignment
-- =============================================

--SET NOCOUNT ON;
	--DECLARE @Music_Content_Assignment_UDT Music_Content_Assignment_UDT
	--INSERT INTO @Music_Content_Assignment_UDT(Title_Content_Code,[From],From_Frame ,[To],To_Frame,Music_Title_Code,[Duration],[Duration_Frame])
	--VALUES
	--(4061,'00:03:00',3,'00:04:03',5,3111, '00:00:00', 0),
	--(4062,'00:03:00',3,'00:04:03',5,3111, '00:00:00', 0),
	--(4063,'00:03:00',3,'00:04:03',5,3112, '00:00:00', 0),
	--(4064,'00:03:00',3,'00:04:03',5,3112, '00:00:00', 0),
	--(3903,'12:00:00',56,'12:83:00',5,3115, '00:02:00', 0),
	--(3903,'12:00:00',56,'12:83:00',5,3115, '00:02:00', 0),
	--(3903,'12:00:00',56,'12:83:00',5,3115, '00:02:00', 0)
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Multi_Music_Schedule_Process]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)
			DROP TABLE #Temp

		IF(OBJECT_ID('TEMPDB..#Title_Episode') IS NOT NULL)
			DROP TABLE #Title_Episode

		CREATE TABLE #Title_Episode
		(	
			RowNo INT IDENTITY(1,1),	
			Title_Code INT NULL,
			Episode_No INT NULL,
			IsProcessed CHAR(1) DEFAULT('N')
		)

		CREATE TABLE #Temp
		(
			Title_Content_Code INT NULL,
			[From] VARCHAR (8) NULL,--TCN INT
			From_Frame INT NULL,
			[To] VARCHAR (8)NULL, -- --TCN OUT
			To_Frame INT NULL,
			Duration VARCHAR (8)  NULL, --Diff b/w TCN IN and TCN OUT
			Duration_Frame INT NULL,
			Music_Title_Code INT NULL,
		)
		INSERT INTO #Temp
		(
			Title_Content_Code,
			[From],
			From_Frame,
			[To],
			To_Frame,
			Duration,
			Duration_Frame,
			Music_Title_Code
		)
		SELECT Title_Content_Code,[From],From_Frame ,[To],To_Frame,Duration,Duration_Frame,Music_Title_Code
		FROM @Music_Content_Assignment_UDT

		INSERT INTO #Title_Episode
		(
			Title_Code,
			Episode_No
		)
		SELECT distinct TC.Title_Code ,TC.Episode_No FROM #Temp inner join Title_Content TC on TC.Title_Content_Code = #Temp.Title_Content_Code  

		DECLARE @RowNo INT = 0
		DECLARE @Status CHAR = 'Y'
		SELECT TOP 1 @RowNo = RowNo FROM #Title_Episode WHERE IsProcessed = 'N'

		WHILE(@RowNo > 0)
		BEGIN
			DECLARE @Title_Code INT = 0,  @Episode_No INT = 0

			select @Title_Code = Title_Code, @Episode_No = Episode_No from #Title_Episode WHERE RowNo = @RowNo	

			EXEC USP_Music_Schedule_Process @Title_Code,@Episode_No,0,0,'AM'
		
			UPDATE #Title_Episode SET IsProcessed  = 'Y' WHERE  RowNo = @RowNo
			SELECT @RowNo = 0
			SELECT TOP 1 @RowNo = RowNo FROM #Title_Episode WHERE IsProcessed = 'N'
		END

		SELECT @Status AS [Status]
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#Temp.Title_Content_Code') IS NOT NULL DROP TABLE #Temp.Title_Content_Code
		IF OBJECT_ID('tempdb..#Title_Episode') IS NOT NULL DROP TABLE #Title_Episode
	 
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Multi_Music_Schedule_Process]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END