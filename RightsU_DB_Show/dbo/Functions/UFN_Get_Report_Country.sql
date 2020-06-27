CREATE FUNCTION [dbo].[UFN_Get_Report_Country](@Country_Code_Str VARCHAR(4000),@Country_Code VARCHAR(4000), @RowId INT, @Acq_Rights_Code INT)  
	RETURNS @Tbl_Ret TABLE (  
	Region_Code INT,  
	Region_Name_In NVARCHAR(MAX),  
	Region_Name_NOTIn NVARCHAR(MAX)  
) AS  
BEGIN                                   
 --Declare @Country_Code_Str Varchar(2000) = '1,10,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,12,120,121,122,123,124,125,127,128,13,130,131,132,133,134,135,137,138,139,14,140,141,142,143,145,146,147,148,149,15,16,160,164,166,167,168,169,17,170,18,182,183,184,188,189,19,190,191,192,193,2,20,200,204,205,206,209,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,230,231,232,235,236,237,238,239,246,247,248,249,250,251,252,255,256,257,258,264,265,266,267,268,269,27,270,271,272,273,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,293,294,295,296,299,3,30,300,301,302,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,35,36,37,38,39,4,40,41,42,44,47,48,5,50,51,52,53,54,55,57,58,59,6,60,61,62,65,66,67,73,74,75,76,77,8,82,83,84,85,93,94,95,96,97,98,99'  
 --DECLARE @Country_Code VARCHAR(2000) = '0,23,289,24,314,296,27,28,40,30,31,32,35,20,36,37,38,1,39,41,14,42,44,315,2,47,48,312,50,51,53,265,54,55,57,58,22,59,299,60,61,62,316,317,65,66,284,67,73,74,75,76,77,238,82,83,84,85,239,93,94,95,271,96,97,266,98,318,319,320,99,100,12,101,321,322,102,103,310,104,105,313,106,324,107,108,325,109,110,111,112,113,326,114,115,116,311,3,18,117,118,119,120,121,122,123,124,125,127,128,280,294,130,131,267,133,300,134,135,301,268,13,137,293,302,138,4,139,140,282,141,142,19,276,143,304,146,147,148,149,270,160,164,281,5,166,327,328,167,168,169,170,288,182,329,330,183,184,6,331,188,277,189,132,190,191,332,192,193,333,200,237,295,145,275,204,205,206,334,221,223,283,335,209,210,272,211,212,213,214,17,215,269,278,216,217,218,305,219,8,220,222,224,225,226,306,227,228,229,230,231,16,235,236,232,309,285,287,246,247,248,249,250,286,251,252,10,15,255,256,279,257,258,52,336,273,337,338,264,307,308'  
 --Declare @RowId Int = 1  , @Acq_Rights_Code INT = 26056
   
 --Declare @Tbl_Ret TABLE (  
 -- Region_Code Int,  
 -- Region_Name_In NVarchar(MAX),  
 -- Region_Name_NOTIn NVarchar(MAX)  
 --)  

		DECLARE @Temp_Country AS TABLE(  
			Country_Code INT 
		)  
  
		DECLARE @Temp_Rights_Country AS TABLE(  
			Rights_Country_Code INT  
		)
		INSERT INTO @Temp_Country(Country_Code)  
		SELECT  CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code,',') WHERE number NOT IN('0', '') 
		
		INSERT INTO @Temp_Rights_Country(Rights_Country_Code)
		SELECT ISNULL(Country_Code,0) FROM Acq_Deal_Rights_Territory
		WHERE Acq_Deal_Rights_code IN(@Acq_Rights_Code) AND Territory_Type = 'I'
		UNION
		SELECT ISNULL(TD.Country_Code,0) FROM Acq_Deal_Rights_Territory ADRT 
		INNER JOIN Territory_Details TD ON ADRT.Territory_code = TD.Territory_Code
		WHERE Acq_Deal_Rights_code IN(@Acq_Rights_Code) AND Territory_Type = 'G'

		DELETE FROM @Temp_Country WHERE Country_Code = 0  
  
		DECLARE @Country_Name_IN NVARCHAR(MAX),  @Country_Name_Not_IN NVARCHAR(MAX)  
  
		SET @Country_Name_IN =  Ltrim(STUFF(
		(  
			SELECT DISTINCT ', ' + C.Country_Name From Country C  
			WHERE C.Country_Code IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code_Str,','))  
			FOR XML PATH('') 
		), 1, 1, ''))  
  
		IF(@Country_Code != '')
		BEGIN
			SET @Country_Name_Not_IN =  Ltrim(STUFF(
			(  
				SELECT DISTINCT ', ' + C.Country_Name 
				FROM @Temp_Country TC  
				INNER JOIN Country C ON C.Country_Code = TC.Country_Code 
				--INNER JOIN @Temp_Rights_Country TRC ON TRC.Rights_Country_Code = TC.Country_Code 
				WHERE TC.Country_Code NOT IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code_Str,','))  
				AND TC.Country_Code IN(Select Rights_Country_Code FROM @Temp_Rights_Country)
				FOR XML PATH('')  
			), 1, 1, ''))  
		END
		ELSE
		BEGIN	
			SET @Country_Name_Not_IN =  Ltrim(STUFF(
			(  
				SELECT DISTINCT ', ' + C.Country_Name 
				FROM @Temp_Rights_Country TC  
				INNER JOIN Country C ON C.Country_Code = TC.Rights_Country_Code  
				WHERE TC.Rights_Country_Code NOT IN(SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Country_Code_Str,','))  				
				FOR XML PATH('')  
			), 1, 1, ''))  
		END
  
		INSERT INTO @Tbl_Ret(Region_Code, Region_Name_In, Region_Name_NOTIn)  
		SELECT @RowId, @Country_Name_IN, @Country_Name_Not_IN  
	--select * from @Tbl_Ret  
	RETURN  
END  
