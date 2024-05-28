CREATE PROCEDURE [dbo].[USP_DELETE_Syn_DEAL]
(
	@Syn_Deal_Code INT,
	@Debug Char(1) = 'N'
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 27-October-2014
-- Description:	DELETE Syn Deal Call From EF Table Mapping
-- Last Update By : Sagar Mahajan ,Reshma(Added delete script for Run Tables)
-- =============================================
BEGIN
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION;

---------------------------------------Start Run-------------

DELETE FROM [dbo].[Syn_Deal_Run_Repeat_On_Day] WHERE Syn_Deal_Run_Code 
IN (SELECT Syn_Deal_Run_Code FROM [dbo].[Syn_Deal_Run] WHERE Syn_Deal_Code = @Syn_Deal_Code)

DELETE FROM [dbo].[Syn_Deal_Run_Yearwise_Run] WHERE Syn_Deal_Run_Code 
IN (SELECT Syn_Deal_Run_Code FROM [dbo].[Syn_Deal_Run] WHERE Syn_Deal_Code = @Syn_Deal_Code)

DELETE FROM [dbo].[Syn_Deal_Run_Platform] WHERE Syn_Deal_Run_Code 
IN (SELECT Syn_Deal_Run_Code FROM [dbo].[Syn_Deal_Run] WHERE Syn_Deal_Code = @Syn_Deal_Code)

DELETE FROM [dbo].[Syn_Deal_Run] WHERE Syn_Deal_Code = @Syn_Deal_Code

-------------------------------------Complete Run----------------------------------

---------------------------------------Start Rights Tab-------------
--Holdback
DELETE FROM Syn_Deal_Rights_Holdback_Platform WHERE Syn_Deal_Rights_Holdback_Code IN
(
	SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback 
	WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Holdback_Territory WHERE Syn_Deal_Rights_Holdback_Code IN
(
	SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback 
	WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Holdback_Dubbing WHERE Syn_Deal_Rights_Holdback_Code IN
(
	SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback 
	WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
)
DELETE FROM Syn_Deal_Rights_Holdback_Subtitling WHERE Syn_Deal_Rights_Holdback_Code IN
(
	SELECT Syn_Deal_Rights_Holdback_Code FROM Syn_Deal_Rights_Holdback 
	WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Holdback WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

--Blackout
DELETE FROM Syn_Deal_Rights_Blackout_Platform WHERE Syn_Deal_Rights_Blackout_Code IN
(
	SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout 
WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Blackout_Territory WHERE Syn_Deal_Rights_Blackout_Code IN
(
	SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout 
	WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Blackout_Dubbing WHERE Syn_Deal_Rights_Blackout_Code IN
(
SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout 
WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
)
DELETE FROM Syn_Deal_Rights_Blackout_Subtitling WHERE Syn_Deal_Rights_Blackout_Code IN
(
	SELECT Syn_Deal_Rights_Blackout_Code FROM Syn_Deal_Rights_Blackout 
WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
) 
DELETE FROM Syn_Deal_Rights_Blackout WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

DELETE FROM Syn_Deal_Rights_Promoter_Group WHERE Syn_Deal_Rights_Promoter_Code IN
(
SELECT Syn_Deal_Rights_Promoter_Code FROM Syn_Deal_Rights_Promoter
WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
)
DELETE FROM Syn_Deal_Rights_Promoter_Remarks WHERE Syn_Deal_Rights_Promoter_Code IN
(
SELECT Syn_Deal_Rights_Promoter_Code FROM Syn_Deal_Rights_Promoter
WHERE Syn_Deal_Rights_Code IN
	(
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
		WHERE Syn_Deal_Code =@Syn_Deal_Code
	)
)
DELETE FROM Syn_Deal_Rights_Promoter WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

--Rights
DELETE FROM Syn_Deal_Rights_Title WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

DELETE FROM Syn_Deal_Rights_Platform WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)
DELETE FROM Syn_Deal_Rights_Territory WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)
DELETE FROM Syn_Deal_Rights_Subtitling WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

DELETE FROM Syn_Deal_Rights_Dubbing WHERE Syn_Deal_Rights_Code IN
(
	SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights 
	WHERE Syn_Deal_Code =@Syn_Deal_Code
)

DELETE FROM Syn_Deal_Rights  WHERE Syn_Deal_Code  = @Syn_Deal_Code
---------------------------------------Syn_Acq_Mapping ------------
CREATE TABLE #Temp(Result VARCHAR(10))
INSERT INTO #Temp
EXEC USP_Syn_Acq_Mapping @Syn_Deal_Code,'N'
DROP TABLE #Temp
--DELETE FROM Syn_Acq_Mapping  WHERE Syn_Deal_Code = @Syn_Deal_Code
---------------------------------------------------Complete Rights----------------------------------

-------------------------------------Start Ancillary Tab------------------------------------------------------------

DELETE FROM Syn_Deal_Ancillary_Title WHERE  Syn_Deal_Ancillary_Code IN
(	
	SELECT Syn_Deal_Ancillary_Code From Syn_Deal_Ancillary WHERE Syn_Deal_Code = @Syn_Deal_Code
) 
DELETE FROM Syn_Deal_Ancillary_Platform_Medium WHERE  Syn_Deal_Ancillary_Platform_Code IN
(
	SELECT  Syn_Deal_Ancillary_Platform_Code From Syn_Deal_Ancillary_Platform WHERE  Syn_Deal_Ancillary_Code IN
	(	
		SELECT Syn_Deal_Ancillary_Code From Syn_Deal_Ancillary WHERE Syn_Deal_Code = @Syn_Deal_Code
	) 
)
DELETE FROM Syn_Deal_Ancillary_Platform WHERE  Syn_Deal_Ancillary_Code IN
(	
	SELECT Syn_Deal_Ancillary_Code From Syn_Deal_Ancillary WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE FROM Syn_Deal_Ancillary WHERE Syn_Deal_Code = @Syn_Deal_Code

------------------------------------------------Complete Ancillary-----------------------
------------------------------------------------Start Cost Tab---------------------------

DELETE FROM Syn_Deal_Revenue_Title WHERE  Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE  From Syn_Deal_Revenue_Platform WHERE Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
)

DELETE FROM Syn_Deal_Revenue_Additional_Exp WHERE  Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE FROM Syn_Deal_Revenue_Commission WHERE  Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE FROM Syn_Deal_Revenue_Costtype_Episode WHERE  Syn_Deal_Revenue_Costtype_Code IN
(	
	SELECT Syn_Deal_Revenue_Costtype_Code From Syn_Deal_Revenue_Costtype WHERE Syn_Deal_Revenue_Code IN
	(	
		SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
	)
) 

DELETE FROM Syn_Deal_Revenue_Costtype WHERE  Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE FROM Syn_Deal_Revenue_Variable_Cost WHERE  Syn_Deal_Revenue_Code IN
(	
	SELECT Syn_Deal_Revenue_Code From Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code
) 

DELETE FROM Syn_Deal_Revenue WHERE Syn_Deal_Code = @Syn_Deal_Code


--------------------------------------------------Complete Cost.---------------------------------------------
------------------------------Start Payment,Material And Attachment Tab--------------------------------------

DELETE FROM Syn_Deal_Payment_Terms WHERE Syn_Deal_Code = @Syn_Deal_Code
DELETE FROM Syn_Deal_Material WHERE Syn_Deal_Code = @Syn_Deal_Code
DELETE FROM Syn_Deal_Attachment WHERE Syn_Deal_Code = @Syn_Deal_Code

-------------------------------------------------------------Complete Payment,Material And Attachment---------
DELETE FROM Syn_Deal_Movie WHERE Syn_Deal_Code  = @Syn_Deal_Code
DELETE FROM  Syn_Deal WHERE Syn_Deal_Code  = @Syn_Deal_Code

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
EXEC [dbo].[USP_DELETE_Syn_DEAL] 1, D
*/