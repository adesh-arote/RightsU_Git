CREATE PROCEDURE [dbo].[USP_Edit_Without_Approval]
(
--Declare
	@Acq_Deal_Code INT,
	@Mode VARCHAR(3),
	@User_Code INT,
	@Remarks VARCHAR(MAX)=''
)
AS
-- =============================================
-- Author:	Anchal Sikarwar
-- Create DATE: 2-AUG-2016
-- Description:Edit Without Approval	
-- Updated by :
-- Date :
-- Reason:
-- =============================================
BEGIN
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Edit_Without_Approval]', 'Step 1', 0, 'Started Procedure', 0, '' 
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
		DECLARE @Version float ,@Rem VARCHAR(500)
		SELECT TOP 1 @Version=[Version] FROM Acq_Deal_Tab_Version (NOLOCK) WHERE Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC
		DECLARE @CurrIdent_AT_Acq_Deal INT
		SET @CurrIdent_AT_Acq_Deal = 0

		IF(@Mode='EWA')
		BEGIN
			SET @Version=@Version+0.1
			set @Rem='Edit without Approval (V '+CONVERT(VARCHAR(50),@Version)+')'

			IF(NOT EXISTS(SELECT * FROM Acq_Deal (NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND  Acq_Deal_Code=@Acq_Deal_Code AND Deal_Workflow_Status='EO'))
			BEGIN
				INSERT INTO Acq_Deal_Tab_Version([Version],Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
				VALUES(@Version,@Remarks,@Acq_Deal_Code,GETDATE(),@User_Code,GETDATE(),@User_Code)

				INSERT INTO Module_Status_History(Module_Code,Record_Code,Remarks,[Status],Status_Changed_By,Status_Changed_On)
				VALUES(30,@Acq_Deal_Code,@Rem,'EO',@User_Code,GETDATE())

				UPDATE Acq_Deal SET Deal_Workflow_Status='EO',Last_Updated_Time=GETDATE() WHERE Acq_Deal_Code=@Acq_Deal_Code
			END
		END

		IF(@Mode='SAV' OR @Mode='BAK')
		BEGIN
			IF(EXISTS(SELECT * FROM Acq_Deal (NOLOCK) WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND  Acq_Deal_Code=@Acq_Deal_Code AND Deal_Workflow_Status='EO'))
			BEGIN
				UPDATE Acq_Deal_Tab_Version SET Remarks=@Remarks WHERE Acq_Deal_Tab_Version_Code IN(SELECT TOP 1 Acq_Deal_Tab_Version_Code FROM Acq_Deal_Tab_Version (NOLOCK)
				 WHERE Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC)
			END
		END

		IF(@Mode='COM')
		BEGIN
		--SET @Version=@Version+0.1
		--	INSERT INTO Acq_Deal_Tab_Version([Version],Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
		--	VALUES(@Version,@Remarks,@Acq_Deal_Code,GETDATE(),@User_Code,GETDATE(),@User_Code)
			UPDATE Acq_Deal_Tab_Version SET Remarks='' WHERE Acq_Deal_Tab_Version_Code IN(SELECT TOP 1 Acq_Deal_Tab_Version_Code FROM Acq_Deal_Tab_Version (NOLOCK)
			WHERE Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC)

			INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
						VALUES (@Acq_Deal_Code, 30, 'Y', 'A', GETDATE(), NULL, NULL, @User_Code)
			--EXEC [dbo].[USP_AT_Acq_Deal] @Acq_Deal_Code,'','Y'

			UPDATE Acq_Deal SET Deal_Workflow_Status='A',Last_Updated_Time=GETDATE() WHERE Acq_Deal_Code=@Acq_Deal_Code

			INSERT INTO Module_Status_History(Module_Code,Record_Code,Remarks,[Status],Status_Changed_By,Status_Changed_On)
			VALUES(30,@Acq_Deal_Code,@Remarks,'A',@User_Code,GETDATE())

		END

		IF(@Mode='ROL')
		BEGIN 
			--EXEC [dbo].[USP_RollBack_Acq_Deal] @Acq_Deal_Code,@User_Code,'Y'
 
			INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
			VALUES (@Acq_Deal_Code, 30, 'Y', 'R', GETDATE(), NULL, NULL, @User_Code)

			UPDATE Acq_Deal SET Deal_Workflow_Status='A',Last_Updated_Time=GETDATE() WHERE Acq_Deal_Code=@Acq_Deal_Code
			/* Delete from  Acq_Deal_Tab_Version */
			DELETE FROM Acq_Deal_Tab_Version WHERE Acq_Deal_Tab_Version_Code 
			IN(SELECT TOP 1 Acq_Deal_Tab_Version_Code FROM Acq_Deal_Tab_Version (NOLOCK) WHERE Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC)
				
			DELETE FROM Module_Status_History WHERE Module_Status_Code IN(SELECT TOP 1 Module_Status_Code FROM Module_Status_History (NOLOCK) WHERE Record_Code=@Acq_Deal_Code 
			AND [Status]='EO' ORDER BY Module_Status_Code DESC)
		END

	 --Set @Is_Error = 'N'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Edit_Without_Approval]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END