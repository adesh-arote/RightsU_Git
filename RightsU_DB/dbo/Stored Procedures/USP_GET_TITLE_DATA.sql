CREATE PROCEDURE [dbo].[USP_GET_TITLE_DATA]
@SearchTitle NVARCHAR(MAX)='',@Deal_Type_Code INT=0
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GET_TITLE_DATA]', 'Step 1', 0, 'Started Procedure', 0, ''

	Exec [USPLogSQLSteps] '[USP_GET_TITLE_DATA]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @Deal_Type_Movie INT, @Deal_Type_Content INT, @Deal_Type_Format_Program INT, @Deal_Type_Event INT

		SELECT @Deal_Type_Movie = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Movie'
		SELECT @Deal_Type_Content = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Content'
		SELECT @Deal_Type_Format_Program = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Format_Program'
		SELECT @Deal_Type_Event = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'

		SELECT DISTINCT dbo.UFN_GetTitleNameInFormat(CASE WHEN T.Deal_Type_Code = @Deal_Type_Movie THEN 'DEAL_MOVIE' 
			WHEN T.Deal_Type_Code = @Deal_Type_Content THEN 'DEAL_PROGRAM'
			WHEN T.Deal_Type_Code = @Deal_Type_Format_Program THEN 'DEAL_PROGRAM' 
			WHEN T.Deal_Type_Code = @Deal_Type_Event THEN 'DEAL_EVENT'
			ELSE '' END, T.Title_Name, MIN(TC.Episode_No), MAX(Episode_No)) AS Title_Name,
			MIN(TC.Episode_No) Episode_Starts_From, MAX(Episode_No) Episode_End_To, CCR.Title_Code 
		from Content_Channel_Run CCR (NOLOCK)
		INNER JOIN Title_Content TC (NOLOCK) ON TC.Title_Code = CCR.Title_Code
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = TC.Title_Code
		WHERE  1=1
			AND (@SearchTitle = '' OR Title_Name Like '%'+@SearchTitle+'%')
			AND T.Deal_Type_Code IN (@Deal_Type_Movie, @Deal_Type_Content, @Deal_Type_Format_Program)
			AND
			(
				(T.Deal_Type_Code = @Deal_Type_Movie AND @Deal_Type_Code!=0) 
				OR 
				(
					(T.Deal_Type_Code = @Deal_Type_Content AND @Deal_Type_Code=0)
					OR
					(T.Deal_Type_Code = @Deal_Type_Format_Program AND @Deal_Type_Code=0)
					OR
					(T.Deal_Type_Code = @Deal_Type_Event AND @Deal_Type_Code=0)
				)
			)
		GROUP BY  CCR.Title_Code, T.Title_Name,T.Deal_Type_Code
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GET_TITLE_DATA]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END