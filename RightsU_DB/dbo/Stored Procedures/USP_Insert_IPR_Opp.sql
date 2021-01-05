CREATE PROCEDURE [dbo].[USP_Insert_IPR_Opp]
(	
	@IPR_Rep_Code	INT,
	@IPR_Class_Code	INT,
	@IPR_App_Status_Code	INT,
	@Created_By	INT,
	@Publication_Date	DATETIME,
	@Date_Counter_Statement	DATETIME,
	@Date_Evidence_UR50	DATETIME,
	@Date_Evidence_UR51	DATETIME,
	@Date_Opposition_Notice	DATETIME,
	@Date_Rebuttal_UR52	DATETIME,
	@Creation_Date	DATETIME,
	@Deadline_Counter_Statement	DATETIME,
	@Deadline_Evidence_UR50	DATETIME,
	@Deadline_Evidence_UR51	DATETIME,
	@Deadline_Opposition_Notice	DATETIME,
	@Deadline_Rebuttal_UR52	DATETIME,
	@Order_Date	DATETIME,
	@Version	VARCHAR(20),
	@Opp_No	NVARCHAR(100),
	@Party_Name	NVARCHAR(500),
	@Trademark	NVARCHAR(50),
	@Application_No	NVARCHAR(50),
	@Journal_No	NVARCHAR(100),
	@Page_No	VARCHAR(50),
	@Outcomes	NVARCHAR(1000),
	@Comments	NVARCHAR(1000),
	@IPR_For	CHAR(1),
	@Workflow_Status VARCHAR(50),
	@IPR_Opp_Status_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 19 AUG 2015
-- Description:	Insert IPR_Opp Data Calling From EF
-- =============================================
BEGIN	
	SET NOCOUNT ON;
	SET FMTONLY OFF;

	INSERT INTO IPR_Opp
	( 
		Version, 
		IPR_For, 
		Opp_No, 
		IPR_Rep_Code, 
		Party_Name, 
		Trademark, 
		Application_No, 
		IPR_Class_Code, 
		IPR_App_Status_Code, 
		Journal_No, 
		Publication_Date, 
		Page_No, 
		Date_Counter_Statement, 
		Date_Evidence_UR50, 
		Date_Evidence_UR51, 
		Date_Opposition_Notice, 
		Date_Rebuttal_UR52, 
		Deadline_Counter_Statement, 
		Deadline_Evidence_UR50, 
		Deadline_Evidence_UR51, 
		Deadline_Opposition_Notice, 
		Deadline_Rebuttal_UR52, 
		Order_Date, 
		Outcomes, 
		Workflow_Status,
		Comments, 
		Creation_Date, 
		Created_By,
		IPR_Opp_Status_Code
	)
	Select   
	@Version, 
	@IPR_For, 
	@Opp_No, 
	@IPR_Rep_Code, 
	@Party_Name, 
	@Trademark, 
	@Application_No, 
	@IPR_Class_Code, 
	@IPR_App_Status_Code, 
	@Journal_No, 
	@Publication_Date, 
	@Page_No, 
	@Date_Counter_Statement, 
	@Date_Evidence_UR50, 
	@Date_Evidence_UR51, 
	@Date_Opposition_Notice, 
	@Date_Rebuttal_UR52, 
	@Deadline_Counter_Statement, 
	@Deadline_Evidence_UR50, 
	@Deadline_Evidence_UR51, 
	@Deadline_Opposition_Notice, 
	@Deadline_Rebuttal_UR52, 
	@Order_Date, 
	@Outcomes, 
	@Workflow_Status,
	@Comments, 
	@Creation_Date, 
	@Created_By,
	@IPR_Opp_Status_Code

	Declare @IPR_Opp_Code INT
	SELECT @IPR_Opp_Code = IPR_Opp_Code
	FROM IPR_Opp WHERE IPR_Opp_Code = SCOPE_IDENTITY()
		
	IF(@Workflow_Status = 'A')
	BEGIN
		INSERT INTO IPR_Opp_Status_History(IPR_Opp_Code,IPR_Status,Changed_On,Changed_By)
		VALUES(@IPR_Opp_Code,'N',GETDATE(),@Created_By)
	END

	INSERT INTO IPR_Opp_Status_History(IPR_Opp_Code,IPR_Status,Changed_On,Changed_By)
	VALUES(@IPR_Opp_Code,@Workflow_Status,GETDATE(),@Created_By)
		
	Select @IPR_Opp_Code IPR_Opp_Code
END
