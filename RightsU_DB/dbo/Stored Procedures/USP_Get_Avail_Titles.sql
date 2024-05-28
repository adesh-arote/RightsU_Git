CREATE proc [dbo].[USP_Get_Avail_Titles]     

 @txtSearch nvarchar(max),    
 @BU_Code VARCHAR(200), 
 @AvailType char(1),
 @TitleNoInCodes Varchar(1000) 
As
-- =============================================    
-- Author:  Rahul Kembhavi    
-- Create date: 15 May 2017    
-- Description: This Procedure will search Title Names    
-- =============================================    
BEGIN    
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Avail_Titles]', 'Step 1', 0, 'Started Procedure', 0, '' 
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
		--DECLARE
		--@txtSearch  nvarchar(max) = 'sad',   
		--@BU_Code  VARCHAR(200)= '0~0' ,
		--@AvailType char(1) = 'S',
		--@TitleNoInCodes Varchar(1000) = ''

		DECLARE @DealTypeCode INT = 0

		IF CHARINDEX('~',@BU_Code) > 0   
		BEGIN  

			SELECT @DealTypeCode = Number From Fn_Split_WithDelemiter (@BU_Code, '~') WHERE ID = 2
			SELECT @BU_Code = Number From Fn_Split_WithDelemiter (@BU_Code, '~') WHERE ID = 1
	
		END  


		IF(@AvailType = 'M')
			BEGIN
			--SELECT @DealTypeCode
				IF(@DealTypeCode = 0)
				BEGIN
					SELECT Title_Code,Title_Name FROM [title] (NOLOCK) where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
					AND IS_Active='Y' AND Deal_Type_Code in (1,33,10)
					AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm (NOLOCK) INNER JOIN Acq_Deal ad (NOLOCK) ON ad.Acq_Deal_Code = adm.Acq_Deal_Code WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
					AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g (NOLOCK) on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
					Title_Code IN (Select tt.Title_Code from Title_Talent tt (NOLOCK) INNER JOIN Talent t (NOLOCK) on t.Talent_Code = tt.Talent_Code 
					WHERE   t.Talent_Name like N'%'+@txtSearch+'%')     
					OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec (NOLOCK) WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    
		
				END
				ELSE
				BEGIN
					SELECT Title_Code,Title_Name FROM [title] (NOLOCK) where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
					AND IS_Active='Y' AND Deal_Type_Code = @DealTypeCode --in (1,33,10)
					AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm (NOLOCK) INNER JOIN Acq_Deal ad (NOLOCK) ON ad.Acq_Deal_Code = adm.Acq_Deal_Code WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
					AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg (NOLOCK) INNER JOIN Genres g (NOLOCK) on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
					Title_Code IN (Select tt.Title_Code from Title_Talent tt (NOLOCK) INNER JOIN Talent t (NOLOCK) on t.Talent_Code = tt.Talent_Code 
					WHERE   t.Talent_Name like N'%'+@txtSearch+'%')     
					OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec (NOLOCK) WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv (NOLOCK) WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    
				END
			END

		IF(@AvailType = 'S')
			BEGIN
				--SELECT @DealTypeCode
				IF(@DealTypeCode = 0)
				BEGIN
					SELECT Title_Code,Title_Name FROM [title] (NOLOCK) where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
					AND IS_Active='Y' AND Deal_Type_Code Not in (1,33,10)
					AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm (NOLOCK) INNER JOIN 
					Acq_Deal ad (NOLOCK) ON ad.Acq_Deal_Code = adm.Acq_Deal_Code
					WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
					AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g (NOLOCK) on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
					Title_Code IN (Select tt.Title_Code from Title_Talent tt (NOLOCK) INNER JOIN Talent t (NOLOCK) on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name like N'%'+@txtSearch+'%')     
					OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec (NOLOCK) WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv (NOLOCK) WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    

				END
				ELSE
				BEGIN
					SELECT Title_Code,Title_Name FROM [title] (NOLOCK) where Title_Code Not in (Select Number From Fn_Split_WithDelemiter (@TitleNoInCodes, ','))     
					AND IS_Active='Y' AND Deal_Type_Code = @DealTypeCode-- Not in (1,33,10)
					AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm (NOLOCK) INNER JOIN 
					Acq_Deal ad  (NOLOCK) ON ad.Acq_Deal_Code = adm.Acq_Deal_Code
					WHERE  ad.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  ad.Is_Master_Deal='Y' AND (ad.Business_Unit_Code= CAST(@BU_Code AS INT) OR CAST(@BU_Code AS INT) = 0))     
					AND ((Title_Name like '%'+@txtSearch+'%') OR (Year_Of_Production like '%'+@txtSearch+'%')  OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg (NOLOCK) INNER JOIN Genres g (NOLOCK) on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%'+@txtSearch+'%') OR
  
					Title_Code IN (Select tt.Title_Code from Title_Talent tt (NOLOCK) INNER JOIN Talent t (NOLOCK) on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name like N'%'+@txtSearch+'%')     
					OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec (NOLOCK) WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN  (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv (NOLOCK) WHERE ecv.Columns_Value LIKE N'%'+@txtSearch+'%')) )-- ORDER BY Title_Name ASC    
				END
			END
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Avail_Titles]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END
