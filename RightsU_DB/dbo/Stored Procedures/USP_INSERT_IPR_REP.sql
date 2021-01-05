CREATE PROCEDURE [dbo].[USP_INSERT_IPR_REP]
(	
	@IPR_Type_Code INT,
	@Application_No NVARCHAR(50),
	@Application_Date DateTime,
	@Country_Code INT,
	@Proposed_Or_Date char,
	@Date_Of_Use	DateTime,
	@Application_Status_Code	INT,
	@Renewed_Until DateTime,
	@Applicant_Code INT,
	@Trademark_Attorney NVARCHAR(100),
	@Trademark NVARCHAR(100),
	@Comments NVARCHAR(1000),	     
	@Creation_Date DateTime,
	@Created_By	INT,
	@Version	VARCHAR(20),
	@Workflow_Status	VARCHAR(50),
	@Class_Comments	 NVARCHAR(2000),
	@Date_Of_Actual_Use DATETIME,
	@International_Trademark_Attorney NVARCHAR(MAX),
	@Date_Of_Registration DATETIME,
	@Registration_No NVARCHAR(200),
	@IPR_For CHAR(1)
)
AS
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 31 OCT 2014
-- Description:	Insert IPR Data Call From EF
-- =============================================

BEGIN	
	SET NOCOUNT ON;
	INSERT INTO IPR_REP
	(
		Trademark_No,
		IPR_Type_Code,
		Application_No,
		Application_Date,
		Country_Code,
		Proposed_Or_Date,
		Date_Of_Use,
		Application_Status_Code,
		Renewed_Until,
		Applicant_Code,
		Trademark_Attorney,
		Trademark,
		Comments,
		Creation_Date,
		Created_By,
		[Version],
		Workflow_Status,
		Class_Comments,
		Date_Of_Actual_Use,
		International_Trademark_Attorney,
		Date_Of_Registration,
		Registration_No,
		IPR_For
	)
		Select  [dbo].[UFN_IPR_Auto_Genrate_Trademark_No]() as Trademark_No,
		@IPR_Type_Code,
		@Application_No,
		@Application_Date,
		@Country_Code,
		@Proposed_Or_Date,
		@Date_Of_Use,
		@Application_Status_Code,
		@Renewed_Until,
		@Applicant_Code,
		@Trademark_Attorney,
		@Trademark,
		@Comments,
		@Creation_Date,
		@Created_By,
		@Version,
		@Workflow_Status,
		@Class_Comments,
		@Date_Of_Actual_Use,
		@International_Trademark_Attorney,
		@Date_Of_Registration,
		@Registration_No,
		@IPR_For

		Declare @IPR_Rep_Code INT,@Trademark_No Varchar(100)
		SELECT @IPR_Rep_Code = IPR_REP_Code,@Trademark_No=Trademark_No
		FROM IPR_REP WHERE IPR_Rep_Code=SCOPE_IDENTITY()
		
		IF(@Workflow_Status = 'A')
		BEGIN
			INSERT INTO IPR_REP_STATUS_HISTORY(IPR_Rep_Code,IPR_Status,Changed_On,Changed_By)
			VALUES(@IPR_Rep_Code,'N',GETDATE(),@Created_By)
		END

		INSERT INTO IPR_REP_STATUS_HISTORY(IPR_Rep_Code,IPR_Status,Changed_On,Changed_By)
		VALUES(@IPR_Rep_Code,@Workflow_Status,GETDATE(),@Created_By)
		
		Select @IPR_Rep_Code IPR_Rep_Code,@Trademark_No Trademark_No
END
