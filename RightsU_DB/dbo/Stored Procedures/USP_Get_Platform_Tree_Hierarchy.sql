CREATE Proc [dbo].[USP_Get_Platform_Tree_Hierarchy]
(
@PlatformCodes Varchar(2000)
,@Search_Platform_Name NVARCHAR(500)
)
As
Begin

	--Declare @PlatformCodes Varchar(2000) = '81,122,101,78,85,45,76,121,55,77,98,165,53,158'
	IF(RTRIM(LTRIM(@Search_Platform_Name)) <> '')
		SET @Search_Platform_Name = RTRIM(LTRIM(@Search_Platform_Name))

	Create Table #TempPF(
		Platform_Code Int,
		Parent_Platform_Code Int,
		Is_Last_Level Varchar(2)
	)
	
	If(@PlatformCodes <> '')
	Begin
	
		Insert InTo #TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0), Is_Last_Level
		From [Platform] Where platform_code in (Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')) order by platform_name 
		
		While((	
			Select Count(*) From [Platform] Where Platform_Code In (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)
		) > 0)
		Begin
			
			Insert InTo #TempPF
			Select platform_code, ISNULL(Parent_Platform_Code, 0), Is_Last_Level
			From [Platform] Where Platform_Code in (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)
			
		End
	End
	Else
	Begin
		Insert InTo #TempPF(Platform_Code, Parent_Platform_Code)
		Select Platform_Code, IsNull(Parent_Platform_Code, 0) From [Platform]
	End

	Select Platform_Code, Replace(Platform_Name,@Search_Platform_Name
	--,'<span style="background-color:yellow">'+@Search_Platform_Name+'</span>') AS Platform_Name
	,'<span style="background-color:yellow">'
			+ (SUBSTRING(Platform_Name,CHARINDEX(@Search_Platform_Name,Platform_Name ,0),CHARINDEX(@Search_Platform_Name,Platform_Name ,0) + (LEN(@Search_Platform_Name)  - CHARINDEX(@Search_Platform_Name,Platform_Name,0))) +'</span>')
			) AS Platform_Name
	, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position,
	(Select Count(*) From #TempPF tp Where tp.Parent_Platform_Code = [Platform].Platform_Code) ChildCount
	From [Platform] Where Is_Active = 'Y' 
	And Platform_Code In (Select Platform_Code From #TempPF) 
	--AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')
	Order By Module_Position
	
	--Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position
	--Drop Table #TempPF
	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
End

/*

Exec USP_Get_Platform_Tree_Hierarchy '','Gaming Rights'
Exec USP_Get_Platform_Tree_Hierarchy '1,81,122,101,78,85,45,76,121,55,77,98,165,53,158',''

*/