
CREATE Proc [dbo].[USP_Get_User_Security_Group_Tree_Hierarchy]      
(  
--declare
@ModuleCodes Varchar(2000) ='21,69'           
,@Search_Module_Name NVARCHAR(500)            
)            
As            
Begin            
     SET FMTONLY OFF      
 --Declare @PlatformCodes Varchar(2000) = '81,122,101,78,85,45,76,121,55,77,98,165,53,158'            
 IF(RTRIM(LTRIM(@Search_Module_Name)) <> '')            
  SET @Search_Module_Name = RTRIM(LTRIM(@Search_Module_Name))            
            
 Create Table #TempPF(            
  Module_Code Int,            
  Parent_Module_Code Int,            
  Is_Sub_Module Varchar(2)            
 )            
             
 If(@ModuleCodes <> '')            
 Begin            
             
  --Insert InTo #TempPF            
  --Select Module_Code, ISNULL(Parent_Module_Code, 0), Is_Sub_Module            
  --From System_Module Where Module_Code in (Select number From DBO.fn_Split_withdelemiter(@ModuleCodes, ',')) order by Module_Name             
  Insert InTo #TempPF  
  select SM.Module_Code, ISNULL(SM.Parent_Module_Code, 0) , SM.Is_Sub_Module
  from System_Module_Right SMR
  INNER JOIN System_Module SM ON SM.Module_Code= SMR.Module_Code
  where SMR.Module_Right_Code IN (Select number From DBO.fn_Split_withdelemiter(@ModuleCodes, ','))



  While((             
   Select Count(*) From System_Module Where Module_Code In (Select Parent_Module_Code From #TempPF) And Module_Code Not In (Select Module_Code From #TempPF)            
  ) > 0)            
  Begin            
               
   Insert InTo #TempPF            
   Select Module_Code, ISNULL(Parent_Module_Code, 0), Is_Sub_Module            
   From System_Module Where Module_Code in (Select Parent_Module_Code From #TempPF) And Module_Code Not In (Select Module_Code From #TempPF)            
               
  End            
 End            
 Else            
 Begin            
  Insert InTo #TempPF(Module_Code, Parent_Module_Code)            
  Select Module_Code, IsNull(Parent_Module_Code, 0) From System_Module            
 End            
            
 Select Module_Code, Replace(Module_Name,@Search_Module_Name            
 --,'<span style="background-color:yellow">'+@Search_Module_Name+'</span>') AS Module_Name            
 ,'<span style="background-color:yellow">'            
   + (SUBSTRING(Module_Name,CHARINDEX(@Search_Module_Name,Module_Name ,0),CHARINDEX(@Search_Module_Name,Module_Name ,0) + (LEN(@Search_Module_Name)  - CHARINDEX(@Search_Module_Name,Module_Name,0))) +'</span>')            
   ) AS Module_Name            
 , IsNull(Parent_Module_Code, 0) Parent_Module_Code, Is_Sub_Module, Module_Position,            
 (Select Count(*) From #TempPF tp Where tp.Parent_Module_Code = System_Module.Module_Code) ChildCount,        
        
 ISNULL(STUFF((SELECT ',' + convert(varchar(Max),S.Module_Right_Code) FROM        
        (select * from System_Module_Right where Module_Right_Code IN (Select number From DBO.fn_Split_withdelemiter(@ModuleCodes, ',')))As S Where S.[Module_Code] = System_Module.Module_Code AND System_Module.Is_Sub_Module = 'N'         
         FOR XML PATH('')),1,1,''),' ') As [Module_Right_Codes],        
        
   ISNULL(STUFF((SELECT ',' + convert(varchar(Max),SA.Right_Name) FROM        
        (select s.Module_Right_Code,s.Module_Code,s.Right_Code,sr.Right_Name from System_Module_Right S inner join System_Right sr on S.Right_Code = sr.Right_Code)As SA  Where SA.[Module_Code] = System_Module.Module_Code AND SA.Module_Right_Code IN (Select number From DBO.fn_Split_withdelemiter(@ModuleCodes, ',')) --AND System_Module.Is_Sub_Module = 'N'      
         FOR XML PATH('')),1,1,''),' ') As [Right_Codes],        
        
        
 (select ISNULL(count(*),0) From System_Module_Right SMR  where SMR.Module_Code = System_Module.Module_Code AND System_Module.Is_Sub_Module = 'N' Group By SMR.Module_Code) RightsCount      
 From System_Module Where Is_Active = 'Y'             
 And Module_Code In (Select Module_Code From #TempPF)             
 --AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')            
 Order By Module_Position            
             
 --Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position            
	--Drop Table #TempPF        
 
	IF OBJECT_ID('tempdb..#TempPF') IS NOT NULL DROP TABLE #TempPF
End