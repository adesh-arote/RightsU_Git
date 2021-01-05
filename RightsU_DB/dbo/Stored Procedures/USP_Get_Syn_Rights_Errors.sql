CREATE PROC [dbo].[USP_Get_Syn_Rights_Errors]
(
	@Code INT, 
	@Call_From CHAR(1)
)
AS
BEGIN
	SET FMTONLY OFF
	
	CREATE TABLE #Temp_Rigths(
		Syn_Deal_Rights_Code INT
	)

	IF(@Call_From = 'L')
	BEGIN
		INSERT INTO #Temp_Rigths
		SELECT Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Code
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Rigths
		SELECT @Code
	END

	SELECT DISTINCT Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name,
			Subtitling_Language, Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, IsPushback, Promoter_Group_Name, Promoter_Remark_DESC
	FROM	Syn_Deal_Rights_Error_Details 
	WHERE Syn_Deal_Rights_Code In (SELECT Syn_Deal_Rights_Code FROM #Temp_Rigths)

	--DROP TABLE #Temp_Rigths
	IF OBJECT_ID('tempdb..#Temp_Rigths') IS NOT NULL DROP TABLE #Temp_Rigths
END