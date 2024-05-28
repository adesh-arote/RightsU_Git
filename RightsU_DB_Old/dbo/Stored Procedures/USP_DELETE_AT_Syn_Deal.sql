CREATE PROCEDURE [dbo].[USP_DELETE_AT_Syn_Deal]
(
	@AT_Syn_Deal_Code VARCHAR(MAX),
	@Debug Char(1) = 'N'
)
AS
-- =============================================
-- Author:		SAGAR MAHAHJAN
-- Create DATE: 12-NOV-2014
-- Description:	DELETE Acq Deal Call From Acq Deal List Page
-- =============================================
BEGIN
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION;

---------------------------------------Start Run-------------

DELETE FROM [dbo].[AT_Syn_Deal_Run_Repeat_On_Day] WHERE AT_Syn_Deal_Run_Code 
IN (SELECT AT_Syn_Deal_Run_Code FROM [dbo].[AT_Syn_Deal_Run] WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code)

DELETE FROM [dbo].[AT_Syn_Deal_Run_Yearwise_Run] WHERE AT_Syn_Deal_Run_Code 
IN (SELECT AT_Syn_Deal_Run_Code FROM [dbo].[AT_Syn_Deal_Run] WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code)

DELETE FROM [dbo].[AT_Syn_Deal_Run_Platform] WHERE AT_Syn_Deal_Run_Code 
IN (SELECT AT_Syn_Deal_Run_Code FROM [dbo].[AT_Syn_Deal_Run] WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code)

--Print 'ad'

DELETE FROM [dbo].[AT_Syn_Deal_Run] WHERE AT_Syn_Deal_Code = @AT_Syn_Deal_Code

--Print 'ad'

-------------------------------------Complete Run----------------------------------

---------------------------------------Start General Tab------------



---------------------------------------End General Tab--------------
---------------------------------------Start Rights Tab-------------
--Holdback
DELETE FROM AT_Syn_Deal_Rights_Holdback_Platform WHERE AT_Syn_Deal_Rights_Holdback_Code IN
(
	SELECT AT_Syn_Deal_Rights_Holdback_Code FROM AT_Syn_Deal_Rights_Holdback 
	WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Holdback_Territory WHERE AT_Syn_Deal_Rights_Holdback_Code IN
(
	SELECT AT_Syn_Deal_Rights_Holdback_Code FROM AT_Syn_Deal_Rights_Holdback 
	WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Holdback_Dubbing WHERE AT_Syn_Deal_Rights_Holdback_Code IN
(
	SELECT AT_Syn_Deal_Rights_Holdback_Code FROM AT_Syn_Deal_Rights_Holdback 
	WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
)
DELETE FROM AT_Syn_Deal_Rights_Holdback_Subtitling WHERE AT_Syn_Deal_Rights_Holdback_Code IN
(
	SELECT AT_Syn_Deal_Rights_Holdback_Code FROM AT_Syn_Deal_Rights_Holdback 
	WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Holdback WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)

--Blackout
DELETE FROM AT_Syn_Deal_Rights_Blackout_Platform WHERE AT_Syn_Deal_Rights_Blackout_Code IN
(
	SELECT AT_Syn_Deal_Rights_Blackout_Code FROM AT_Syn_Deal_Rights_Blackout 
WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Blackout_Territory WHERE AT_Syn_Deal_Rights_Blackout_Code IN
(
	SELECT AT_Syn_Deal_Rights_Blackout_Code FROM AT_Syn_Deal_Rights_Blackout 
	WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Blackout_Dubbing WHERE AT_Syn_Deal_Rights_Blackout_Code IN
(
SELECT AT_Syn_Deal_Rights_Blackout_Code FROM AT_Syn_Deal_Rights_Blackout 
WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
)
DELETE FROM AT_Syn_Deal_Rights_Blackout_Subtitling WHERE AT_Syn_Deal_Rights_Blackout_Code IN
(
	SELECT AT_Syn_Deal_Rights_Blackout_Code FROM AT_Syn_Deal_Rights_Blackout 
WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
) 
DELETE FROM AT_Syn_Deal_Rights_Blackout WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)
--Rights
DELETE FROM AT_Syn_Deal_Rights_Title WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)

DELETE FROM AT_Syn_Deal_Rights_Platform WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)
DELETE FROM AT_Syn_Deal_Rights_Territory WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)
DELETE FROM AT_Syn_Deal_Rights_Subtitling WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)

DELETE FROM AT_Syn_Deal_Rights_Dubbing WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)
DELETE FROM AT_Syn_Deal_Rights_Promoter_Group WHERE AT_Syn_Deal_Rights_Promoter_Code IN
(
SELECT AT_Syn_Deal_Rights_Promoter_Code FROM AT_Syn_Deal_Rights_Promoter 
WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
)
DELETE FROM AT_Syn_Deal_Rights_Promoter_Remarks WHERE AT_Syn_Deal_Rights_Promoter_Code IN
(
SELECT AT_Syn_Deal_Rights_Promoter_Code FROM AT_Syn_Deal_Rights_Promoter 
WHERE AT_Syn_Deal_Rights_Code IN
	(
		SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
		WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
)
DELETE FROM AT_Syn_Deal_Rights_Promoter WHERE AT_Syn_Deal_Rights_Code IN
(
	SELECT AT_Syn_Deal_Rights_Code FROM AT_Syn_Deal_Rights 
	WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
)

DELETE FROM AT_Syn_Deal_Rights  WHERE AT_Syn_Deal_Code  IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))

---------------------------------------------------Complete Rights----------------------------------



-------------------------------------------------------------Start Run Defination Tab-------------------------------------------------------------

-------------------------------------Complete Run Defi.-------------------------------------------------------------
-------------------------------------Start Ancillary Tab------------------------------------------------------------

DELETE FROM AT_Syn_Deal_Ancillary_Title WHERE  AT_Syn_Deal_Ancillary_Code IN
(	
	SELECT AT_Syn_Deal_Ancillary_Code From AT_Syn_Deal_Ancillary WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 
DELETE FROM AT_Syn_Deal_Ancillary_Platform_Medium WHERE  AT_Syn_Deal_Ancillary_Platform_Code IN
(
	SELECT  AT_Syn_Deal_Ancillary_Platform_Code From AT_Syn_Deal_Ancillary_Platform WHERE  AT_Syn_Deal_Ancillary_Code IN
	(	
		SELECT AT_Syn_Deal_Ancillary_Code From AT_Syn_Deal_Ancillary WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	) 
)
DELETE FROM AT_Syn_Deal_Ancillary_Platform WHERE  AT_Syn_Deal_Ancillary_Code IN
(	
	SELECT AT_Syn_Deal_Ancillary_Code From AT_Syn_Deal_Ancillary WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Ancillary WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))

------------------------------------------------Complete Ancillary-----------------------
------------------------------------------------Start Cost Tab---------------------------


DELETE FROM AT_Syn_Deal_Revenue_Title WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Revenue_Additional_Exp WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Revenue_Commission WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Revenue_Platform WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Revenue_Variable_Cost WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

DELETE FROM AT_Syn_Deal_Revenue_Costtype_Episode WHERE AT_Syn_Deal_Revenue_Costtype_Code IN
(
	SELECT  AT_Syn_Deal_Revenue_Costtype_Code FROM AT_Syn_Deal_Revenue_Costtype WHERE AT_Syn_Deal_Revenue_Code IN
	(	
		SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
	)
)

DELETE FROM AT_Syn_Deal_Revenue_Costtype WHERE AT_Syn_Deal_Revenue_Code IN
(	
	SELECT AT_Syn_Deal_Revenue_Code From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
) 

Delete From AT_Syn_Deal_Revenue WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))

--------------------------------------------------Complete Cost.---------------------------------------------

------------------------------Start Payment,Material And Attachment Tab--------------------------------------

DELETE FROM AT_Syn_Deal_Payment_Terms WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
DELETE FROM AT_Syn_Deal_Material WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
DELETE FROM AT_Syn_Deal_Attachment WHERE AT_Syn_Deal_Code IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))

-------------------------------------------------------------Complete Payment,Material And Attachment---------
DELETE FROM AT_Syn_Deal_Movie WHERE AT_Syn_Deal_Code  IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))
DELETE FROM AT_Syn_Deal WHERE AT_Syn_Deal_Code  IN (Select number FROM fn_Split_withdelemiter(@AT_Syn_Deal_Code,','))

------------------------------------------------------------------------------------------------------------------
COMMIT TRANSACTION;
 IF(@Debug='D')
	PRINT 'COMMIT TRANSACTION'
	SELECT 'SUCCESSFULLY' AS Result_Message
END TRY

BEGIN CATCH	
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(MAX),@ErrorSeverity INT,@ErrorState INT
    SELECT    @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorState = ERROR_STATE();    
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
	IF(@Debug='D')
	BEGIN
		PRINT 'ROLLBACK TRANSACTION'			
		--SELECT   @ErrorMessage ,@ErrorSeverity,@ErrorState;    	
	END
   SELECT 'ERROR' AS Result_Message
END CATCH;
END
/*
EXEC [dbo].[USP_DELETE_Deal] 32, D

*/