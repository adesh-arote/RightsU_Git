CREATE PROCEDURE [dbo].[USP_UPDATE_IPR_REP]
(
	@IPR_Rep_Code INT,			
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
	@Created_By	INT,
	@Version	VARCHAR(20),
	@Workflow_Status	VARCHAR(50),
	@Class_Comments	 NVARCHAR(1000),
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
-- Description:	Update IPR Data Call From EF
-- =============================================

BEGIN	
	SET NOCOUNT ON;
		UPDATE IPR_REP SET 
		IPR_Type_Code =@IPR_Type_Code ,
		Application_No = @Application_No,
		Application_Date=@Application_Date,
		Country_Code=@Country_Code,
		Proposed_Or_Date=@Proposed_Or_Date,
		Date_Of_Use=@Date_Of_Use,
		Application_Status_Code=@Application_Status_Code,
		Renewed_Until=@Renewed_Until,
		Applicant_Code=@Applicant_Code,
		Trademark_Attorney=@Trademark_Attorney,
		Trademark = @Trademark,
		Comments=@Comments,		
		Created_By=@Created_By,
		[Version]=@Version,
		Workflow_Status=@Workflow_Status,
		Class_Comments=@Class_Comments,
		Date_Of_Actual_Use=@Date_Of_Actual_Use,
		International_Trademark_Attorney=@International_Trademark_Attorney,
		Date_Of_Registration=@Date_Of_Registration,
		Registration_No=@Registration_No,
		IPR_For = @IPR_For
		Where IPR_Rep_Code = @IPR_Rep_Code			
		
		INSERT INTO IPR_REP_STATUS_HISTORY(IPR_Rep_Code,IPR_Status,Changed_On,Changed_By)
		VALUES(@IPR_Rep_Code,@Workflow_Status,GETDATE(),@Created_By)
END