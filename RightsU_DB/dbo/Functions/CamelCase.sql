CREATE function CamelCase
(
	@Name varchar(2000)
)
RETURNS VARCHAR(2000) WITH SCHEMABINDING  
AS
BEGIN

	Set @Name = Replace(@Name,CHAR(0),CHAR(32));
	--Horizontal Tab
	Set @Name = Replace(@Name,CHAR(9),CHAR(32));
	--Line Feed
	Set @Name = Replace(@Name,CHAR(10),CHAR(32));
	--Vertical Tab
	Set @Name = Replace(@Name,CHAR(11),CHAR(32));
	--Form Feed
	Set @Name = Replace(@Name,CHAR(12),CHAR(32));
	--Carriage Return
	Set @Name = Replace(@Name,CHAR(13),CHAR(32));
	--Column Break
	Set @Name = Replace(@Name,CHAR(14),CHAR(32));
	--Non-breaking space
	Set @Name = Replace(@Name,CHAR(160),CHAR(32));
 
	Set @Name = LTRIM(RTRIM(@Name));
  DECLARE @Result varchar(2000)
  SET @Name = LOWER(@Name) + ' '
  SET @Result = ''
  WHILE 1=1
  BEGIN
    IF PATINDEX('% %',@Name) = 0 BREAK
    SET @Result = @Result + UPPER(Left(@Name,1))+
    SubString  (@Name,2,CharIndex(' ',@Name)-1)
    SET @Name = SubString(@Name,
      CharIndex(' ',@Name)+1,Len(@Name))
  END
  SET @Result = Left(@Result,Len(@Result))
  RETURN @Result
END
