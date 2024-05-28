﻿CREATE PROCEDURE [dbo].[USP_Bind_Title]
(
	@Deal_Code INT,
	@Deal_Type_Code INT,
	@Deal_Type CHAR(1) = 'A' --Acq OR Syn
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 4 June 2015
-- Description:	Bind Title Dropdown List
-- =============================================
BEGIN	
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Bind_Title]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
		DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)
		IF(@Deal_Type = 'A')
		BEGIN
			IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')
			BEGIN
				SELECT ADM.Acq_Deal_Movie_Code AS Title_Code,
				dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_Starts_From, ADM.Episode_End_To) AS Title_Name
				FROM Acq_Deal_Movie ADM (NOLOCK)
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
				WHERE ADM.Acq_Deal_Code = @Deal_Code
		
			END
			ELSE
			BEGIN
				PRINT 'Movie'
				SELECT ADM.Title_Code,T.Title_Name 
				FROM Acq_Deal_Movie ADM (NOLOCK)
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
				WHERE ADM.Acq_Deal_Code = @Deal_Code
			END
		END
		ELSE
		BEGIN
			IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC')
			BEGIN
				PRINT 'Program'
				SELECT ADM.Syn_Deal_Movie_Code AS Title_Code,
				dbo.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADM.Episode_From, ADM.Episode_End_To) AS Title_Name
				FROM Syn_Deal_Movie ADM (NOLOCK)
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
				WHERE ADM.Syn_Deal_Code = @Deal_Code
		
			END
			ELSE
			BEGIN
				PRINT 'Movie'
				SELECT ADM.Title_Code,T.Title_Name 
				FROM Syn_Deal_Movie ADM (NOLOCK)
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADM.Title_Code
				WHERE ADM.Syn_Deal_Code = @Deal_Code
			END
		END

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Bind_Title]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
