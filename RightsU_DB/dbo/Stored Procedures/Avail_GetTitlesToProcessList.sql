CREATE PROCEDURE [dbo].[Avail_GetTitlesToProcessList]
 
AS       
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetTitlesToProcessList]', 'Step 1', 0, 'Started Procedure', 0, ''

	IF OBJECT_ID('tempdb..#DealType') IS NOT NULL DROP TABLE #DealType

	------ @AvailsType = 'M'- Movie,'E'-Episode,'B'- Both
	DECLARE @AvailsType Char(1) = '',@TitleType VARCHAR(500) = '',@EpisodeType Varchar(500) =''


	CREATE TABLE #DealType (    
		[DealTypeCode] INT  NULL
		)


	  SELECT @AvailsType = Parameter_Value 
		FROM System_Parameter_New (NOLOCK) 
		WHERE UPPER(Parameter_Name) = 'AVAILSFOR'

		IF(UPPER(@AvailsType)='M')
		BEGIN
		  SELECT @TitleType = Parameter_Value 
			FROM System_Parameter_New (NOLOCK) 
			WHERE UPPER(Parameter_Name) = 'MOVIETYPES'
		END	
		ELSE IF(UPPER(@AvailsType)='E')
		BEGIN
		  SELECT @TitleType = Parameter_Value 
			FROM System_Parameter_New (NOLOCK) 
			WHERE UPPER(Parameter_Name) = 'EPISODETYPES'
		END	
		ELSE IF(UPPER(@AvailsType)='B')
		BEGIN
		  SELECT @TitleType = Parameter_Value 
			FROM System_Parameter_New (NOLOCK) 
			WHERE UPPER(Parameter_Name) = 'MOVIETYPES'
    
		  SELECT @EpisodeType = Parameter_Value 
			FROM System_Parameter_New (NOLOCK) 
			WHERE UPPER(Parameter_Name) = 'EPISODETYPES'
    
			 IF(@TitleType <> '' AND @EpisodeType <> '')
			 BEGIN
				SET  @TitleType = @TitleType + ','+ @EpisodeType
			 END
			 ELSE IF(@EpisodeType <> '')
			 BEGIN
				SET  @TitleType = @EpisodeType
			 END 

		END	

		IF(@TitleType <> '')
		BEGIN
			INSERT INTO #DealType(DealTypeCode)
			SELECT Deal_Type_Code FROM Deal_Type (NOLOCK)
			WHERE Is_Active = 'Y' AND UPPER(Deal_Type_Name) 
			IN (SELECT UPPER(number) From dbo.[fn_Split_withdelemiter](@TitleType,','))
		END

		SELECT Title_Code TitleCode, Title_Name TitleName 
		FROM Title T(NOLOCK)
		INNER JOIN #DealType DT 
		ON DT.DealTypeCode = T.Deal_Type_Code
	

		DROP Table #DealType
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetTitlesToProcessList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END