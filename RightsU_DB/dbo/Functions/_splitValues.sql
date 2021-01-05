
CREATE FUNCTION _splitValues(@str nvarchar(max),@Char char)  
RETURNS @tbl1 TABLE(  
ID int identity(1,1),  
DATA nvarchar(max)  
)  
AS   
BEGIN  
 DECLARE @value INT,@count INT,@mainValue VARCHAR(10)  
 DECLARE @LongSentence VARCHAR(MAX)  
 DECLARE @FindSubString VARCHAR(MAX)  
 SET @FindSubString = ','  
 SELECT @count = (LEN(@str) - LEN(REPLACE(@str, @FindSubString, '')))/LEN(@FindSubString)   
  
 WHILE (@count>0)  
 BEGIN   
   SELECT @value =  CHARINDEX(@Char,@str)  
   SELECT @mainValue = SUBSTRING(@str,1,@value-1)  
   INSERT INTO @tbl1 VALUES(RTRIM(LTRIM(@mainValue)))  
   SELECT @str = SUBSTRING(@str,@value+1,LEN(@str))    
   SET @count = @count-1  
  
   IF(LEN(@str)=1)  
   BEGIN  
    INSERT INTO @tbl1 VALUES(RTRIM(LTRIM(@str)))  
   END  
 END  
 IF(@str not like '')  
 BEGIN  
  INSERT INTO @tbl1 VALUES(RTRIM(LTRIM(@str)))  
 END  
 RETURN  
END