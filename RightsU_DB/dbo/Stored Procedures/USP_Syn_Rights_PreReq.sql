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
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Rights_PreReq]', 'Step 1', 0, 'Started Procedure', 0, '' 
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
			SELECT DISTINCT R.ROFR_Code, R.ROFR_Type, 'ROR' AS Data_For FROM ROFR R  (NOLOCK)
			WHERE R.Is_Active = 'Y'
			ORDER BY R.ROFR_Type
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SBL')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT S.Sub_License_Code, S.Sub_License_Name, 'SBL' AS Data_For FROM Sub_License S  (NOLOCK)
			WHERE S.Is_Active = 'Y'
			ORDER BY S.Sub_License_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'C')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT C.Country_Code,C.Country_Name, 'RGN' AS Data_For FROM Country C  (NOLOCK)
			WHERE C.Is_Active = 'Y' AND C.Country_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
			AND C.Is_Theatrical_Territory = 'N'
			ORDER BY C.Country_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'THC')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT C.Country_Code,C.Country_Name, 'RGN' AS Data_For FROM Country C  (NOLOCK)
			WHERE C.Is_Active = 'Y' AND C.Country_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
			AND C.Is_Theatrical_Territory = 'Y'
			ORDER BY C.Country_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'T')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT T.Territory_Code,T.Territory_Name, 'RGN' AS Data_For FROM Territory T  (NOLOCK)
			WHERE T.Is_Active = 'Y' AND T.Territory_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
			AND T.Is_Thetrical = 'N'
			ORDER BY T.Territory_Name
		END	
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'THT')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT T.Territory_Code,T.Territory_Name, 'RGN' AS Data_For FROM Territory T  (NOLOCK)
			WHERE T.Is_Active = 'Y' AND T.Territory_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Territory_Codes,','))
			AND T.Is_Thetrical = 'Y'
			ORDER BY T.Territory_Name
		END	
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SL')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT SL.Language_Code,SL.Language_Name, 'SL' AS Data_For FROM [Language] SL  (NOLOCK)
			WHERE SL.Is_Active = 'Y' AND SL.Language_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Sub_Lang_Codes,','))
			ORDER BY SL.Language_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'SG')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT SG.Language_Group_Code,SG.Language_Group_Name, 'SL' AS Data_For FROM [Language_Group] SG  (NOLOCK)
			WHERE SG.Is_Active = 'Y' AND SG.Language_Group_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Sub_Lang_Codes,','))
			ORDER BY SG.Language_Group_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'DL')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT DL.Language_Code,DL.Language_Name, 'DL' AS Data_For FROM [Language] DL  (NOLOCK)
			WHERE DL.Is_Active = 'Y' AND DL.Language_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Dub_Lang_Codes,','))
			ORDER BY DL.Language_Name
		END
		IF EXISTS(SELECT TOP 1 Flag FROM #Data_For WHERE Flag = 'DG')
		BEGIN
			INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
			SELECT DISTINCT DG.Language_Group_Code,DG.Language_Group_Name, 'DL' AS Data_For FROM [Language_Group] DG  (NOLOCK)
			WHERE DG.Is_Active = 'Y' AND DG.Language_Group_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Dub_Lang_Codes,','))
			ORDER BY DG.Language_Group_Name
		END
		--Result
		SELECT Display_Value, Display_Text, Data_For,PreReqData_Id FROM #PreReqData ORDER BY PreReqData_Id

		--DROP TABLE #PreReqData

		IF OBJECT_ID('tempdb..#Data_For') IS NOT NULL DROP TABLE #Data_For
		IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData
	 
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_Syn_Rights_PreReq]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END