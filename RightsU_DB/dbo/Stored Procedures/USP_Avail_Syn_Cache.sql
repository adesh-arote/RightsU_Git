CREATE PROCEDURE [dbo].[USP_Avail_Syn_Cache] 
	-- Add the parameters for the stored procedure here
	@Syn_Deal_Code INT = 0,
	@AmendYN CHAR(1)= 'N' 
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 7-April-2014
-- Description:	Cache Syndication availability on deal approval
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON;
	/*
	SELECT * FROM Avail_Syn
	SELECT * FROM Avail_Syn_Details
	SELECT * FROM Avail_Syn_Language	
	*/

		
	IF(@AmendYN = 'Y')
	BEGIN
		--UPDATE Avail_Syn SET Syn_Deal_Code=@Syn_Deal_Code WHERE Syn_Deal_Code= 
		--(SELECT SD.Parent_Syn_Deal_Code FROM Syn_Deal SD WHERE Syn_Deal_Code =@Syn_Deal_Code)		
		--SELECT Avail_Syn_Code INTO #TempAA FROM Avail_Syn WHERE Syn_Deal_Code=@Syn_Deal_Code		
		DELETE FROM Avail_Syn_Details WHERE Syn_Deal_Code=@Syn_Deal_Code		
		DELETE FROM Avail_Syn_Language WHERE Syn_Deal_Code=@Syn_Deal_Code		
	END
	
	create table #tmpCache
	(
		Syn_Deal_Code int,
		Title_Code int,
		Platform_Code int,
		Country_Code int,
		Rights_Start_Date datetime,
		Rights_End_Date datetime
		--,Sub_License_Code int
	)	
		
	insert into #tmpCache
	SELECT 
	    SDR.Syn_Deal_Code
		,SDRT.Title_Code
		,SDRP.Platform_Code
		,SDRC.Country_Code
		,SDR.Right_Start_Date
		,SDR.Right_End_Date		
		--,SDR.Sub_License_Code		
	    FROM Syn_Deal_Rights SDR
		INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRP.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Territory SDRC ON SDRC.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Country C ON SDRC.Country_Code=C.Country_Code AND C.Is_Theatrical_Territory='N'
		--INNER JOIN Sub_License SL ON SL.Sub_License_Code=SDR.Sub_License_Code		
		AND Syn_Deal_Code=@Syn_Deal_Code 
		-- Consider only exclusive syndication deals
		AND ISNULL(SDR.Is_Exclusive,'N') = 'Y'  

	--select * from #tmpCache

	--Insert into Table Avail_Syn
	Insert into Avail_Syn (Title_Code,Platform_Code,Country_Code)
	select tmp.Title_Code,tmp.Platform_Code,tmp.Country_Code
	from #tmpCache tmp
		 left join Avail_Syn aa on aa.Title_Code=tmp.Title_Code
		 and aa.Platform_Code=tmp.Platform_Code and aa.Country_Code=tmp.Country_Code
	where isnull(aa.Title_Code,0)=0	;

	--Insert into Table Avail_Syn_Details 
	Insert into Avail_Syn_Details (Avail_Syn_Code,Rights_Start_Date,Rights_End_Date,Syn_Deal_Code)
	select aa.Avail_Syn_Code,tmp.Rights_Start_Date,tmp.Rights_End_Date,tmp.Syn_Deal_Code
	from Avail_Syn aa
	inner join #tmpCache tmp on aa.Title_Code=tmp.Title_Code 
	and aa.Platform_Code=tmp.Platform_Code and aa.Country_Code=tmp.Country_Code 
	

	--Insert into Avail_Syn_Language for Dubbing 
	Insert into Avail_Syn_Language (Avail_Syn_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Syn_Deal_Code)				
	SELECT aa.Avail_Syn_Code,'D',SDRD.Language_Code,sdr.Right_Start_Date,sdr.Right_End_Date,aa.Syn_Deal_Code 
	FROM Syn_Deal_Rights_Dubbing SDRD
		inner join Syn_Deal_Rights sdr on sdr.Syn_Deal_Rights_Code=SDRD.Syn_Deal_Rights_Code
		inner join Avail_Syn_Details aa on aa.Syn_Deal_Code =sdr.Syn_Deal_Code	
	where sdr.Syn_Deal_Code=@Syn_Deal_Code
	
	--Insert into Avail_Syn_Language for Subtitling 
	Insert into Avail_Syn_Language (Avail_Syn_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Syn_Deal_Code)				
	SELECT asd.Avail_Syn_Code,'S',SDRS.Language_Code,sdr.Right_Start_Date,sdr.Right_End_Date,asd.Syn_Deal_Code
	FROM Syn_Deal_Rights_Subtitling SDRS
	inner join Syn_Deal_Rights sdr on sdr.Syn_Deal_Rights_Code=SDRS.Syn_Deal_Rights_Code
	inner join Avail_Syn_Details asd on asd.Syn_Deal_Code=sdr.Syn_Deal_Code 
	where sdr.Syn_Deal_Code=@Syn_Deal_Code
		
	drop table #tmpCache

	/*
	--BEGIN TRAN	
	DECLARE curAvail CURSOR
	READ_ONLY
	FOR 
		SELECT 
	    SDR.Syn_Deal_Rights_Code
		,SDRT.Title_Code
		,SDRP.Platform_Code
		,SDRC.Country_Code
		,SDR.Right_Start_Date
		,SDR.Right_End_Date		
		--,SDR.Sub_License_Code		
	    FROM Syn_Deal_Rights SDR
		INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRT.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRP.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Syn_Deal_Rights_Territory SDRC ON SDRC.Syn_Deal_Rights_Code=SDR.Syn_Deal_Rights_Code
		INNER JOIN Country C ON SDRC.Country_Code=C.Country_Code AND C.Is_Theatrical_Territory='N'
		--INNER JOIN Sub_License SL ON SL.Sub_License_Code=SDR.Sub_License_Code		
		AND Syn_Deal_Code=@Syn_Deal_Code 
		-- Consider only exclusive syndication deals
		AND ISNULL(SDR.Is_Exclusive,'N') = 'Y'    
	
	DECLARE @Syn_Deal_Rights_Code INT,@Title_Code INT,@Platform_Code INT,@Country_Code INT,@RSD DATE,@RED DATE
	OPEN curAvail

	FETCH NEXT FROM curAvail INTO @Syn_Deal_Rights_Code,@Title_Code, @Platform_Code, @Country_Code, @RSD, @RED
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			
			DECLARE @id INT
						
			IF(@AmendYN = 'N')
			BEGIN

				INSERT INTO Avail_Syn (Syn_Deal_Code,Title_Code,Platform_Code,Country_Code)
				SELECT @Syn_Deal_Code,@Title_Code,@Platform_Code,@Country_Code
				SET @id=IDENT_CURRENT('Avail_Syn')
			END
			ELSE 
			BEGIN
				
				SELECT @id=Avail_Syn_Code FROM Avail_Syn
				WHERE Syn_Deal_Code=@Syn_Deal_Code
				AND Title_Code=@Title_Code AND Platform_Code=@Platform_Code
				AND Country_Code =@Country_Code
			END			
			
			INSERT INTO Avail_Syn_Details (Avail_Syn_Code,Rights_Start_Date,Rights_End_Date)
			SELECT @id,@RSD,@RED
			
			DECLARE @Dubbing_Subtitling VARCHAR(2),@Language_Code INT
			
			IF EXISTS (SELECT TOP 1 Language_Code FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
			BEGIN
				SELECT TOP 1 @Language_Code=Language_Code,@Dubbing_Subtitling='D' FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
				INSERT INTO Avail_Syn_Language (Avail_Syn_Code,Dubbing_Subtitling,Rights_Start_Date,Rights_End_Date,Language_Code)
				SELECT @id,@Dubbing_Subtitling,@RSD,@RED,@Language_Code
			END
			
			IF EXISTS (SELECT TOP 1 Language_Code FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code)
			BEGIN
				SELECT TOP 1 @Language_Code=Language_Code,@Dubbing_Subtitling='S' FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
				INSERT INTO Avail_Syn_Language (Avail_Syn_Code,Dubbing_Subtitling,Rights_Start_Date,Rights_End_Date,Language_Code)
				SELECT @id,@Dubbing_Subtitling,@RSD,@RED,@Language_Code
			END
			
		END
		FETCH NEXT FROM curAvail INTO @Syn_Deal_Rights_Code,@Title_Code, @Platform_Code, @Country_Code, @RSD, @RED
	END

	CLOSE curAvail
	DEALLOCATE curAvail
	
	--SELECT @Title_Code=0, @Platform_Code=0, @Country_Code=0, @Language_Code=0, @Dubbing_Subtitling=''
	*/

	print '[USP_Avail_Syn_Cache] proc called'
	EXEC USP_Avail_Syn_Amend @Syn_Deal_Code
	
	
	/*	


	selec
		EXEC [USP_Avail_Syn_Cache] 56,'N'

		EXEC USP_Avail_Syn_Amend 61

		EXEC USP_Cal_Availability 308
		--Availability Calculation
	
		--Avail Acquisition
		SELECT Title_Code,Platform_Code,Country_Code,AVAD.Rights_Start_Date,AVAD.Rights_End_Date
		FROM Availability_Acquisition AVA
		INNER JOIN Availability_Acquisition_Details AVAD ON AVA.Availability_Acquisition_Code=AVAD.Availability_Acquisition_Code
		LEFT JOIN Availability_Acquisition_Language AVAL ON AVA.Availability_Acquisition_Code=AVAL.Availability_Acquisition_Code
		WHERE Title_Code=578 AND Platform_Code=91 AND Country_Code=44
		
		--SELECT * FROM Availability_Acquisition
		--Avail Syndication (Loop on AVS)
		SELECT Title_Code,Platform_Code,Country_Code,AVSD.Rights_Start_Date,AVSD.Rights_End_Date 
		FROM Avail_Syn  AVS
		INNER JOIN Avail_Syn_Details AVSD ON AVS.Avail_Syn_Code=AVSD.Avail_Syn_Code
		LEFT JOIN Avail_Syn_Language AVSL ON AVS.Avail_Syn_Code=AVSL.Avail_Syn_Code
		WHERE Title_Code=578
	*/
	--COMMIT 
END