CREATE PROCEDURE [dbo].[USP_Import_Acq_Deal_Movie_Contents_Title_UDT]
(
	@Acq_Deal_Movie_Contents_Import_UDT Acq_Deal_Movie_Contents_Import_UDT READONLY,
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
		[Episode_Title]      NVARCHAR(100)  NULL,
		[Duration]  decimal(18,2)
	)

	INSERT INTO #tempContent(Acq_Deal_Movie_Content_Code,Episode_Title,Duration)
		SELECT  
			 [Acq_Deal_Movie_Content_Code], [Episode_Title],[Duration]  
		FROM @Acq_Deal_Movie_Contents_Import_UDT 
		DECLARE @Err_Message	NVARCHAR(MAX),@ECount INT,@DCount INT
		SET @Err_Message='S~Uploaded Succeccfully'
		select @ECount = COUNT(Acq_Deal_Movie_Content_Code) from #tempContent
		select @DCount = COUNT(DISTINCT(Acq_Deal_Movie_Content_Code)) from #tempContent
		IF(@ECount!=@DCount)
		BEGIN
			SET @Err_Message='E~PLease do not fill Acquisition Deal Movie Content Code more then one Time'
		END
		ELSE
		BEGIN
			Declare  @Acq_Deal_Movie_Content_Code INT,@Duration decimal(18,2),@Episode_Title NVARCHAR(500)

			Declare curOuter cursor For select DISTINCT Acq_Deal_Movie_Content_Code,Duration,Episode_Title from  #tempContent
				OPEN curOuter 
			
				Fetch Next From curOuter Into @Acq_Deal_Movie_Content_Code,@Duration,@Episode_Title 
				WHILE @@Fetch_Status = 0 
				BEGIN	
				
					IF(@Episode_Title!='' AND @Duration IS NOT NULL)
						BEGIN
							Update Acq_Deal_Movie_Contents set Episode_Title=@Episode_Title,Duration=@Duration where Acq_Deal_Movie_Content_Code=@Acq_Deal_Movie_Content_Code
						END
						ELSE IF(@Episode_Title!='')
						BEGIN 
							Update Acq_Deal_Movie_Contents set Episode_Title=@Episode_Title where Acq_Deal_Movie_Content_Code=@Acq_Deal_Movie_Content_Code
						END
						ELSE IF(@Duration!=null)
						BEGIN 
							Update Acq_Deal_Movie_Contents set Duration=@Duration where Acq_Deal_Movie_Content_Code=@Acq_Deal_Movie_Content_Code
						END
				
				Fetch Next From curOuter Into @Acq_Deal_Movie_Content_Code,@Duration,@Episode_Title 
				END
			CLOSE curOuter 
			Deallocate curOuter 
		END
		select @Err_Message AS Err_Message
		END

--select * from Acq_Deal_Movie_Contents

--		Declare @Acq_Deal_Movie_Contents_Import_UDT Acq_Deal_Movie_Contents_Import_UDT 
--		insert into @Acq_Deal_Movie_Contents_Import_UDT values(42,'acb',null)
--		insert into @Acq_Deal_Movie_Contents_Import_UDT values(45,'def',20)
--		exec USP_Import_Acq_Deal_Movie_Contents_Title_UDT @Acq_Deal_Movie_Contents_Import_UDT,1
