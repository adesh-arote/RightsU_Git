CREATE PROCEDURE [dbo].[USP_List_Amort_Rule]
(
	@StrSearch NVarchar(Max),	
	@PageNo Int,
	@OrderByCndition Varchar(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int OUT,
	@User_Code INT,
	@ModuleCode varchar(10)

)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Amort_Rule]', 'Step 1', 0, 'Started Procedure', 0, ''

		SET FMTONLY OFF
		DECLARE @SqlPageNo NVARCHAR(Max),@Sql NVARCHAR(Max)
		SET NOCOUNT ON;	
		if(@PageNo=0)
			Set @PageNo = 1	
		Create Table #Temp
		(
			Amort_Rule_Code Int,
			RowId Int		
		);
		SET @SqlPageNo = '
		WITH Y AS 
		(
			SELECT ISNULL(AR.Amort_Rule_Code, 0) AS Amort_Rule_Code,RowId = ROW_NUMBER() OVER (ORDER BY AR.Amort_Rule_Code desc) 
			FROM Amort_Rule AR (NOLOCK)
			Where 1 = 1  '+ @StrSearch + '
		)
		INSERT INTO #Temp Select Amort_Rule_Code,RowId From Y'

		PRINT @SqlPageNo
		EXEC(@SqlPageNo)
		SELECT @RecordCount = ISNULL(COUNT(Amort_Rule_Code),0) FROM #Temp

		If(@IsPaging = 'Y')
			Begin	
				Delete From #Temp Where RowId < (((@PageNo - 1) * @PageSize) + 1) Or RowId > @PageNo * @PageSize 
			End	
			SET @Sql = 'Select AR.Amort_Rule_Code,(Case When AR.Rule_Type=''R'' Then ''RUN'' When AR.Rule_Type=''O'' Then ''Other'' When AR.Rule_Type=''P''  Then ''Period'' When AR.Rule_Type=''C''  Then  ''Premier/Show Premier'' END) as Rule_Type,
			AR.Rule_No,AR.Rule_Desc,(Case When AR.Year_Type=''D'' Then ''Deal Year'' When AR.Year_Type=''F'' Then ''Financial Year'' When IsNULL(AR.Year_Type,'''')=''''
			 Then ''NA'' END) as Year_Type ,(Case When IsNULL(AR.Period_For,'''')='''' Then ''NA'' When AR.Period_For=null Then ''NA'' When AR.Period_For=''A'' 
			 Then ''Amongst the Rights Period'' When Ar.Period_For =''E'' Then ''Equally Distribute'' When Ar.Period_For =''M'' Then ''Defined Manually''
			  When Ar.Period_For =''D'' Then ''Defined Manually'' Else ''NA'' END) AS Period_For, AR.Is_Active
			,dbo.[UFN_Button_Visibility]('+@ModuleCode+' , '+ CAST(@User_Code AS Varchar(10)) +') Show_Hide_Buttons
			--,''true'' as Show_Hide_Buttons
			from Amort_Rule AR  (NOLOCK) 
			INNER JOIN #Temp T ON AR.Amort_Rule_Code=T.Amort_Rule_Code ORDER BY ' + @OrderByCndition

		PRINT @Sql
		EXEC(@Sql)
		--Drop Table #temp;
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Amort_Rule]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END