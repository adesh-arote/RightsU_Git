CREATE PROCEDURE [dbo].[usp_Schedule_Execute_Package_FolderWise]
(
	@UserCode VARCHAR(10) = NULL
)
AS      
BEGIN      
-- =============================================
/*
Note:- System Configuration for first time to execute SSIS Package
		on SQL Server.
	---- To allow advanced options to be changed.      
	--EXEC sp_configure 'show advanced options', 1      
	--GO      
	---- To update the currently configured value for advanced options.      
	--RECONFIGURE      
	--GO      
	---- To enable the feature.      
	--EXEC sp_configure 'xp_cmdshell', 1      
	--GO      
	---- To update the currently configured value for this feature.      
	--RECONFIGURE      
	--GO
*/      

/*
------------- Package Execution Status Code-------------
--http://www.bidn.com/blogs/BradSchacht/ssis/941/capture-ssis-package-execution-status
0  The package executed successfully.
1  The package failed.
3  The package was canceled by the user.
4  The utility was unable to locate the requested package. The package could not be found.
5  The utility was unable to load the requested package. The package could not be loaded.
6  The utility encountered an internal error of syntactic or semantic errors in the command line.
*/

/*
Steps:-
	1.0 To execute the Schedule SSIS Package from stored procedure through Auto Scheduler.
*/
-- =============================================
    	
		IF (@UserCode  IS NULL)
		SET @UserCode = 0
	      
		DECLARE @cmd    VARCHAR(2000)      
		DECLARE @PackagePath VARCHAR(2000)
		DECLARE @NotSuccessFilePath VARCHAR(8000);	SET @NotSuccessFilePath = ''
		DECLARE @SuccessFilePath VARCHAR(8000);	SET @SuccessFilePath = ''
		DECLARE @ChannelCode_Cr VARCHAR(20) 
		DECLARE @FilePath_Cr VARCHAR(8000) 
		
		DECLARE Cur_Channel CURSOR       
		FOR   
		SELECT Channel_code, Schedule_Source_FilePath_Pkg FROM Channel where ISNULL(isUseForAsRun,'N') = 'Y' order by Order_For_schedule 

		OPEN Cur_Channel  
		FETCH NEXT FROM Cur_Channel INTO @ChannelCode_Cr, @FilePath_Cr
		WHILE @@FETCH_STATUS<>-1 
		BEGIN                                              
			IF(@@FETCH_STATUS<>-2)                                              
			BEGIN
				SET @SuccessFilePath = @FilePath_Cr + '\Success'
				SET @NotSuccessFilePath = @FilePath_Cr + '\NotSuccess'			
				
				SELECT @PackagePath =     parameter_value FROM system_parameter_new WHERE parameter_name = 'BV_Schedule_Pkg_FolderWise'
				--cd "C:\Program Files\Microsoft SQL Server\100\DTS\Binn\" DTEXEC.exe /F "E:\UTOAMS_Schedule_AsRun\UTOAMS_SSIS_Packages\BV_Schedule_Pkg_FolderWise_neo.dtsx" /De prathesh


				
				PRINT  @PackagePath
				

				--Pass a parameter to SSIS package
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::UserCode].Properties[Value]";' + @UserCode + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::InputFile].Properties[Value]";' + @FilePath_Cr + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::ChannelCode].Properties[Value]";' + @ChannelCode_Cr + '"' 
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::SuccessFilePath].Properties[Value]";' + @SuccessFilePath + '"'
				SET @PackagePath = @PackagePath + ' /SET \package.Variables[User::NotSucessFilePath].Properties[Value]";' + @NotSuccessFilePath + '"'
				
				--End Pass a parameter to SSIS package
				
				PRINT  @PackagePath 
				PRINT  @ChannelCode_Cr 
				SET @cmd = @PackagePath      
				 
				
				EXEC MASTER..xp_cmdshell @cmd
				
				------------EXEC MASTER ..xp_cmdshell 	'dtexec /F "C:\inetpub\wwwroot\UTO_AMS_VIACOM_Dada\Package\BV_Schedule_Pkg_FolderWise.dtsx" /De prathesh'
			END
			FETCH NEXT FROM Cur_Channel INTO @ChannelCode_Cr, @FilePath_Cr
		END                                           
		CLOSE Cur_Channel                                               
		DEALLOCATE Cur_Channel   
		
		BEGIN --------------------- MUSIC SCHEDULE PROCESS START

			CREATE TABLE #DELMusicSchCodes
			(
				Music_Schedule_Transaction_Code INT,	
			)

			CREATE TABLE #TempSchedule
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT,
				Music_Title_Code INT,
				Title_Code INT,
				Program_Episode_Number VARCHAR(100),
				Channel_Code INT
			)

			CREATE TABLE #CMLCode
			(
				BV_Schedule_Transaction_Code INT,
				Content_Music_Link_Code INT
			)
			
			CREATE TABLE #ProcessingBVSchCodes
			(
				BV_Schedule_Transaction_Code INT,	
			)

			INSERT INTO #DELMusicSchCodes(Music_Schedule_Transaction_Code)
			SELECT Music_Schedule_Transaction_Code FROM Music_Schedule_Transaction WHERE BV_Schedule_Transaction_Code NOT IN (
				SELECT BV_Schedule_Transaction_Code FROM BV_Schedule_Transaction
			)

			DELETE FROM Music_Schedule_Exception WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)
	
			DELETE FROM Music_Schedule_Transaction WHERE Music_Schedule_Transaction_Code IN (
				SELECT Music_Schedule_Transaction_Code FROM #DELMusicSchCodes
			)

			INSERT INTO #TempSchedule(BV_Schedule_Transaction_Code, Content_Music_Link_Code, Title_Code, Program_Episode_Number, Channel_Code, Music_Title_Code)
			SELECT DISTINCT BV_Schedule_Transaction_Code, cml.Content_Music_Link_Code, tc.Title_Code, bst.Program_Episode_Number AS Program_Episode_Number, Channel_Code, Music_Title_Code
			FROM Title_Content tc
			INNER JOIN Content_Music_Link cml ON cml.Title_Content_Code = tc.Title_Content_Code
			INNER JOIN BV_Schedule_Transaction bst ON tc.Ref_BMS_Content_Code = bst.Program_Episode_ID
			--WHERE tc.Title_Code = 27522

			INSERT INTO #CMLCode(Content_Music_Link_Code, BV_Schedule_Transaction_Code)
			SELECT DISTINCT mct.Content_Music_Link_Code, mct.BV_Schedule_Transaction_Code FROM Music_Schedule_Transaction mct
			INNER JOIN (SELECT DISTINCT BV_Schedule_Transaction_Code FROM #TempSchedule) sch ON mct.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code

			INSERT INTO #ProcessingBVSchCodes(BV_Schedule_Transaction_Code)
			SELECT DISTINCT sch.BV_Schedule_Transaction_Code
			FROM #TempSchedule sch
			INNER JOIN VW_Music_Track_Label mtl ON mtl.Music_Title_Code = sch.Music_Title_Code AND GETDATE() > mtl.Effective_From
			WHERE sch.Content_Music_Link_Code NOT IN (
				SELECT cml.Content_Music_Link_Code FROM #CMLCode cml WHERE cml.BV_Schedule_Transaction_Code = sch.BV_Schedule_Transaction_Code
			)

			
			DECLARE @MusicScheduleProcess MusicScheduleProcess

			WHILE ((SELECT COUNT(*) FROM #ProcessingBVSchCodes) > 0)
			BEGIN

				INSERT INTO @MusicScheduleProcess(BV_Schedule_Transaction_Code)
				SELECT DISTINCT TOP 1000 BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes

				EXEC [dbo].[USP_Music_Schedule_Process_Neo] @MusicScheduleProcess, 'SP'

				DELETE FROM #ProcessingBVSchCodes WHERE BV_Schedule_Transaction_Code IN (
					SELECT BV_Schedule_Transaction_Code FROM @MusicScheduleProcess
				)

				DELETE FROM @MusicScheduleProcess

			END

			--DECLARE @BV_Schedule_Transaction_Code INT = 0

			--DECLARE CUR_BVMusicProcess CURSOR FOR SELECT BV_Schedule_Transaction_Code FROM #ProcessingBVSchCodes
			--OPEN CUR_BVMusicProcess  
			--FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--WHILE @@FETCH_STATUS<>-1 
			--BEGIN                                              
			--	IF(@@FETCH_STATUS<>-2)                                              
			--	BEGIN

			--		INSERT INTO MusicScheduleLog VALUES(@BV_Schedule_Transaction_Code, GETDATE())

			--		PRINT 'START USP_Music_Schedule_Process'

			--		EXEC USP_Music_Schedule_Process
			--		@TitleCode = 0, 
			--		@EpisodeNo = 0, 
			--		@BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code, 
			--		@MusicScheduleTransactionCode = 0,
			--		@CallFrom= 'SP'

			--		PRINT 'END USP_Music_Schedule_Process'
		
			--	END
			--	FETCH NEXT FROM CUR_BVMusicProcess INTO @BV_Schedule_Transaction_Code
			--END                                           
			--CLOSE CUR_BVMusicProcess                                               
			--DEALLOCATE CUR_BVMusicProcess  
			
			IF(OBJECT_ID('TEMPDB..#DELMusicSchCodes') IS NOT NULL) DROP TABLE #DELMusicSchCodes
			IF(OBJECT_ID('TEMPDB..#TempSchedule') IS NOT NULL) DROP TABLE #TempSchedule
			IF(OBJECT_ID('TEMPDB..#CMLCode') IS NOT NULL) DROP TABLE #CMLCode
			IF(OBJECT_ID('TEMPDB..#ProcessingBVSchCodes') IS NOT NULL) DROP TABLE #ProcessingBVSchCodes

		END

		if(  (select isnull(Parameter_Value,'N') from System_Parameter_New where Parameter_Name ='IS_Schedule_Mail_Channelwise')  = 'N' )
		BEGIN
			EXEC usp_Schedule_SendException_Userwise_Email
		END

END            
/*
EXEC xp_cmdshell
Exec [usp_Schedule_Execute_Package_FolderWise] 143

*/


--cd "C:\Program Files\Microsoft SQL Server\100\DTS\Binn\" DTEXEC.exe /F "E:\UTOAMS_Schedule_AsRun\UTOAMS_SSIS_Packages\BV_Schedule_Pkg_FolderWise_neo.dtsx" /De prathesh
