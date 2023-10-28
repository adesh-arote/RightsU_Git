CREATE PROCEDURE [dbo].[USP_Select_Mass_Territory_Update]
	@StrSearch NVARCHAR(Max),
	@PageNo Int,
	@OrderByCndition Varchar(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@DealFor Varchar(1),
	@RecordCount Int  Out
AS
-- =============================================
-- Author:		<Reshma Kunjal>
-- Create date: <19-Jan-2015>
-- Description:	<Select table Acq_Deal_Mass_Territory_Update records with paging>
-- =============================================
BEGIN	
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Mass_Territory_Update]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET FMTONLY OFF
	
		if(@PageNo = 0)
			Set @PageNo = 1

		Create Table #Temp(
			Id Int,
			RowId Varchar(200)
			);

		declare @sqlPageNo varchar(5000);
		Declare @Sql Varchar(5000)
    
		IF(@DealFor = 'A')
		BEGIN
		set @sqlPageNo='
		WITH Y AS (
					select k=ROW_NUMBER() over (order by admtu.Acq_Deal_code desc ),admtu.Acq_Deal_Mass_Update_Code 
					from Acq_Deal_Mass_Territory_Update admtu (NOLOCK)
					inner join Acq_Deal ad (NOLOCK) on ad.Acq_Deal_code=admtu.Acq_Deal_code
					where  AD.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND admtu.Can_Process=''N'' '+ @StrSearch + '
				  )
			Insert InTo #Temp Select k, Acq_Deal_Mass_Update_Code From Y'		
				

		exec (@sqlPageNo)

		Select @RecordCount = Count(*) From #Temp
	
		If(@IsPaging = 'Y')
		Begin	
			Delete From #Temp Where Id < (((@PageNo - 1) * @PageSize) + 1) Or Id > @PageNo * @PageSize 
		End	

	
	
		set @Sql='select 
						admtu.Acq_Deal_Mass_Update_Code,admtu.Acq_Deal_Code,ad.Agreement_No,ad.Version,ad.Agreement_Date,
						ad.Deal_Desc,admtu.Can_Process 
				  from 
						Acq_Deal ad (NOLOCK)
						inner join Acq_Deal_Mass_Territory_Update admtu (NOLOCK) on admtu.Acq_Deal_Code=ad.Acq_Deal_Code
				  where  AD.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND
						admtu.Can_Process in (''N'') and Acq_Deal_Mass_Update_Code in (select RowId from #Temp) order by '+ @OrderByCndition
	
		--print (@Sql)
		exec (@Sql)
		END
		ELSE
		BEGIN
	
		set @sqlPageNo='
		WITH Y AS (
					select k=ROW_NUMBER() over (order by admtu.Syn_Deal_Code desc),admtu.Syn_Deal_Mass_Update_Code 
					from Syn_Deal_Mass_Territory_Update admtu (NOLOCK) 
					inner join Syn_Deal ad (NOLOCK) on ad.Syn_Deal_Code=admtu.Syn_Deal_Code
					where admtu.Can_Process=''N'' '+ @StrSearch + '
				  )
			Insert InTo #Temp Select k, Syn_Deal_Mass_Update_Code From Y'		
				

		exec (@sqlPageNo)

		Select @RecordCount = Count(*) From #Temp
	
		If(@IsPaging = 'Y')
		Begin	
			Delete From #Temp Where Id < (((@PageNo - 1) * @PageSize) + 1) Or Id > @PageNo * @PageSize 
		End	

	
	
		set @Sql='select 
						admtu.Syn_Deal_Mass_Update_Code Acq_Deal_Mass_Update_Code,admtu.Syn_Deal_Code Acq_Deal_Code,ad.Agreement_No,ad.Version,ad.Agreement_Date,
						ad.Deal_Description Deal_Desc,admtu.Can_Process 
				  from 
						Syn_Deal ad (NOLOCK)
						inner join Syn_Deal_Mass_Territory_Update admtu (NOLOCK) on admtu.Syn_Deal_Code=ad.Syn_Deal_Code
				  where 
						admtu.Can_Process in (''N'') and Syn_Deal_Mass_Update_Code in (select RowId from #Temp) order by '+ @OrderByCndition
	
		--print (@Sql)
		exec (@Sql)
	
		END

		--drop table #Temp
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Select_Mass_Territory_Update]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END