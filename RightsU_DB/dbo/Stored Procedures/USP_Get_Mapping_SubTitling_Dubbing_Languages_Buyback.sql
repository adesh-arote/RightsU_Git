CREATE PROCEDURE [dbo].[USP_Get_Mapping_SubTitling_Dubbing_Languages_Buyback]
(
	@Acq_Deal_Rights_Codes VARCHAR(2000),
	@Selected_SubTitling_Language_Codes VARCHAR(4000),
	@Selected_Dubbing_Language_Codes VARCHAR(4000)
)	
AS
-- =============================================
-- Author:		Rahul Kembhavi
-- Create date:	24 Aug 2022
-- Description:	Call From Acq Save Rights if Amendment. after Buyback.
-- =============================================
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Mapping_SubTitling_Dubbing_Languages_Buyback]', 'Step 1', 0, 'Started Procedure', 0, ''

		DECLARE @Mapped_SubTitling_Language_Codes VARCHAR(4000)='', @Mapped_Dubbing_Language_Codes VARCHAR(4000)=''
		SET NOCOUNT ON;
		SELECT @Mapped_SubTitling_Language_Codes = STUFF(( SELECT  DISTINCT ',' +   CAST(tbl.Language_Code AS VARCHAR)
		FROM 
		(
			SELECT DISTINCT CASE WHEN  SDRS.Language_Type = 'G' THEN LGD.Language_Code ELSE SDRS.Language_Code END AS Language_Code
			--,SDRS.Syn_Deal_Rights_Code
			FROM Acq_Deal_Rights_Subtitling SDRS (NOLOCK) 
			LEFT JOIN Language_Group_Details LGD (NOLOCK) ON SDRS.Language_Group_Code = LGD.Language_Group_Code
			WHERE SDRS.Acq_Deal_Rights_Code IN(SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Codes,','))
		) AS tbl
		WHERE tbl.Language_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_SubTitling_Language_Codes,','))
		FOR XML PATH('')), 1, 1, '') 

		SELECT @Mapped_Dubbing_Language_Codes = STUFF(( SELECT  DISTINCT ',' +  CAST(tbl.Language_Code AS VARCHAR)
		FROM 
		(
			SELECT DISTINCT CASE WHEN  SDRD.Language_Type = 'G' THEN LGD.Language_Code ELSE SDRD.Language_Code END AS Language_Code
			--,SDRD.Syn_Deal_Rights_Code
			FROM Acq_Deal_Rights_Dubbing SDRD  (NOLOCK)
			LEFT JOIN Language_Group_Details LGD (NOLOCK) ON SDRD.Language_Group_Code = LGD.Language_Group_Code
			WHERE SDRD.Acq_Deal_Rights_Code IN(SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Codes,','))
		) AS tbl
		WHERE tbl.Language_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Dubbing_Language_Codes,','))
		FOR XML PATH('')), 1, 1, '') 


		SELECT @Mapped_SubTitling_Language_Codes AS Mapped_SubTitling_Language_Codes,@Mapped_Dubbing_Language_Codes AS Mapped_Dubbing_Language_Codes 
			
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Mapping_SubTitling_Dubbing_Languages_Buyback]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END