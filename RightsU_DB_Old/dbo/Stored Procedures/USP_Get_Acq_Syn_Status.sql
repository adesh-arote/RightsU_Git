CREATE PROCEDURE USP_Get_Acq_Syn_Status  
(  
 @Deal_Code INT,  
 @Type CHAR(1),
 @UserCode INT  
)  
AS  
/*==============================================  
Author:   Akshay R Rane  
Create date: 14 Feb, 2017  
===============================================*/  
BEGIN  
	DECLARE @Action CHAR(1) = '', @Pre_Deal_Code INT = 0 , @Deal_Workflow_Status  CHAR(2) = ''
	IF(@Type = 'A')
	BEGIN
		SELECT TOP 1 @Action = dp.Action , @Pre_Deal_Code = dp.Deal_Code 
		FROM Deal_Process dp 
		WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 30 ORDER BY  dp.Deal_Process_Code DESC		

		IF(@Action = 'R')
		BEGIN
			SELECT @Deal_Workflow_Status = AD.Deal_Workflow_Status FROM Acq_Deal AD WHERE AD.Acq_Deal_Code =  @Pre_Deal_Code 
			SELECT TOP 1 dp.Record_Status , dp.Version_No ,
				dbo.[UFN_DEAL_SET_BUTTON_VISIBILITY](@Pre_Deal_Code,  CAST(dp.Version_No AS float) , CAST(@UserCode AS VARCHAR(50)) , @Deal_Workflow_Status) AS 'Button_Visibility'
			FROM Deal_Process dp 
			WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 30 ORDER BY  dp.Deal_Process_Code DESC
		END
		ELSE
		BEGIN
			SELECT TOP 1 dp.Record_Status , dp.Version_No , '' AS  'Button_Visibility'
			FROM Deal_Process dp 
			WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 30 ORDER BY  dp.Deal_Process_Code DESC
		END
	END
	ELSE IF(@Type = 'S')
	BEGIN
		SELECT TOP 1 @Action = dp.Action , @Pre_Deal_Code = dp.Deal_Code 
		FROM Deal_Process dp 
		WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 35 ORDER BY  dp.Deal_Process_Code DESC		

		IF(@Action = 'R')
		BEGIN
			SELECT @Deal_Workflow_Status = SD.Deal_Workflow_Status FROM Syn_Deal SD WHERE SD.Syn_Deal_Code =  @Pre_Deal_Code 
			SELECT TOP 1 dp.Record_Status , dp.Version_No ,
				dbo.[UFN_Syn_DEAL_SET_BUTTON_VISIBILITY](@Pre_Deal_Code,  CAST(dp.Version_No AS float) , CAST(@UserCode AS VARCHAR(50)) , @Deal_Workflow_Status) AS 'Button_Visibility'
			FROM Deal_Process dp 
			WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 35 ORDER BY  dp.Deal_Process_Code DESC
		END
		ELSE
		BEGIN
			SELECT TOP 1 dp.Record_Status , dp.Version_No , '' AS  'Button_Visibility'
			FROM Deal_Process dp 
			WHERE dp.Deal_Code = @Deal_Code AND dp.Module_Code = 35 ORDER BY  dp.Deal_Process_Code DESC
		END
	END
END

