CREATE FUNCTION [dbo].[UFN_Check_SubLicense]
(
	@Deal_Run_Code int
)
RETURNS CHAR(1)
AS
BEGIN
	-- =============================================
	-- Author : Anchal Sikarwar
	-- Create date : 16 Sep, 2016
	-- Description : Check SubLicense for Title 
	-- =============================================
	Declare @isSubLicen CHAR(1) = 'N' ,@SubCount INT = 0
	
	select @SubCount=Count(*) from Acq_Deal_Rights objDMR 
	inner join Acq_Deal_Rights_Title objDMRT ON objDMR.Acq_Deal_Rights_Code = objDMRT.Acq_Deal_Rights_Code
	inner join Acq_Deal_Run_Title objTL ON objTL.Episode_From = objDMRT.Episode_From AND objTL.Episode_To = objDMRT.Episode_To AND objTL.Title_Code = objDMRT.Title_Code
	where objTL.Acq_Deal_Run_Code IN(@Deal_Run_Code) AND objDMR.Is_Sub_License='Y'

	IF(@SubCount>0)
		SET @isSubLicen='Y'
	ELSE
		SET @isSubLicen='N'          

	RETURN @isSubLicen
END
