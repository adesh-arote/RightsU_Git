CREATE Procedure [dbo].[USP_Generate_Deal_Type_Year]
	 @yearDefinition varChar(2)=null -- FY (Apr- Mar)-'FY' ,Jan - Dec- 'CY', Deal Year - 'FS'
	, @stDt dateTime=null --Period Start Dt
	, @enDt dateTime=null --Period end Dt
AS
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Deal_Type_Year]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
		/*
		-- Author:	 Bhavesh Desai	
		-- Create DATE: 7 Oct 2014
		-- Description: It is used for bifurcation of provided period on basis of Financial year Apr- Mar),Deal Year or Custom Year (Jan - Dec)
		10/22/2014
		10/21/2036
		DY

			exec [usp_GenerateDealTypeYear] @yearDefinition='CY',@stDt ='1/1/2009' , @enDt ='1/1/2010' 
			exec [usp_GenerateDealTypeYear] @yearDefinition='FY',@stDt ='2/1/2008' , @enDt ='1/1/2010' 
			exec [USP_Generate_Deal_Type_Year] @yearDefinition='DY',@stDt ='10/22/2014' , @enDt ='10/21/2036' 
		*/
		SET FMTONLY OFF
		Declare @tempEndDate dateTime
		Declare @fyDate dateTime
		Declare @MonthDate varChar(5)
		Declare @TmpMonth int
		Declare @TmpYear int


		set @yearDefinition=upper(@yearDefinition)

		--set @stDt ='12/1/2008' 
		--set @enDt ='12/1/2012' 
		--set @yearDefinition='FS'

		if(@yearDefinition ='FY')--Financial Year
		begin
			set @MonthDate='0331'
			set @TmpMonth=3
			set @TmpYear=1
		end
		if(@yearDefinition='CY')--Jan-Dec
		begin
			set @MonthDate='1231'
			set @TmpMonth=1
			set @TmpYear=0
		end

		SELECT @stDt  = CONVERT(DATETIME, @stDt, 101);
		SELECT @enDt  = CONVERT(DATETIME, @enDt, 101);

		if(@yearDefinition='DY')--Jan-Dec
		begin
			set @MonthDate=right('0'+cast(month(@stDt) as varchar(5)),2)+''+right('0'+cast(day(@stDt) as varchar(5)),2)
			set @TmpYear=1

		end

		create table #temp1
		(
			startdate dateTime,
			enddate dateTime
		)


		while(@stDt <= @enDt)
		begin 

			if(@yearDefinition!='DY')
			Begin --{
				Select @fyDate=Case When MONTH(@stDt) <= @TmpMonth Then 
				cast(CONVERT(Char(4), YEAR(@stDt)) + @MonthDate as DateTime)
				Else cast(CONVERT(Char(4), YEAR(@stDt)+@TmpYear) + @MonthDate as DateTime) End	

			End --}
			Else
			Begin --{	
				Select @fyDate=dateadd(d,-1,cast(CONVERT(Char(4), YEAR(@stDt)+@TmpYear) + @MonthDate as DateTime) )
			End --}
	
			print @fyDate

			If(@enDt<@fyDate) 
			Begin --{
				set @tempEndDate=@enDt 
			End --}
			Else 
			Begin --{		
				set @tempEndDate=@fyDate 
			End --}
	
			Print @tempEndDate	
	
			Insert Into #temp1 values (@stDt,@tempEndDate)
			Set @stDt=dateadd(d,1,@tempEndDate)
	
		End
	
		select convert(varchar,startdate,103)start_date,convert(varchar,enddate,103)end_date,0 as No_Of_Runs_Sched from #temp1
		--select convert(datetime,startdate,103)start_date,convert(datetime,enddate,103)end_date from #temp1
		--select startdate,enddate  from #temp1

			IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Deal_Type_Year]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END