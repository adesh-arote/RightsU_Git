CREATE PROCEDURE [dbo].[USP_Import_Acq_Deal_Movie_Contents_Title]
(
	@Acq_Deal_Movie_Contents_Import Acq_Deal_Movie_Contents_Import READONLY,
	@Deal_Code INT
)
AS
-- =============================================
-- Author:		Anchal Sikarwar
-- Create date: 18 Feb 2016
-- Description:	Update Title Name
-- =============================================
BEGIN

IF OBJECT_ID('tempdb..#tempContent') IS NOT NULL
	BEGIN
		DROP TABLE #tempContent
	END
	Create table #tempContent
	(
		ID INT IDENTITY (1,1),
		[Acq_Deal_Movie_Content_Code]      INT,
		[Episode_Title]      VARCHAR (100)  NULL
	)

		DECLARE @Error_Message	VARCHAR(5000),@ECount INT,@DCount INT
		SET @Error_Message='Uploaded Succeccfully'
		select @ECount = COUNT(Acq_Deal_Movie_Content_Code) from #tempContent
		select @DCount = COUNT(DISTINCT(Acq_Deal_Movie_Content_Code)) from #tempContent
		IF(@ECount!=@DCount)
		BEGIN
		SET @Error_Message='PLease do not Acq_Deal_Movie_Content_Code';
		END
		INSERT INTO #tempContent(Acq_Deal_Movie_Content_Code,Episode_Title)
		SELECT  
			 [Acq_Deal_Movie_Content_Code], [Episode_Title]    
		FROM @Acq_Deal_Movie_Contents_Import 

		Declare  @Acq_Deal_Movie_Content_Code INT,@Duration INT,@Episode_Title VARCHAR(500)

		Declare curOuter cursor For select DISTINCT Acq_Deal_Movie_Content_Code,Duration,Episode_Title from  #tempContent
			OPEN curOuter 
			
			Fetch Next From curOuter Into @Acq_Deal_Movie_Content_Code,@Duration,@Episode_Title 
			WHILE @@Fetch_Status = 0 
			BEGIN	
			Update Acq_Deal_Movie_Contents set Episode_Title=@Episode_Title, Duration=@Duration where Acq_Deal_Movie_Content_Code=@Acq_Deal_Movie_Content_Code
			AND @Episode_Title!=''
			Fetch Next From curOuter Into @Acq_Deal_Movie_Content_Code,@Duration,@Episode_Title 
			END
		CLOSE curOuter 
		Deallocate curOuter 

		select @Error_Message
		END
