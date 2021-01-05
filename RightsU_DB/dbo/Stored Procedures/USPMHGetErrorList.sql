CREATE PROC [dbo].[USPMHGetErrorList]   
@List  NVARCHAR(MAX)  
AS    
BEGIN  
 --DECLARE @List  NVARCHAR(MAX) = 'MHMDNF,MHTNFIC'  
 DECLARE @Tbl Table(List nvarchar(max))  
   
 INSERT INTO @Tbl(List)  
 SELECT NUMBER FROM fn_Split_withdelemiter(@List,',')  
  
 SELECT @List =  STUFF(( SELECT ', ' + ISNULL(em.Error_Description, '') FROM Error_Code_Master EM   
 INNER JOIN @Tbl L ON EM.Upload_Error_Code = L.List  
 FOR XML PATH(''),ROOT('MyString'),TYPE).value('/MyString[1]','varchar(max)'),1,2,'')    
   
 SELECT  @List AS ErrorDescription  
END

