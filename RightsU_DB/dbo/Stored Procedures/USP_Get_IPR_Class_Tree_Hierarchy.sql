

CREATE Proc [dbo].[USP_Get_IPR_Class_Tree_Hierarchy](@IPR_ClassCodes Varchar(2000))
As
SET FMTONLY OFF
Begin
	SET FMTONLY OFF
	--Declare @IPR_ClassCodes Varchar(2000) = '81,122,101,78,85,45,76,121,55,77,98,165,53,158'

	Create Table #TempClass(
		IPR_Class_Code Int,
		Parent_Class_Code Int,
		Is_Last_Level Varchar(2)
	)
	
	If(@IPR_ClassCodes <> '')
	Begin
	
		Insert InTo #TempClass
		Select IPR_Class_Code, ISNULL(Parent_Class_Code, 0), Is_Last_Level
		From [IPR_Class] Where IPR_Class_code in (Select number From DBO.fn_Split_withdelemiter(@IPR_ClassCodes, ',')) order by [Description] 
		
		While((	
			Select Count(*) From [IPR_Class] Where IPR_Class_Code In (Select Parent_Class_Code From #TempClass) And IPR_Class_Code Not In (Select IPR_Class_Code From #TempClass)
		) > 0)
		Begin
			
			Insert InTo #TempClass
			Select IPR_Class_code, ISNULL(Parent_Class_Code, 0), Is_Last_Level
			From [IPR_Class] Where IPR_Class_Code in (Select Parent_Class_Code From #TempClass) And IPR_Class_Code Not In (Select IPR_Class_Code From #TempClass)
			
		End
	End
	Else
	Begin
		Insert InTo #TempClass(IPR_Class_Code, Parent_Class_Code)
		Select IPR_Class_Code, IsNull(Parent_Class_Code, 0) From [IPR_Class]
	End

	Select IPR_Class_Code, [Description], IsNull(Parent_Class_Code, 0) Parent_Class_Code, Is_Last_Level, [Position],
	(Select Count(*) From #TempClass tp Where tp.Parent_Class_Code = [IPR_Class].IPR_Class_Code) ChildCount
	From [IPR_Class] Where Is_Active = 'Y' And IPR_Class_Code In (Select IPR_Class_Code From #TempClass) Order By [Position]
	
	--Select IPR_Class_Code, [Description], IsNull(Parent_Class_Code, 0) Parent_Class_Code, Is_Last_Level, [Position] From [IPR_Class] Where Is_Active = 'Y' Order By [Position]
	--Drop Table #TempClass

	IF OBJECT_ID('tempdb..#TempClass') IS NOT NULL DROP TABLE #TempClass
End


/*

Exec USP_Get_IPR_Class_Tree_Hierarchy ''
Exec USP_Get_IPR_Class_Tree_Hierarchy '81,122,101,78,85,45,76,121,55,77,98,165,53,158'

*/