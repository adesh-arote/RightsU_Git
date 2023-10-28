CREATE PROCEDURE [dbo].[USP_BMS_WBS_Insert]
(
	@SAP_WBS_Code INT,
	@WBS_Code VARCHAR(50),
	@WBS_Description NVARCHAR(100),
	@Short_ID VARCHAR(20),
	@Is_Archive CHAR(1),
	@Status NVARCHAR(5),
	@Error_Details NVARCHAR(150),
	@Is_Process CHAR(1),
	@File_Code BIGINT,
	@BMS_Key INT
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 12 Aug 2012
-- Description:	Insert Data Into BMS_WBS 
-- =============================================
BEGIN	
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_BMS_WBS_Insert]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;

		IF NOT EXISTS(SELECT * FROM BMS_WBS WHERE
			[SAP_WBS_Code] = @SAP_WBS_Code
			AND [WBS_Code] = @WBS_Code
			AND [WBS_Description] = @WBS_Description
			AND [Short_ID] = @Short_ID
			AND [Is_Archive] = @Is_Archive
			AND [Status] = @Status 
			AND [Error_Details] = @Error_Details
			AND [Is_Process] = @Is_Process
			AND [File_Code] = @File_Code
			AND [BMS_Key] =@BMS_Key 
		)
		BEGIN
			INSERT INTO [dbo].[BMS_WBS]
				   ([SAP_WBS_Code]
				   ,[WBS_Code]
				   ,[WBS_Description]
				   ,[Short_ID]
				   ,[Is_Archive]
				   ,[Status]
				   ,[Error_Details]
				   ,[Is_Process]
				   ,[File_Code]
				   ,[BMS_Key]
				   )
			 VALUES
				(
					@SAP_WBS_Code ,
					@WBS_Code ,
					@WBS_Description ,
					@Short_ID ,
					@Is_Archive ,
					@Status ,
					@Error_Details ,
					@Is_Process ,
					@File_Code,
					@BMS_Key
				)
		END

		SELECT 'Success' AS Result
	
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_BMS_WBS_Insert]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
