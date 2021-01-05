CREATE PROCEDURE [dbo].[usp_Schedule_Execute_Package_FolderWise]
(
	@UserCode VARCHAR(10)
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
		SELECT Channel_code, Schedule_Source_FilePath_Pkg FROM Channel WHERE ISNULL(isUseForAsRun,'N') = 'Y' 
		ORDER BY Order_For_schedule 

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
				PRINT '@UserCode : ' + @UserCode
				PRINT '@FilePath_Cr : ' + @FilePath_Cr
				PRINT '@ChannelCode_Cr : ' + @ChannelCode_Cr
				PRINT '@SuccessFilePath : ' + @SuccessFilePath
				PRINT '@NotSuccessFilePath : ' + @NotSuccessFilePath
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
		
		
		IF(  (SELECT ISNULL(Parameter_Value,'N') FROM System_Parameter_New WHERE Parameter_Name ='IS_Schedule_Mail_Channelwise')  = 'N' )
		BEGIN
			EXEC usp_Schedule_SendException_Userwise_Email 
		END
		
		      
END            
/*

Exec [usp_Schedule_Execute_Package_FolderWise] 143

*/
