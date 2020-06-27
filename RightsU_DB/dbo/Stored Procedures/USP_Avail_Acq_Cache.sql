CREATE PROCEDURE [dbo].[USP_Avail_Acq_Cache] 
	-- Add the parameters for the stored procedure here
	@Acq_Deal_Code INT = 0,
	@AmendYN CHAR(1)= 'N' 
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 2-April-2014
-- Description:	Cache Acquisition on deal approval for availability
-- Modified By : Reshma Kunjal
-- =============================================
BEGIN
	-- EXEC [dbo].[USP_Acq_Avail_Cache] @Acq_Deal_Code=50,@AmendYN='N'
	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;
	/*
	SELECT * FROM Title		  -- Movie master
	SELECT * FROM [Platform]  -- Platform master
	SELECT * FROM [Territory] -- Territory  master
	SELECT * FROM [Language]  -- Language  master
	SELECT * FROM Deal		  -- Deals
	SELECT * FROM Deal_Movie WHERE deal_code=184  -- Movie
	SELECT * FROM Deal_Movie_Rights WHERE deal_Movie_code=639 -- Period,Platform
	SELECT * FROM Deal_Movie_Rights_Territory WHERE deal_Movie_rights_code=7564  -- country
	SELECT TOP 1 * FROM Acq_Deal_Rights_Dubbing -- dubbing
	SELECT TOP 1 * FROM Acq_Deal_Rights_Subtitling -- subtitling
	
	SELECT distinct deal_movie_Code,platform_Code,Right_start_Date,Right_end_Date 
	FROM Deal_Movie_Rights -- Period,Platform
	EXEC USP_Acq_Availability_Cache 212,'N'

	SELECT * FROM Avail_Acq
	SELECT * FROM Avail_Acq_Details
	SELECT * FROM Avail_Acq_Language	
	*/
	
	IF(@AmendYN = 'Y')
	BEGIN
		EXEC USP_Avail_Acq_Amend @Acq_Deal_Code
		return;
	END
	
	create table #tmpCache
	(
		Acq_Deal_Code int,
		Title_Code int,
		Platform_Code int,
		Country_Code int,
		Rights_Start_Date datetime,
		Rights_End_Date datetime,
		Sub_License_Code int
	)	

	insert into #tmpCache
	SELECT 
	    ADR.Acq_Deal_Code
		,ADRT.Title_Code
		,ADRP.Platform_Code
		,ADRC.Country_Code
		,ADR.Right_Start_Date
		,ADR.Right_End_Date		  
		,ADR.Sub_License_Code
	FROM 
		Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Territory ADRC ON ADRC.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
		INNER JOIN Country C ON ADRC.Country_Code=C.Country_Code AND C.Is_Theatrical_Territory='N'
	WHERE 
		ADR.Is_Sub_License='Y' and adr.Acq_Deal_Code=@Acq_Deal_Code
	
	--select * from #tmpCache
		
	--Insert into Table Avail_Acq
	Insert into Avail_Acq (Title_Code,Platform_Code,Country_Code,Sub_Licencing_Code)
	select tmp.Title_Code,tmp.Platform_Code,tmp.Country_Code,tmp.Sub_License_Code
	from #tmpCache tmp
		 left join Avail_Acq aa on aa.Title_Code=tmp.Title_Code
		 and aa.Platform_Code=tmp.Platform_Code and aa.Country_Code=tmp.Country_Code and aa.Sub_Licencing_Code=tmp.Sub_License_Code
	where isnull(aa.Title_Code,0)=0	;
				
	--Insert into Table Avail_Acq_Details 
	Insert into Avail_Acq_Details (Avail_Acq_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)
	select aa.Avail_Acq_Code,tmp.Rights_Start_Date,tmp.Rights_End_Date,tmp.Acq_Deal_Code
	from Avail_Acq aa
	inner join #tmpCache tmp on aa.Title_Code=tmp.Title_Code 
	and aa.Platform_Code=tmp.Platform_Code and aa.Country_Code=tmp.Country_Code and aa.Sub_Licencing_Code=tmp.Sub_License_Code
	
	--Insert into Avail_Acq_Language for Dubbing 
	Insert into Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)				
	SELECT aad.Avail_Acq_Code,'D',ADRD.Language_Code,aad.Rights_Start_Date,aad.Rights_End_Date,aad.Acq_Deal_Code
	FROM Acq_Deal_Rights_Dubbing ADRD
		inner join Acq_Deal_Rights adr on adr.Acq_Deal_Rights_Code=ADRD.Acq_Deal_Rights_Code
		inner join Avail_Acq_Details aad on aad.Acq_Deal_Code =adr.Acq_Deal_Code 
	where adr.Acq_Deal_Code=@Acq_Deal_Code
	
	--Insert into Avail_Acq_Language for Subtitling 
	Insert into Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Language_Code,Rights_Start_Date,Rights_End_Date,Acq_Deal_Code)				
	SELECT aad.Avail_Acq_Code,'S',ADRS.Language_Code,aad.Rights_Start_Date,aad.Rights_End_Date,aad.Acq_Deal_Code
	FROM Acq_Deal_Rights_Subtitling ADRS
	inner join Acq_Deal_Rights adr on adr.Acq_Deal_Rights_Code=ADRS.Acq_Deal_Rights_Code
	inner join Avail_Acq_Details aad on aad.Acq_Deal_Code=adr.Acq_Deal_Code 
	where adr.Acq_Deal_Code=@Acq_Deal_Code
		
	drop table #tmpCache

	print 'Data Inserted successfully'
	----BEGIN TRAN	
	--DECLARE curAvail CURSOR
	--READ_ONLY
	--FOR 
	--SELECT 
	--     ADR.Acq_Deal_Rights_Code
	--	,ADRT.Title_Code
	--	,ADRP.Platform_Code
	--	,ADRC.Country_Code
	--	,ADR.Right_Start_Date
	--	,ADR.Right_End_Date		  
	--	,ADR.Sub_License_Code
	--	,ADRC.Territory_Code
	--	,ADRC.Territory_Type
	--	--,SL.Sub_License_Name
	--	FROM Acq_Deal_Rights ADR
	--	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
	--	INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADRP.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
	--	INNER JOIN Acq_Deal_Rights_Territory ADRC ON ADRC.Acq_Deal_Rights_Code=ADR.Acq_Deal_Rights_Code
	--	INNER JOIN Country C ON ADRC.Country_Code=C.Country_Code AND C.Is_Theatrical_Territory='N'
	--	--INNER JOIN Sub_License SL ON SL.Sub_License_Code=ADR.Sub_License_Code
	--	WHERE ADR.Is_Sub_License='Y'
	--	And Acq_Deal_Code = @Acq_Deal_Code 

	--DECLARE @Acq_Deal_Rights_Code INT,@Title_Code INT,@Platform_Code INT,@Country_Code INT,@RSD DATE,@RED DATE
	--        ,@Sub_License_Code INT,@Territory_Code INT,@Territory_Type CHAR(1)
	--OPEN curAvail

	--FETCH NEXT FROM curAvail INTO @Acq_Deal_Rights_Code,@Title_Code, @Platform_Code, @Country_Code, @RSD, @RED
	--	       ,@Sub_License_Code,@Territory_Code,@Territory_Type
	--WHILE (@@fetch_status <> -1)
	--BEGIN
	--	IF (@@fetch_status <> -2)
	--	BEGIN
	--		DECLARE @id INT
	--		--,@Sub_License_Code VARCHAR(2)
			
	--		--IF(@Is_Sub_License = 'N') SET @Sub_License_Code = 'SN' -- Sublicensing No
	--		--ELSE
	--		--BEGIN  
	--		--	IF(@isPriorApproval = 'Y') SET @Sub_License_Code = 'PA'	-- Prior Approval
	--		--	ELSE IF (@isPriorApproval = 'Y') SET @Sub_License_Code = 'PN'	-- Prior Notice
	--		--	ELSE SET @Sub_License_Code = 'NR'	-- No Restriction
	--		--END
			
	--		IF(@AmendYN = 'N')
	--		BEGIN
	--			INSERT INTO Avail_Acq (Acq_Deal_Code,Title_Code,Platform_Code,Country_Code,Sub_Licencing_Code,Territory_Code,Territory_Type)
	--			SELECT @Acq_Deal_Code,@Title_Code,@Platform_Code,@Country_Code,@Sub_License_Code,@Territory_Code,@Territory_Type
	--			SET @id=IDENT_CURRENT('Avail_Acq')
	--		END
	--		ELSE 
	--		BEGIN
	--			SELECT @id=Avail_Acq_Code 
	--			FROM Avail_Acq
	--			WHERE Acq_Deal_Code=@Acq_Deal_Code
	--			AND Title_Code=@Title_Code 
	--			AND Platform_Code=@Platform_Code
	--			AND Country_Code =@Country_Code
	--		END			
			
	--		INSERT INTO Avail_Acq_Details (Avail_Acq_Code,Rights_Start_Date,Rights_End_Date)
	--		SELECT @id,@RSD,@RED
			
	--		--DECLARE @Dubbing_Subtitling VARCHAR(2),@Language_Code INT
			
	--		IF EXISTS (SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
	--		BEGIN
	--			INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Rights_Start_Date,Rights_End_Date,Language_Code)
	--			SELECT @id,'D',@RSD,@RED,ADRD.Language_Code 
	--			FROM Acq_Deal_Rights_Dubbing ADRD
	--			INNER JOIN Country_Language CL ON CL.Language_Code=ADRD.Language_Code
	--			WHERE ADRD.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
	--		END
			
	--		IF EXISTS (SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
	--		BEGIN
	--			INSERT INTO Avail_Acq_Language (Avail_Acq_Code,Dubbing_Subtitling,Rights_Start_Date,Rights_End_Date,Language_Code)
	--			SELECT @id,'S',@RSD,@RED,ADRS.Language_Code
	--			FROM Acq_Deal_Rights_Subtitling ADRS
	--			INNER JOIN Country_Language CL ON CL.Language_Code=ADRS.Language_Code
	--			WHERE ADRS.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
	--		END
	--		--PRINT @id
	----		PRINT 'add user defined code here'
	----		eg.
	--		--DECLARE @message varchar(100)
	--		--SELECT @message = 'my title is: ' + ' ' + CAST(@Title_Code as varchar) + ' ' + CAST(@Platform_Code as varchar) + ' ' + CAST(@Country_Code as varchar)
	--		--PRINT @message
	--	END 
	--	FETCH NEXT FROM curAvail INTO @Acq_Deal_Rights_Code,@Title_Code, @Platform_Code, @Country_Code, @RSD, @RED,@Sub_License_Code,@Territory_Code,@Territory_Type
	--END

	--CLOSE curAvail
	--DEALLOCATE curAvail	
		
	----COMMIT 
	
END