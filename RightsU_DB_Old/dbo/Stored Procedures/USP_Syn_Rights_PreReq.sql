CREATE PROCEDURE [dbo].[USP_Syn_Rights_PreReq]
(
	@Syn_Deal_Code INT,
	@Deal_Type_Code INT,
	@Data_For VARCHAR(100),
	@Call_From VARCHAR(3),	
	@Country_Territory_Codes VARCHAR(1000),
	@Sub_Lang_Codes VARCHAR(1000),
	@Dub_Lang_Codes VARCHAR(1000)
)
AS
/*=======================================================================================================================================
Author:			Sagar Mahajan
Create date:	06 Apr 2016
Description:	Call From Syn Rights Page
Note: Bind ROFR And Sublicensing ddl				
Flag for All Masters :
				ROR	= ROFR(Rights for Refusal)
				SBL	= SubLicencing					
				SL  = SubTitle Lang.
				SG  = SubTitle Lang. Group.
				DL  = Dubbing Lang.				  
				DG  = Dubbing Group.
				T   = Territory
				C   = Couuntry
				THT = Theatrical Territory
				THC = Theatrical Country
=======================================================================================================================================*/
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;

	--DECLARE
	--@Data_For VARCHAR(MAX) = 'DTG,ROL,DTP,MDS,DTC,CTG,ENT,BUT,CUR,VEN,VPC',
	--@Call_From VARCHAR(3) = 'GEN',	
	--@Syn_Deal_Code INT = 0	

	IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)
		DROP TABLE #PreReqData
	
	IF(OBJECT_ID('TEMPDB..#Data_For') IS NOT NULL)
		DROP TABLE #Data_For


	CREATE TABLE #Data_For
	(
		Flag VARCHAR(1000)
	)
	CREATE TABLE #PreReqData
	(
		PreReqData_Id INT Identity(1,1),
		Display_Value INT,
		Display_Text NVARCHAR(MAX),
		Data_For VARCHAR(3)
	)
	
	INSERT INTO #Data_For(Flag)
	SELECT number FROM fn_Split_withdelemiter(@Data_For,',')
	
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'TIT')
	BEGIN					
		INSERT INTO #PreReqData(Display_Value, Display_Text)
		EXEC USP_Bind_Title @Syn_Deal_Code, @Deal_Type_Code, 'S'
		
		UPDATE #PreReqData SET Data_For = 'TIT' WHERE ISNULL(Data_For,'') = ''
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'ROR')
	BEGIN		
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT 0 AS Display_Value, 'Please select' AS Display_Text, 'ROR' AS Data_For	
						
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT R.ROFR_Code, R.ROFR_Type, 'ROR' AS Data_For FROM ROFR R 
		WHERE R.Is_Active = 'Y'
		ORDER BY R.ROFR_Type
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SBL')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT S.Sub_License_Code, S.Sub_License_Name, 'SBL' AS Data_For FROM Sub_License S 
		WHERE S.Is_Active = 'Y'
		ORDER BY S.Sub_License_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'C')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT C.Country_Code,C.Country_Name, 'RGN' AS Data_For FROM Country C 
		WHERE C.Is_Active = 'Y' AND C.Country_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
		AND C.Is_Theatrical_Territory = 'N'
		ORDER BY C.Country_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'THC')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT C.Country_Code,C.Country_Name, 'RGN' AS Data_For FROM Country C 
		WHERE C.Is_Active = 'Y' AND C.Country_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
		AND C.Is_Theatrical_Territory = 'Y'
		ORDER BY C.Country_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'T')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT T.Territory_Code,T.Territory_Name, 'RGN' AS Data_For FROM Territory T 
		WHERE T.Is_Active = 'Y' AND T.Territory_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
		AND T.Is_Thetrical = 'N'
		ORDER BY T.Territory_Name
	END	
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'THT')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT T.Territory_Code,T.Territory_Name, 'RGN' AS Data_For FROM Territory T 
		WHERE T.Is_Active = 'Y' AND T.Territory_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
		AND T.Is_Thetrical = 'Y'
		ORDER BY T.Territory_Name
	END	
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SL')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT SL.Language_Code,SL.Language_Name, 'SL' AS Data_For FROM [Language] SL 
		WHERE SL.Is_Active = 'Y' AND SL.Language_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Sub_Lang_Codes,','))
		ORDER BY SL.Language_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SG')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT SG.Language_Group_Code,SG.Language_Group_Name, 'SL' AS Data_For FROM [Language_Group] SG 
		WHERE SG.Is_Active = 'Y' AND SG.Language_Group_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Sub_Lang_Codes,','))
		ORDER BY SG.Language_Group_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'DL')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT DL.Language_Code,DL.Language_Name, 'DL' AS Data_For FROM [Language] DL 
		WHERE DL.Is_Active = 'Y' AND DL.Language_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Dub_Lang_Codes,','))
		ORDER BY DL.Language_Name
	END
	IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'DG')
	BEGIN
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT DG.Language_Group_Code,DG.Language_Group_Name, 'DL' AS Data_For FROM [Language_Group] DG 
		WHERE DG.Is_Active = 'Y' AND DG.Language_Group_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Dub_Lang_Codes,','))
		ORDER BY DG.Language_Group_Name
	END
	--Result
	SELECT Display_Value, Display_Text, Data_For,PreReqData_Id FROM #PreReqData ORDER BY PreReqData_Id

	DROP TABLE #PreReqData
END
/*
EXEC [USP_Syn_Rights_PreReq] 1079,1,'C,SL,DL','A','0,1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108','0','0,8'
/*	
DECLARE @Display_Value INT = 0,@Display_Text VARCHAR(2000)='Display_Text'
SELECT @Display_Value AS Display_Value , @Display_Text AS Display_Text, 'asasasasasasasas' AS Data_For 
*/
*/
