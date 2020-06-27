CREATE FUNCTION UFN_Syn_Acq_Mapping
(
	 @View_Type Char(1),
	 @Right_Code INT,	 
	 @Title_Codes INT,
	 @Platform_Codes INT
)
RETURNS CHAR(1)
AS
-- ==========================================================================================
-- Author:		SAGAR MAHAJAN
-- Create date: 14 April 2015
-- Description:	Call From USP_List_Rights. Check Acq Rights is Syndicate or not 
-- ==========================================================================================
BEGIN
	DECLARE @Is_Syn_Acq_Mapping CHAR(1) = 'N',@Syn_Deal_Rights_Code VARCHAR(1000) = ''	
	SELECT @Syn_Deal_Rights_Code = STUFF((SELECT DISTINCT  ',' + CAST(Syn_Deal_Rights_Code AS VARCHAR)
FROM Syn_Acq_Mapping SAM 	
WHERE Deal_Rights_Code = @Right_Code
FOR XML PATH('')) , 1, 1, '')               
IF(@Syn_Deal_Rights_Code<>'')
BEGIN
	--SELECT @Syn_Deal_Rights_Code AS Syn_Deal_Rights_Code		
	IF(@View_Type='D')
	BEGIN
		IF EXISTS(SELECT TOP 1 SDRP.Syn_Deal_Rights_Code 
		FROM Syn_Deal_Rights_Platform SDRP
		WHERE SDRP.Syn_Deal_Rights_Code IN
		(
			SELECT A.Syn_Rights_Code FROM 
			(
				SELECT  SDRT.Syn_Deal_Rights_Code  AS Syn_Rights_Code
				FROM Syn_Deal_Rights_Title SDRT 
				WHERE SDRT.Syn_Deal_Rights_Code IN
				(
					SELECT number FROM fn_Split_withdelemiter(@Syn_Deal_Rights_Code,',')
				)
				AND SDRT.Title_Code IN
				(
					SELECT number FROM fn_Split_withdelemiter(@Title_Codes,',')
				)
			) as A
		)
		AND SDRP.Platform_Code IN
		(
			SELECT number FROM fn_Split_withdelemiter(@Platform_Codes,',')
		))
		SET @Is_Syn_Acq_Mapping = 'Y'
	END
	ELSE IF(@View_Type='S')
	BEGIN	
		IF EXISTS(SELECT  SDRT.Syn_Deal_Rights_Code  AS Syn_Rights_Code
		FROM Syn_Deal_Rights_Title SDRT 
		WHERE SDRT.Syn_Deal_Rights_Code IN
		(
			SELECT number FROM fn_Split_withdelemiter(@Syn_Deal_Rights_Code,',')
		)
		AND SDRT.Title_Code IN
		(
			SELECT number FROM fn_Split_withdelemiter(@Title_Codes,',')
		))
		SET @Is_Syn_Acq_Mapping = 'Y'
	END
	ELSE
		SET @Is_Syn_Acq_Mapping = 'Y'
END
	-- Return the result of the function
	RETURN @IS_Syn_Acq_Mapping
END