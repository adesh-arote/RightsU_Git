CREATE Proc [dbo].[USP_Get_Promoter_Group_Tree_Hierarchy]  
(  
@Promoter_Group_Codes Varchar(2000)  
,@Search_Promoter_Group_Name NVARCHAR(500)  
)  
As  
Begin  
  
 --Declare @PlatformCodes Varchar(2000) = '81,122,101,78,85,45,76,121,55,77,98,165,53,158'  
 IF(RTRIM(LTRIM(@Search_Promoter_Group_Name)) <> '')  
  SET @Search_Promoter_Group_Name = RTRIM(LTRIM(@Search_Promoter_Group_Name))  
  
 Create Table #TempPF(  
  Promoter_Group_Code Int,  
  Parent_Group_Code Int,  
  Is_Last_Level Varchar(2)  
 )  
   
 If(@Promoter_Group_Codes <> '')  
 Begin  
   
  Insert InTo #TempPF  
  Select Promoter_Group_Code, ISNULL(Parent_Group_Code, 0), Is_Last_Level  
  From [Promoter_Group] Where Promoter_Group_Code in (Select number From DBO.fn_Split_withdelemiter(@Promoter_Group_Codes, ',')) order by Promoter_Group_Name   
    
  While((   
   Select Count(*) From [Promoter_Group] Where Promoter_Group_Code In (Select Parent_Group_Code From #TempPF) And Promoter_Group_Code Not In (Select Promoter_Group_Code From #TempPF)  
  ) > 0)  
  Begin  
     
   Insert InTo #TempPF  
   Select Promoter_Group_Code, ISNULL(Parent_Group_Code, 0), Is_Last_Level  
   From [Promoter_Group] Where Promoter_Group_Code in (Select Parent_Group_Code From #TempPF) And Promoter_Group_Code Not In (Select Promoter_Group_Code From #TempPF)  
     
  End  
 End  
 Else  
 Begin  
  Insert InTo #TempPF(Promoter_Group_Code, Parent_Group_Code)  
  Select Promoter_Group_Code, IsNull(Parent_Group_Code, 0) From [Promoter_Group]  
 End  
  
 Select Promoter_Group_Code, Replace(Promoter_Group_Name,@Search_Promoter_Group_Name  
 --,'<span style="background-color:yellow">'+@Search_Platform_Name+'</span>') AS Platform_Name  
 ,'<span style="background-color:yellow">'  
   + (SUBSTRING(Promoter_Group_Name,CHARINDEX(@Search_Promoter_Group_Name,Promoter_Group_Name ,0),CHARINDEX(@Search_Promoter_Group_Name,Promoter_Group_Name ,0) + (LEN(@Search_Promoter_Group_Name)  - CHARINDEX(@Search_Promoter_Group_Name,Promoter_Group_Name,0))) +'</span>')  
   ) AS Promoter_Group_Name  
 , IsNull(Parent_Group_Code, 0) Parent_Group_Code, Is_Last_Level, Display_Order,  
 (Select Count(*) From #TempPF tp Where tp.Parent_Group_Code = [Promoter_Group].Parent_Group_Code) ChildCount  
 From [Promoter_Group] Where Is_Active = 'Y'   
 And Promoter_Group_Code In (Select Promoter_Group_Code From #TempPF)   
 --AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')  
 Order By Display_Order  

 --Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position  
	--Drop Table #TempPF  
	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
End  
  
/*  
  
Exec USP_Get_Promoter_Group_Tree_Hierarchy '',''  
Exec USP_Get_Platform_Tree_Hierarchy '1,81,122,101,78,85,45,76,121,55,77,98,165,53,158',''  
  
*/