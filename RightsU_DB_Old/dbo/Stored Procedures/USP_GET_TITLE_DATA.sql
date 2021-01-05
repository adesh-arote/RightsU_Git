ALTER PROCEDURE [dbo].[USP_GET_TITLE_DATA]
@SearchTitle NVARCHAR(MAX)='',@Deal_Type_Code INT=0
AS
BEGIN   
	DECLARE @Deal_Type_Movie INT, @Deal_Type_Content INT, @Deal_Type_Format_Program INT, @Deal_Type_Event INT

	SELECT @Deal_Type_Movie = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Movie'
	SELECT @Deal_Type_Content = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Content'
	SELECT @Deal_Type_Format_Program = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Format_Program'
	SELECT @Deal_Type_Event = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Event'

	SELECT DISTINCT dbo.UFN_GetTitleNameInFormat(CASE WHEN T.Deal_Type_Code = @Deal_Type_Movie THEN 'DEAL_MOVIE' 
									  WHEN T.Deal_Type_Code = @Deal_Type_Content THEN 'DEAL_PROGRAM'
									  WHEN T.Deal_Type_Code = @Deal_Type_Format_Program THEN 'DEAL_PROGRAM' 
									  WHEN T.Deal_Type_Code = @Deal_Type_Event THEN 'DEAL_EVENT'
									  ELSE '' END, T.Title_Name, MIN(TC.Episode_No), MAX(Episode_No)) AS Title_Name
	,MIN(TC.Episode_No) Episode_Starts_From, MAX(Episode_No) Episode_End_To, CCR.Title_Code from Content_Channel_Run CCR
	INNER JOIN Title_Content TC ON TC.Title_Code = CCR.Title_Code
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code
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
	
	
END
--EXEC [dbo].[USP_GET_TITLE_DATA] 'sa',1
--SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name ='Deal_Type_Movie'

--EXEC USP_Deal_Process

--select * from Title Where Title_Code=34245

--select * from BV_HouseId_Data Where Title_Code=34245
--Update BV_HouseId_Data SET Is_Mapped = 'N',Title_Code = null, Title_Content_Code = NULL, Mapped_Deal_Title_Code = NULL Where Title_Code=34245
--Update Title_Content SET Ref_BMS_Content_Code = NULL Where Title_Code=34245
--select * from System_Parameter_New WHERE Parameter_Name ='Show_Program_Category'
--Update System_Parameter_New SEt Parameter_Value='Gen. Entertainment Series,Entertainment,Drama' FROM System_Parameter_New WHERE Parameter_Name ='Show_Program_Category'