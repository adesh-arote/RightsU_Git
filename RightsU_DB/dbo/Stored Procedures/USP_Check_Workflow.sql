CREATE PROC [dbo].[USP_Check_Workflow]
(
	@Module_Code INT, 
	@Record_Code INT
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Workflow]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		DECLARE @RetValue VARCHAR(1) = 'P', @BU_Code INT = 0, @Workflow_Code INT = 0
		IF(@Module_Code = 30)
			SELECT @BU_Code = Business_Unit_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @Record_Code
		ELSE IF(@Module_Code = 35)
			SELECT @BU_Code = Business_Unit_Code FROM Syn_Deal (NOLOCK) WHERE Syn_Deal_Code = @Record_Code
		ELSE IF(@Module_Code = 163)
			SELECT @BU_Code = Business_Unit_Code FROM Music_Deal (NOLOCK) WHERE Music_Deal_Code = @Record_Code

		SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module  (NOLOCK)
		WHERE Module_Code = @Module_Code AND (Business_Unit_Code = @BU_Code OR @BU_Code < 1)
		AND GETDATE() BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())

		IF(@Workflow_Code > 0)
		BEGIN
			IF((SELECT COUNT(*) FROM Workflow_Role (NOLOCK) WHERE Workflow_Code = @Workflow_Code) = 0)
				SET @RetValue = 'L'
			ELSE
				SET @RetValue = 'P'
		END
		ELSE
			SET @RetValue = 'W'

		SELECT @RetValue RetValue
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Check_Workflow]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
