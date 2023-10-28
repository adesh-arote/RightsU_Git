CREATE PROCEDURE [dbo].[USP_List_AcqDeal_Movie_Contents]
(
	@StrSearch Varchar(500),
	@Acq_Deal_Code Int,
	@PageNo Int,
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int Out
)
As
-- =============================================
-- Author:		Sachin Karande
-- Create DATE: 14-Sep-2015
-- Description:	AcqDeal Movie Contents List
-- =============================================
Begin
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_AcqDeal_Movie_Contents]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		Set FMTONLY Off

		if(@PageNo = 0)
			Set @PageNo = 1

		Create Table #Temp(
			Id Int,
			RowId Varchar(200),
		);
	
		Declare @Search Varchar(500)
		set @Search = '';

		IF(RTRIM(@StrSearch)!='')
		BEGIN
			IF (Len(@StrSearch) > 0)
			BEGIN    --{
				SET @Search = N' and Title_Code in (' + @StrSearch +')'  
			END    --}
		END
		Declare @OrderBy Varchar(100)
		--set @OrderBy = 'ORDER BY Title_Name ASC,Episode_No ASC';
		set @OrderBy = N'ORDER BY Acq_Deal_Movie_Content_Code ASC';

		Declare @SqlPageNo Varchar(5000)
	
		set @SqlPageNo = N'
				WITH Y AS (
								Select k, Acq_Deal_Movie_Content_Code Acq_Deal_Movie_Content_Code  From 
								(
									select k = ROW_NUMBER() OVER ('+@OrderBy+'),* from (									
									select ADMC.Acq_Deal_Code,ADMC.Acq_Deal_Movie_Code,ADMC.Acq_Deal_Movie_Content_Code,ADM.Title_Code,T.Title_Name,cast(ADMC.Episode_No as int) Episode_No,
									ADMC.Ref_BMS_Content_Code, 
									ADM.Is_Closed, ADM.Movie_Closed_Date 
									from Acq_Deal_Movie_Contents as ADMC (NOLOCK)
									inner join Acq_Deal_Movie as ADM (NOLOCK) on ADMC.Acq_Deal_Movie_Code = ADm.Acq_Deal_Movie_Code
									inner join Title as T (NOLOCK) on ADM.Title_Code = t.Title_Code
									)as XYZ Where 1 = 1 and Acq_Deal_Code = ' + cast(@Acq_Deal_Code as varchar(20)) + ' ' +  @Search + '
								 )as X		   
							)
			Insert InTo #Temp Select k, Acq_Deal_Movie_Content_Code From Y'
	
		PRINT(@SqlPageNo)
		EXEC(@SqlPageNo)
		Select @RecordCount = Count(*) From #Temp
	
		If(@IsPaging = 'Y')
		Begin	
			Delete From #Temp Where Id < (((@PageNo - 1) * @PageSize) + 1) Or Id > @PageNo * @PageSize 
		End	
		Declare @Sql Varchar(5000)
		Set @Sql = N'SELECT Acq_Deal_Code,Acq_Deal_Movie_Code,Acq_Deal_Movie_Content_Code,Title_Code,Title_Name,Episode_No,Ref_BMS_Content_Code,IsTerminate,Movie_Closed_Date,Duration FROM (
			select ADMC.Acq_Deal_Code,ADMC.Acq_Deal_Movie_Code,ADMC.Acq_Deal_Movie_Content_Code,ADM.Title_Code,
			(CASE WHEN ADMC.Episode_Title IS NOT NULL THEN ADMC.Episode_Title ELSE T.Title_Name END) AS Title_Name,cast(ADMC.Episode_No as int) Episode_No,
									(CASE WHEN ADMC.Ref_BMS_Content_Code IS NULL THEN '''' ELSE ADMC.Ref_BMS_Content_Code END) as ''Ref_BMS_Content_Code'',
									(CASE WHEN ADM.Is_Closed = ''Y'' THEN ''YES'' ELSE ''NO'' END) as ''IsTerminate'',
									(CASE WHEN ADM.Movie_Closed_Date IS NULL THEN '''' ELSE CONVERT(varchar,CONVERT(DATETIME, ADM.Movie_Closed_Date, 103),106) END) as ''Movie_Closed_Date'',
									(CASE WHEN ADMC.Duration IS NOT NULL THEN ADMC.Duration When T.Duration_In_Min IS NOT NULL THEN T.Duration_In_Min ELSE ''0.00'' END) AS Duration
									from Acq_Deal_Movie_Contents as ADMC (NOLOCK)
									inner join Acq_Deal_Movie as ADM (NOLOCK) on ADMC.Acq_Deal_Movie_Code = ADm.Acq_Deal_Movie_Code
									inner join Title as T (NOLOCK) on ADM.Title_Code = t.Title_Code
	
		) tbl 
		WHERE tbl.Acq_Deal_Movie_Content_Code in (Select RowId From #Temp) '+ @OrderBy + '' 
		PRINT @Sql
		Exec(@Sql)
		--Drop Table #Temp

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_AcqDeal_Movie_Contents]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End