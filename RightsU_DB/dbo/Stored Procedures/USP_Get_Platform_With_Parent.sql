CREATE PROCEDURE [dbo].[USP_Get_Platform_With_Parent]
(
	@PFCodes as varchar(2000)	
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Platform_With_Parent]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--SET FMTONLY OFF
		Create Table #TempPF(
			Platform_Code Int,
			Parent_Platform_Code Int,
			Base_Platform_Code Int,
			Is_Display Varchar(2),
			Is_Last_Level Varchar(2),
			TempCnt Int,
			TableCnt Int,
		)

		Create Table #TempPFParent(
			Parent_Platform_Code Int,
			IsUse Varchar(1)
		)

		Insert InTo #TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'Y', Is_Last_Level, 0, 0 From [Platform] (NOLOCK) Where platform_code in (Select number From DBO.fn_Split_withdelemiter(@PFCodes, ',')) order by platform_name 

		Insert InTo #TempPFParent
		Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From #TempPF
	
		Insert InTo #TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0
		From [Platform] p (NOLOCK) 
		Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) order by platform_name 
	
		Update t Set 
			t.TempCnt = (Select Count(*) From #TempPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
			t.TableCnt = (Select Count(*) From [Platform] (NOLOCK) Where Parent_Platform_Code = t.Platform_Code)
		From #TempPF t
	
		Update #TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
			Select platform_code From #TempPF Where TempCnt = TableCnt
		) And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent)
	
		Update #TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'--And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent)

		While((Select COUNT(*) From #TempPFParent Where ISNULL(Parent_Platform_Code, 0) > 0) > 0)
		Begin
			Update #TempPFParent Set IsUse = 'Y'
			-- select 'a'
			Insert InTo #TempPFParent
			Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From [Platform] (NOLOCK)
			Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) --order by platform_name 
		
			Delete From #TempPFParent Where IsUse = 'Y'
		
			Insert InTo #TempPF
			Select platform_code, ISNULL(Parent_Platform_Code, 0),ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0
			From [Platform] p (NOLOCK)
			Where platform_code in (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) And 
				  platform_code not in (Select platform_code From #TempPF) order by platform_name 
		
			Update t Set 
				t.TempCnt = (Select Count(*) From #TempPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
				t.TableCnt = (Select Count(*) From [Platform] (NOLOCK) Where Parent_Platform_Code = t.Platform_Code)
			From #TempPF t
		
			Update #TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
				Select platform_code From #TempPF Where TempCnt = TableCnt
			) And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent)
		
			Update #TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'
		End

		Select 
			tp.Platform_Code,
			tp.Parent_Platform_Code,
			tp.Base_Platform_Code,
			tp.Is_Display,
			tp.Is_Last_Level,
			tp.TempCnt,
			tp.TableCnt,
		 p.Platform_Hiearachy From #TempPF tp Inner Join [Platform] p (NOLOCK) On tp.Platform_Code = p.platform_code Where Is_Display = 'Y' Order by p.Platform_Hiearachy

		--Drop Table #TempPF
		--Drop Table #TempPFParent

		IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
		IF OBJECT_ID('tempdb..#TempPFParent') IS NOT NULL DROP TABLE #TempPFParent
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Platform_With_Parent]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END