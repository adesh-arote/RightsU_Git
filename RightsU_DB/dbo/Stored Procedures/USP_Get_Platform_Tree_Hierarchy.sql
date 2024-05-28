CREATE PROCEDURE [dbo].[USP_Get_Platform_Tree_Hierarchy]  
(  
@PlatformCodes Varchar(2000)  
,@Search_Platform_Name NVARCHAR(500),  
@IS_Sport_Rights CHAR(1)  
)  
As  
Begin  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Platform_Tree_Hierarchy]', 'Step 1', 0, 'Started Procedure', 0, ''

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
	  From [Platform] (NOLOCK) Where platform_code in (Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')) order by platform_name   
    
	  While((   
	   Select Count(*) From [Platform] (NOLOCK) Where Platform_Code In (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)  
	  ) > 0)  
	  Begin  
     
	   Insert InTo #TempPF  
	   Select platform_code, ISNULL(Parent_Platform_Code, 0), Is_Last_Level  
	   From [Platform] (NOLOCK) Where Platform_Code in (Select Parent_Platform_Code From #TempPF) And Platform_Code Not In (Select Platform_Code From #TempPF)  
     
	  End  
	 End  
	 Else  
	 Begin  
	  Insert InTo #TempPF(Platform_Code, Parent_Platform_Code)  
	  Select Platform_Code, IsNull(Parent_Platform_Code, 0) From [Platform] (NOLOCK)
	 End  
  
	 Select Platform_Code, Replace(Platform_Name,@Search_Platform_Name  
	 --,'<span style="background-color:yellow">'+@Search_Platform_Name+'</span>') AS Platform_Name  
	 ,'<span style="background-color:yellow">'  
	   + (SUBSTRING(Platform_Name,CHARINDEX(@Search_Platform_Name,Platform_Name ,0),CHARINDEX(@Search_Platform_Name,Platform_Name ,0) + (LEN(@Search_Platform_Name)  - CHARINDEX(@Search_Platform_Name,Platform_Name,0))) +'</span>')  
	   ) AS Platform_Name  
	 , IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position,  
	 (Select Count(*) From #TempPF tp Where tp.Parent_Platform_Code = [Platform].Platform_Code) ChildCount  
	 From [Platform] (NOLOCK) Where Is_Active = 'Y'   
	 And Platform_Code In (Select Platform_Code From #TempPF)   
	 --AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')  
	 Order By Module_Position  
   
	 --Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position  
	 --Drop Table #TempPF  
	 IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF  
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Platform_Tree_Hierarchy]', 'Step 2', 0, 'Started Procedure', 0, ''
End