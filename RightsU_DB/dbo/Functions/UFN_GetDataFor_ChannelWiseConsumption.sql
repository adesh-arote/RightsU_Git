
-- =============================================
-- Author:		Bhavesh Desai
-- Create date: 14-Nov-2014
-- Description:	Get Details for ChannelWise Consumption Reports
-- =============================================
CREATE FUNCTION [dbo].[UFN_GetDataFor_ChannelWiseConsumption]
(
	@DMCode INT,
	@DMContentCode INT,
	@ChannelCode int,
	@RunDefinitionGrpCode INT,
	@DMR_IsGroupCode INT,
	@Run_defination_Type CHAR(10),                  
	@ResultFlag VARCHAR(50),
 	@Flag VARCHAR(10)
)
RETURNS VARCHAR(250)
AS
BEGIN
	DECLARE @Result VARCHAR(250) = 0
	
	IF(@ResultFlag = 'ColorCodes')
	BEGIN
		------------------------------------------- CREATE TEMP TABLES -------------------------------------------
		DECLARE @ColorCodes TABLE 
		(
			ID INT IDENTITY (1,1),
			Colorname NVARCHAR(250), 
			Color_RGB_Value VARCHAR(50)
		)
		--INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Medium Purple3','#7A5DC7')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Light Cyan2','#CFECEC')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Rosy Brown','#B38481')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Cyan3','#46C7C7')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('CornflowerBlue','#6495ED')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('CadetBlue','#5F9EA0')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Coral','#F76541')

		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('DarkGray','#A9A9A9')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('LightSteelBlue','#B0C4DE')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('PaleGoldenrod','#EEE8AA')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('SandyBrown','#F4A460')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Lawn Green','#87F717')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Sea Green3','#54C571')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Light Cyan2','#CFECEC')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Pale Turquoise3','#92C7C7')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Plum3','#C38EC7')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Medium Orchid','#B048B5')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('CadetBlue4','#4C787E')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Slate Blue2','#6960EC')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Deep Sky Blue3','#3090C7')
		INSERT INTO @ColorCodes (Colorname, Color_RGB_Value) VALUES ('Light Slate Blue','#736AFF')


		DECLARE @RunDefinitionGrpCode_Tbl TABLE 
		(
			ID INT IDENTITY (1,1),
			RDGrpCode INT,
			DMR_IsGroupCode INT,
			Colorname NVARCHAR(250), 
			Color_RGB_Value VARCHAR(50)
		)
		------------------------------------------- END CREATE TEMP TABLES -------------------------------------------
	END
	
	IF(@Flag = UPPER('MOVIE'))
	BEGIN
	
		--//----------------- Get No OF Runs --//-----------------
		IF((@Run_defination_Type = 'S') OR (@Run_defination_Type = 'N'))
		BEGIN
			
			IF(@ResultFlag = 'NoOfRuns')
			BEGIN
				SELECT DISTINCT              
				@Result = CASE WHEN DMRR.run_type = 'U' Then 'Unlimited' ELSE CAST(ISNULL(DMRR.no_of_runs,0) as varchar) END
				FROM Acq_Deal_Movie DM 				
				INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_code = DM.Acq_Deal_code
				INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				WHERE DM.Acq_Deal_movie_code = @DMCode
				AND (DMRR.run_definition_type = 'S' OR DMRR.run_definition_type = 'N')
				AND DMRRC.channel_code = @ChannelCode
			END
			ELSE IF(@ResultFlag = 'Balance_Runs')
			BEGIN
				SELECT DISTINCT              
				@Result = CASE WHEN DMRR.run_type = 'U' Then 'Unlimited' 
					ELSE CAST(ISNULL(DMRR.no_of_runs,0) - (ISNULL(DMRR.no_of_runs_sched,0) + ISNULL(DMRR.no_of_AsRuns,0)) as varchar) END
				FROM Acq_Deal_Movie DM 				
				INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_Code = DM.Acq_Deal_Code
				INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				WHERE DM.Acq_Deal_movie_code = @DMCode
				AND (DMRR.run_definition_type = 'S' OR DMRR.run_definition_type = 'N')
				AND DMRRC.channel_code = @ChannelCode
				AND DMRR.run_definition_group_code = @RunDefinitionGrpCode
				--SET @Result = 'DADA'
			END
			ELSE IF(@ResultFlag = 'ColorCodes')
			BEGIN
				INSERT INTO @RunDefinitionGrpCode_Tbl (RDGrpCode, DMR_IsGroupCode)
				SELECT DISTINCT DMRR.run_definition_group_code, DMRR.Run_Definition_Group_Code
				FROM Acq_Deal_Run DMRR
				INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = DMRR.Acq_Deal_Code				
				Inner JOIN Acq_Deal_Rights ADR ON ADM.Acq_Deal_Code = AdR.Acq_Deal_Code				
				--INNER JOIN Acq_Deal_Movie_Rights DMR ON DMR.Acq_Deal_movie_rights_code = DMRR.Acq_Deal_movie_rights_code
				--INNER JOIN Acq_Deal_Movie DM ON DM.Acq_Deal_movie_code = DMR.Acq_Deal_movie_code
				WHERE 1=1
				AND ADM.Acq_Deal_movie_code = @DMCode
				ORDER BY DMRR.run_definition_group_code
				
				SELECT @Result = c.Color_RGB_Value 
				FROM @RunDefinitionGrpCode_Tbl r 
				INNER JOIN @ColorCodes c on c.ID = r.ID
				WHERE 1=1
				AND r.RDGrpCode = @RunDefinitionGrpCode
				AND r.DMR_IsGroupCode = @DMR_IsGroupCode
				
				---SELECT ID,RDGrpCode FROM #RunDefinitionGrpCode WHERE RDGrpCode = @RunDefinitionGrpCode
				------------------------------------------- END CREATE TEMP TABLES -------------------------------------------
			END
			
	END
		ELSE IF((@Run_defination_Type = 'C') OR (@Run_defination_Type = 'CS') OR (@Run_defination_Type = 'A'))
		BEGIN
			IF(@ResultFlag = 'NoOfRuns')
			BEGIN
				SELECT DISTINCT              
				@Result = CASE WHEN DMRR.run_type = 'U' Then 'Unlimited' ELSE CAST(ISNULL(DMRRC.min_runs,0) as varchar) END
				FROM Acq_Deal_Movie DM 
				--INNER JOIN Acq_Deal_Movie_Rights DMR on DMR.Acq_Deal_movie_code = DM.Acq_Deal_movie_code
				INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_Code = DM.Acq_Deal_Code
				INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code			
				LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				WHERE DM.Acq_Deal_movie_code = @DMCode
				AND DMRRC.channel_code = @ChannelCode
				AND (DMRR.run_definition_type = 'C' OR DMRR.run_definition_type = 'CS' OR DMRR.run_definition_type = 'A')
			END
			ELSE IF(@ResultFlag = 'Balance_Runs')
			BEGIN
				SELECT DISTINCT              
				@Result = CASE WHEN DMRR.run_type = 'U' Then 'Unlimited' 
					ELSE CAST(ISNULL(DMRRC.min_runs,0) - (ISNULL(DMRRC.no_of_runs_sched,0) + ISNULL(DMRRC.no_of_AsRuns,0)) as varchar) END
				FROM Acq_Deal_Movie DM 
				--INNER JOIN Acq_Deal_Movie_Rights DMR on DMR.Acq_Deal_movie_code = DM.Acq_Deal_movie_code
				--INNER JOIN Acq_Deal_Movie_Rights_Run DMRR on DMRR.Acq_Deal_movie_rights_code = DMR.Acq_Deal_movie_rights_code
				--LEFT JOIN Acq_Deal_Movie_Rights_Run_Channel DMRRC on DMRRC.Acq_Deal_movie_rights_run_code = DMRR.Acq_Deal_movie_rights_run_code
				INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_Code = DM.Acq_Deal_Code			
				INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code			
				LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
				WHERE DM.Acq_Deal_movie_code = @DMCode
				AND DMRRC.channel_code = @ChannelCode
				AND (DMRR.run_definition_type = 'C' OR DMRR.run_definition_type = 'CS' OR DMRR.run_definition_type = 'A')
			END
			ELSE IF(@ResultFlag = 'ColorCodes')
			BEGIN
				SET @Result ='No Color'
			END
		END
		--//----------------- End Get No OF Runs --//-----------------
		
		--//----------------- Get Provision Runs And Consume Runs --//-----------------
		IF(@ResultFlag = 'Provision_Runs')
		BEGIN
			SELECT DISTINCT              
			@Result = ISNULL(DMRRC.no_of_runs_sched,0)
			FROM Acq_Deal_Movie DM 
			INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_Code = DM.Acq_Deal_Code			
			INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
			LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
			WHERE DM.Acq_Deal_movie_code = @DMCode
			----AND DMRR.run_definition_type = 'S' 
			AND DMRRC.channel_code = @ChannelCode
		END
		ELSE IF(@ResultFlag = 'Consume_Runs')
		BEGIN
			SELECT DISTINCT              
			@Result = ISNULL(DMRRC.no_of_AsRuns,0)
			FROM Acq_Deal_Movie DM 
			INNER JOIN Acq_Deal_Run DMRR on DMRR.Acq_Deal_Code = DM.Acq_Deal_Code			
			INNER JOIN Acq_Deal_Run_Title DMRT on DM.Title_Code = DMRT.Title_Code AND DMRT.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
			LEFT JOIN Acq_Deal_Run_Channel DMRRC on DMRRC.Acq_Deal_Run_code = DMRR.Acq_Deal_Run_code
			WHERE DM.Acq_Deal_movie_code = @DMCode
			----AND DMRR.run_definition_type = 'S' 
			AND DMRRC.channel_code = @ChannelCode
		END
		--//----------------- End Get Provision Runs And Consume Runs --//-----------------
	
			--//----------------- End Get Provision Runs And Consume Runs --//-----------------
	
	END
	
	RETURN @Result
END

/*

select [dbo].[UFN_GetDataFor_ChannelWiseConsumption] (772,0,17,1,1,'S','ColorCodes','MOVIE')
*/