

CREATE PROCEDURE [dbo].[USP_Get_Platform_With_Parent]
(
	@PFCodes as varchar(2000)	
)
AS
BEGIN
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
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'Y', Is_Last_Level, 0, 0 From [Platform] Where platform_code in (Select number From DBO.fn_Split_withdelemiter(@PFCodes, ',')) order by platform_name 

	Insert InTo #TempPFParent
	Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From #TempPF
	
	Insert InTo #TempPF
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0
	From [Platform] p 
	Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) order by platform_name 
	
	Update t Set 
		t.TempCnt = (Select Count(*) From #TempPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
		t.TableCnt = (Select Count(*) From [Platform] Where Parent_Platform_Code = t.Platform_Code)
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
		Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From [Platform]
		Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) --order by platform_name 
		
		Delete From #TempPFParent Where IsUse = 'Y'
		
		Insert InTo #TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0),ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0
		From [Platform] p
		Where platform_code in (Select ISNULL(Parent_Platform_Code, 0) From #TempPFParent) And 
			  platform_code not in (Select platform_code From #TempPF) order by platform_name 
		
		Update t Set 
			t.TempCnt = (Select Count(*) From #TempPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
			t.TableCnt = (Select Count(*) From [Platform] Where Parent_Platform_Code = t.Platform_Code)
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
	 p.Platform_Hiearachy From #TempPF tp Inner Join [Platform] p On tp.Platform_Code = p.platform_code Where Is_Display = 'Y' Order by p.Platform_Hiearachy

	--Drop Table #TempPF
	--Drop Table #TempPFParent

	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
	IF OBJECT_ID('tempdb..#TempPFParent') IS NOT NULL DROP TABLE #TempPFParent
END
/*
EXEC [USP_Get_Platform_With_Parent] '3,4,9,10,91'
EXEC USP_ReturnParentPlatformCode  '23,24,25,26,27,73,74'

Select tp.*, p.Platform_Hiearachy From #TempPF tp Inner Join [Platform] p On tp.Platform_Code = p.platform_code Where Is_Display = 'Y' Order by p.platform_name
EXEC USP_ReturnParentPlatformCode '102,102,102,102,105,105,105,105,117,117,117,117,126,126,126,126,157,157,157,157,158,158,158,158,159,159,159,159,168,168,168,168,169,169,169,169,173,173,173,173,174,174,174,174,200,200,200,200,210,210,210,210'


EXEC USP_ReturnParentPlatformCode '53,56,59,62,65'
select distinct parent_platform_code from Platform where platform_code in( Select number From dbo.fn_Split_withdelemiter('23,24,25,26,27,73,74', ',')) order by 1 asc			
*/