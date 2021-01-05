CREATE PROCEDURE [dbo].[USP_Update_IPR_Opp]
(
	@IPR_Opp_Code	INT,
	@IPR_Rep_Code	INT,
	@IPR_Class_Code	INT,
	@IPR_App_Status_Code	INT,
	@Publication_Date	DATETIME,
	@Date_Counter_Statement	DATETIME,
	@Date_Evidence_UR50	DATETIME,
	@Date_Evidence_UR51	DATETIME,
	@Date_Opposition_Notice	DATETIME,
	@Date_Rebuttal_UR52	DATETIME,
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
	@IPR_Opp_Status_Code INT,
	@Created_By	INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 19 Aug 2015
-- Description:	Update IPR_Opp Data Calling From EF
-- =============================================

BEGIN	
	SET NOCOUNT ON;
	UPDATE IPR_Opp SET 
	[Version] = @Version, 
	IPR_For = @IPR_For, 
	Opp_No = @Opp_No, 
	IPR_Rep_Code = @IPR_Rep_Code, 
	Party_Name = @Party_Name, 
	Trademark = @Trademark, 
	Application_No = @Application_No, 
	IPR_Class_Code = @IPR_Class_Code, 
	IPR_App_Status_Code = @IPR_App_Status_Code, 
	Journal_No = @Journal_No, 
	Publication_Date = @Publication_Date, 
	Page_No = @Page_No, 
	Date_Counter_Statement = @Date_Counter_Statement, 
	Date_Evidence_UR50 = @Date_Evidence_UR50, 
	Date_Evidence_UR51 = @Date_Evidence_UR51, 
	Date_Opposition_Notice = @Date_Opposition_Notice, 
	Date_Rebuttal_UR52 = @Date_Rebuttal_UR52, 
	Deadline_Counter_Statement = @Deadline_Counter_Statement, 
	Deadline_Evidence_UR50 = @Deadline_Evidence_UR50, 
	Deadline_Evidence_UR51 = @Deadline_Evidence_UR51, 
	Deadline_Opposition_Notice = @Deadline_Opposition_Notice, 
	Deadline_Rebuttal_UR52 = @Deadline_Rebuttal_UR52, 
	Order_Date = @Order_Date, 
	Outcomes = @Outcomes, 
	Comments = @Comments, 
	Workflow_Status = @Workflow_Status,
	IPR_Opp_Status_Code = @IPR_Opp_Status_Code,
	Created_By=@Created_By
	Where IPR_Opp_Code = @IPR_Opp_Code			
	
	
	INSERT INTO IPR_Opp_Status_History(IPR_Opp_Code,IPR_Status,Changed_On,Changed_By)
	VALUES(@IPR_Opp_Code,@Workflow_Status,GETDATE(),@Created_By)
END
