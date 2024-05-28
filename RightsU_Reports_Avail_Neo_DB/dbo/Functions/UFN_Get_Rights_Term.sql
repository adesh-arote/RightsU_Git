CREATE FUNCTION [dbo].[UFN_Get_Rights_Term]
(
    @Start_Date DateTime,
    @End_Date DateTime,
    @Term Varchar(10)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
--DECLARE
--    @Start_Date DateTime =  CAST('2020-02-01' AS DATETIME),    
--    @End_Date DateTime = CAST('2022-03-06'AS DATETIME),
--    @Term Varchar(10) = '2.5.10'



   DECLARE @RetVal varchar(100) = '', @Year INT, @Month INT, @Day INT, @IndexOfDot INT, @LengthOfTerm INT



   IF(@Term = '' And @Start_Date IS NOT NULL And @End_Date IS NOT NULL)
    BEGIN
        SET @Term = DBO.[UFN_Calculate_Term](@Start_Date, @End_Date)
    END
    IF(LTRIM(RTRIM(ISNULL(@Term,''))) <> '')
    BEGIN
        SET @IndexOfDot = Charindex('.', @Term)
        SET @LengthOfTerm = LEN(@Term)
        IF(@LengthOfTerm > 1)
        BEGIN



           Select @Year = number  From DBO.fn_Split_withdelemiter(@Term, '.') WHERE number <> '' and id = 1
            Select @Month = number  From DBO.fn_Split_withdelemiter(@Term, '.') WHERE number <> '' and id = 2
            Select @Day = number  From DBO.fn_Split_withdelemiter(@Term, '.') WHERE number <> '' and id = 3



           --SET @Year =  CAST(Substring(@Term, 1,@IndexOfDot-1) AS INT)
            --SET @Month =  CAST(Substring(@Term, @IndexOfDot + 1 ,@LengthOfTerm - @IndexOfDot ) AS INT)
    
            
            IF(@Year > 0)
            BEGIN
                SET @RetVal = CAST(@Year AS VARCHAR) + ' Year'
                IF(@Year > 1)
                    SET @RetVal += 's'
                
                SET @RetVal += ' '
            END
            
            IF(@Month > 0)
            BEGIN
                SET @RetVal += CAST(@Month AS VARCHAR) + ' Month'
                IF(@Month > 1)
                    SET @RetVal += 's'
                    SET @RetVal += ' '
            END



           IF(@Day > 0)
            BEGIN
                SET @RetVal += CAST(@Day AS VARCHAR) + ' Day'
                IF(@Day > 1)
                    SET @RetVal += 's'
            END
        END
    END
    RETURN @RetVal
END