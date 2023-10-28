CREATE PROCEDURE [dbo].[USP_Title_Import_RCData](
	@Keyword NVARCHAR(MAX),
	@TabName NVARCHAR(MAX),
	@Roles NVARCHAR(MAX)
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_RCData]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE @Keyword NVARCHAR(MAX)='jai',
		--		@TabName NVARCHAR(MAX)='TA',
		--		@Roles NVARCHAR(MAX)='Star Cast'

		DECLARE @Reference_Table		NVARCHAR(MAX),
				@Reference_Text_Field	NVARCHAR(MAX),
				@Reference_Value_Field	NVARCHAR(MAX),
				@Reference_Whr_Criteria NVARCHAR(MAX)

		SELECT  @Reference_Table = Reference_Table,
				@Reference_Text_Field = Reference_Text_Field, 
				@Reference_Value_Field = Reference_Value_Field,
				@Reference_Whr_Criteria = Reference_Whr_Criteria
		FROM DM_Title_Import_Utility (NOLOCK) WHERE ShortName = @TabName and Is_Active='Y' AND Is_allowed_For_Resolve_Conflict='Y' 
			AND (Display_Name = @Roles OR ISNULL(@Roles,'') = '' )

		EXEC ('
				SELECT CAST (' + @Reference_Value_Field +' AS NVARCHAR(MAX)) ValueField, '+@Reference_Text_Field+' TextField
				FROM '+@Reference_Table+' WHERE
				'+@Reference_Text_Field+' LIKE ''%'+@Keyword+'%''
				'+@Reference_Whr_Criteria+' ORDER BY 2 
			')
		 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Title_Import_RCData]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END