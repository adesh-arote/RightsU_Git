CREATE PROCEDURE [dbo].[USP_BMS_Schedule_Get_BV_Title_Name]	
AS
-- =============================================
-- Author:         <Sagar Mahajan>
-- Create date:	   <30 Aug 2016>
-- Description:    <Call from BMS_Schedule_Get SSIS Package , Get BV Title Using BMS or Program Asset ID>
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Get_BV_Title_Name]', 'Step 1', 0, 'Started Procedure', 0, ''

		SET NOCOUNT ON;	   
		DECLARE @BaseAddress VARCHAR(300) = '',@RequestUri VARCHAR(100) = '', @ModuleName VARCHAR(MAX)

		SET @moduleName = 'BMS_Title_Name'
		SELECT TOP 1 @BaseAddress = [BaseAddress],@RequestUri = RequestUri 
		FROM BMS_All_Masters (NOLOCK) WHERE Method_Type = 'G' AND Module_Name = @ModuleName AND Is_Active = 'Y'
	
		SELECT DISTINCT @BaseAddress AS BaseAddress, BHD.Program_Episode_ID AS BMS_Asset_Ref_Key,
		@RequestUri + BHD.Program_Episode_ID AS RequestUri  
		FROM BV_HouseId_Data BHD  (NOLOCK)
		WHERE ISNULL(BHD.BMS_Schedule_Process_Data_Temp_Code,0) > 0  AND ISNULL(BHD.Program_Episode_ID,0) > 0 AND ISNULL(BHD.BV_Title,'') = ''
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Schedule_Get_BV_Title_Name]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
