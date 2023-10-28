CREATE PROC [dbo].[USP_GetContentsMusicData]  
(  
	@Title_Content_Code BIGINT
)  
AS  
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 11 January 2017
-- Description:	Get Content Music data
-- =============================================
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsMusicData]', 'Step 1', 0, 'Started Procedure', 0, ''

		SELECT MT.Music_Title_Name, COALESCE(MA.Music_Album_Name, MT.Movie_Album, '') AS Movie_Album, ML.Music_Label_Name, V.Version_Name [Version], V.Version_Code, 
		CONVERT(VARCHAR,CML.[From],108) + ':' +  RIGHT('00' + CAST(ISNULL(CML.From_Frame, 0) AS VARCHAR), 2) [From],  
		CONVERT(VARCHAR,CML.[To],108) + ':' + RIGHT('00' + CAST(ISNULL(CML.To_Frame, 0) as VARCHAR), 2) [To],  
		CONVERT(VARCHAR,CML.[Duration],108) + ':' +RIGHT('00' +  CAST(ISNULL(CML.Duration_Frame, 0) as VARCHAR), 2) [Duration]
		FROM Title_Content TC (NOLOCK)
		INNER JOIN Content_Music_Link CML (NOLOCK) ON CML.Title_Content_Code = TC.Title_Content_Code
		INNER JOIN Title_Content_Version TCV (NOLOCK) ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
		INNER JOIN [Version] V (NOLOCK) ON V.Version_Code = TCV.Version_Code
		INNER JOIN Music_Title MT (NOLOCK) ON MT.Music_Title_Code = CML.Music_Title_Code
		INNER JOIN Music_Title_Label MTL (NOLOCK) ON MT.Music_Title_Code = MTL.Music_Title_Code  
			AND MTL.Effective_To IS NULL
		INNER JOIN Music_Label ML (NOLOCK) ON MTL.Music_Label_Code = ML.Music_Label_Code  
		LEFT JOIN Music_Type MTY (NOLOCK) ON MTY.Music_Type_Code = MT.Music_Type_Code  
		LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
		WHERE TC.Title_Content_Code = @Title_Content_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsMusicData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END