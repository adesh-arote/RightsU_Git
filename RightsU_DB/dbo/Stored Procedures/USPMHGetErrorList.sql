CREATE PROC [dbo].[USPMHGetErrorList]   
@List  NVARCHAR(MAX)  
AS    
BEGIN  
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetErrorList]', 'Step 1', 0, 'Started Procedure', 0, ''
	 --DECLARE @List  NVARCHAR(MAX) = 'MHMDNF,MHTNFIC'  
	 DECLARE @Tbl Table(List nvarchar(max))  
   
	 INSERT INTO @Tbl(List)  
	 SELECT NUMBER FROM fn_Split_withdelemiter(@List,',')  
  
	 SELECT @List =  STUFF(( SELECT ', ' + ISNULL(em.Error_Description, '') FROM Error_Code_Master EM  (NOLOCK)  
	 INNER JOIN @Tbl L ON EM.Upload_Error_Code = L.List  
	 FOR XML PATH(''),ROOT('MyString'),TYPE).value('/MyString[1]','varchar(max)'),1,2,'')    
   
	 SELECT  @List AS ErrorDescription  
 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHGetErrorList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

