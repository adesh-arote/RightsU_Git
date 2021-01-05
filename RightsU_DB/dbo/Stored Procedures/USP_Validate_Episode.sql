CREATE PROC [dbo].[USP_Validate_Episode]
(
	@Title_with_Episode NVARCHAR(max),
	@Program_Type CHAR(1)
)
AS 
BEGIN
			--DECLARE @Title_with_Episode varchar(max)
			--set @Title_with_Episode = ''
			--set @Title_with_Episode  = '808~1,808~500'

			IF OBJECT_ID('tempdb..#Invalid_Episode_ID') IS NOT NULL
			BEGIN
				DROP TABLE #Invalid_Episode_ID
			END
	
			Create table #Invalid_Episode_ID
			(
				Title NVARCHAR(MAX)
				,Episode_Id  varchar(4000)
			)
			DECLARE  @tbl AS TABLE(id INT,number VARCHAR(max))                                           
			INSERT INTO @tbl                                          
			SELECT * from [DBO].[FN_SPLIT_WITHDELEMITER](@Title_with_Episode ,',')


			
			DECLARE  @Title_Episode_Cur NVARCHAR(MAX),@Title_Cur int,@Episode_Cur int
			set @Title_Episode_Cur =''
			set @Title_Cur = 0
			set @Episode_Cur = 0
			
			
			BEGIN TRY

				DECLARE CR_Title_HouseID_Data CURSOR                   
				FOR 
						Select number from @tbl
				OPEN CR_Title_HouseID_Data             
				FETCH NEXT FROM CR_Title_HouseID_Data INTO  @Title_Episode_Cur
				WHILE @@FETCH_STATUS<>-1             
				BEGIN            
					IF(@@FETCH_STATUS<>-2)                                                          
					BEGIN  
							select @Title_Cur = case when number = '' then 0 else cast(number as int) end  from [DBO].[FN_SPLIT_WITHDELEMITER](@Title_Episode_Cur ,'~') where id = 1
							select @Episode_Cur = case when number = '' then 0 else cast(number as int) end  from [DBO].[FN_SPLIT_WITHDELEMITER](@Title_Episode_Cur ,'~') where id = 2
							
							IF ((select count(TCM.Acq_Deal_Movie_Code) from Title_Content_Mapping TCM
									inner join Title_Content TC ON TC.Title_Content_Code = TCM.Title_Content_Code
									AND ((TC.Title_Code in (@Title_Cur) AND @Program_Type ='M') OR (TCM.Acq_Deal_Movie_Code in (@Title_Cur) AND @Program_Type ='S')) AND TC.Episode_No in (@Episode_Cur))
												<= 0 
							  )
							--IF (   (select count(ADM.Acq_Deal_Movie_Code) from Acq_Deal_Movie ADM 
							--		inner join  Acq_Deal_Movie_Contents ADMC on ADMC.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code 
							--					AND ADM.Title_Code in (@Title_Cur) AND ADMC.Episode_Id in (@Episode_Cur))
							--					<= 0 
							--  )
							  BEGIN
									insert into #Invalid_Episode_ID
									select @Title_Cur,@Episode_Cur
							  END
					END            
				FETCH NEXT FROM CR_Title_HouseID_Data INTO  @Title_Episode_Cur
				END                                                       
				CLOSE CR_Title_HouseID_Data            
				DEALLOCATE CR_Title_HouseID_Data
			END TRY 
			BEGIN CATCH
				CLOSE CR_Title_HouseID_Data            
				DEALLOCATE CR_Title_HouseID_Data	
			END CATCH
			

			select t.Title_Name as TitleName , temp.Episode_Id as EpisodeNo from #Invalid_Episode_ID Temp
			inner join Title T on T.Title_Code  = temp.Title

			--DROP TABLE #Invalid_Episode_ID

			IF OBJECT_ID('tempdb..#Invalid_Episode_ID') IS NOT NULL DROP TABLE #Invalid_Episode_ID
END



/* 
	EXEC dbo.USP_Validate_Episode '808~1,808~500' 

*/