alter FUNCTION [dbo].[UFN_Get_Report_Ancillary_Rights](@Title_Codes VARCHAR(2000), @Deal_Code VARCHAR(2000), @Platform_Str VARCHAR(4000))      
RETURNS NVARCHAR(MAX)  
AS      
BEGIN     
--declare @Title_Codes VARCHAR(2000)='27753', @RowId INT=1, @Deal_Code VARCHAR(2000)='15216',
--@Platform_Str VARCHAR(2000)='111,112,113,123,124,125,182,183,184,191,192,193'  
  
	DECLARE @Temp_Ancillary AS TABLE(  
		Ancillary_Type NVARCHAR(2000),  
		Catch_Up_From NVARCHAR(2000),  
		Days NVARCHAR(500),   
		Platform_Codes VARCHAR(2000),
		Ancillary_platform NVARCHAR(4000),
		Remarks NVARCHAR(MAX)  
	)  

	DECLARE @Temp_Platform AS TABLE(  
		Platform_Code INT 
	)  
	
	INSERT INTO @Temp_Platform(Platform_Code)  
	SELECT  CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@Platform_Str,',') WHERE number NOT IN('0', '') 
	
	
	INSERT INTO @Temp_Ancillary(Ancillary_Type, Catch_Up_From, Days, Platform_Codes, Remarks)
	SELECT At.Ancillary_Type_Name, ADA.Catch_Up_From, ADA.Day, 
	LTRIM(STUFF(
	(
		SELECT DISTINCT ',' + CAST(ADAP.Platform_Code AS VARCHAR(5))
		FROM Acq_Deal_Ancillary_Platform ADAP
		INNER JOIN @Temp_Platform tp ON tp.Platform_Code = ADAP.Platform_Code AND ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_deal_Ancillary_Code
		FOR XML PATH('')         
	), 1, 1, '')) AS Platform_Codes,
	ISNULL(ADA.Remarks,'')  
	FROM Acq_Deal_Ancillary ADA
	INNER JOIN Acq_Deal_ancillary_Title ADAT ON ADA.Acq_Deal_Ancillary_Code = ADAT.Acq_Deal_Ancillary_Code AND ADAT.Title_Code = @Title_Codes  
	INNER JOIN Ancillary_Type AT ON AT.Ancillary_Type_Code = ADA.Ancillary_Type_code

	DECLARE @Ancillary_Rights NVARCHAR(MAX)
	SET @Ancillary_Rights =  LTRIM(STUFF(      
	(      
		SELECT DISTINCT ', ' + T.Ancillary_Type +': ' +  
		CASE WHEN ISNULL(T.Catch_Up_From,'') = 'E'  
		THEN 'Catch Up From Each Broadcast; '   
		WHEN ISNULL(T.Catch_Up_From,'') = 'F' THEN 'Catch Up From First Broadcast; '  
		ELSe '' END  
		+ CASE WHEN ISNUll(T.Days,'') = '' THEN ''
		ELSe + T.Days +' Days'+ '; ' END + 
		CASE WHEN ISNULL(T.Remarks, '') = '' THEN ''
		ELSe 'Remarks : ' + T.Remarks END + '$' + 		
		LTRIM(STUFF(
		(
			SELECT '$' + Platform_Hiearachy FROM DBO.UFN_Get_Platform_With_Parent(T.Platform_Codes)
			FOR XML PATH('')         
		), 1, 1, ''))
		+'$' +''+'$' FROM @Temp_Ancillary T     
		FOR XML PATH('')      
	), 1, 1, ''))   


	--SELECT ISNULL(REPLACE(@Ancillary_Rights, ',', ''),'');
	RETURN   ISNULL(REPLACE(@Ancillary_Rights, ',', ''),'')  
END   

