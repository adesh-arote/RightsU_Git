CREATE FUNCTION [dbo].[UFNGetTalentList] 
(@List as NVARCHAR(MAX))
   RETURNS NVARCHAR(MAX) 
AS
BEGIN
	DECLARE @Tbl Table(List nvarchar(max))
	
	INSERT INTO @Tbl(List)
	SELECT NUMBER FROM fn_Split_withdelemiter(@List,',')

	SELECT @List =  STUFF(( SELECT ', ' + ISNULL(Talent_Name, '') FROM Talent T 
	INNER JOIN @Tbl L ON T.Talent_Code = L.List
	FOR XML PATH(''),ROOT('MyString'),TYPE).value('/MyString[1]','varchar(max)'),1,2,'')  
	
	RETURN @List
END
