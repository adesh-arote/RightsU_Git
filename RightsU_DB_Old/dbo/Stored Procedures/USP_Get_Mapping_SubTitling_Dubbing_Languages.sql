CREATE PROCEDURE [dbo].[USP_Get_Mapping_SubTitling_Dubbing_Languages]
(
	@Syn_Deal_Rights_Codes VARCHAR(2000),
	@Selected_SubTitling_Language_Codes VARCHAR(4000),
	@Selected_Dubbing_Language_Codes VARCHAR(4000)
)	
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date:	29 April 2015
-- Description:	Call From Acq Save Rights if Amendment. after Syndiacation.
-- =============================================
BEGIN
	DECLARE @Mapped_SubTitling_Language_Codes VARCHAR(4000)='', @Mapped_Dubbing_Language_Codes VARCHAR(4000)=''
	SET NOCOUNT ON;
	SELECT @Mapped_SubTitling_Language_Codes = STUFF(( SELECT  DISTINCT ',' +   CAST(tbl.Language_Code AS VARCHAR)
	FROM 
	(
		SELECT DISTINCT CASE WHEN  SDRS.Language_Type = 'G' THEN LGD.Language_Code ELSE SDRS.Language_Code END AS Language_Code
		--,SDRS.Syn_Deal_Rights_Code
		FROM Syn_Deal_Rights_Subtitling SDRS 
		LEFT JOIN Language_Group_Details LGD ON SDRS.Language_Group_Code = LGD.Language_Group_Code
		WHERE SDRS.Syn_Deal_Rights_Code IN(SELECT number FROM fn_Split_withdelemiter(@Syn_Deal_Rights_Codes,','))
	) AS tbl
	WHERE tbl.Language_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_SubTitling_Language_Codes,','))
	FOR XML PATH('')), 1, 1, '') 

	SELECT @Mapped_Dubbing_Language_Codes = STUFF(( SELECT  DISTINCT ',' +  CAST(tbl.Language_Code AS VARCHAR)
	FROM 
	(
		SELECT DISTINCT CASE WHEN  SDRD.Language_Type = 'G' THEN LGD.Language_Code ELSE SDRD.Language_Code END AS Language_Code
		--,SDRD.Syn_Deal_Rights_Code
		FROM Syn_Deal_Rights_Dubbing SDRD 
		LEFT JOIN Language_Group_Details LGD ON SDRD.Language_Group_Code = LGD.Language_Group_Code
		WHERE SDRD.Syn_Deal_Rights_Code IN(SELECT number FROM fn_Split_withdelemiter(@Syn_Deal_Rights_Codes,','))
	) AS tbl
	WHERE tbl.Language_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Dubbing_Language_Codes,','))
	FOR XML PATH('')), 1, 1, '') 


	SELECT @Mapped_SubTitling_Language_Codes AS Mapped_SubTitling_Language_Codes,@Mapped_Dubbing_Language_Codes AS Mapped_Dubbing_Language_Codes 
END


--EXEC [dbo].[USP_Get_Mapping_SubTitling_Dubbing_Languages] '19','53,60,64,54','1'