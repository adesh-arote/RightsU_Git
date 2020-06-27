CREATE TABLE [dbo].[Syn_Deal_Rights] (
    [Syn_Deal_Rights_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]           INT             NOT NULL,
    [Is_Exclusive]            CHAR (1)        NULL,
    [Is_Title_Language_Right] CHAR (1)        NULL,
    [Is_Sub_License]          CHAR (1)        NULL,
    [Sub_License_Code]        INT             NULL,
    [Is_Theatrical_Right]     CHAR (1)        NULL,
    [Right_Type]              CHAR (1)        NULL,
    [Is_Tentative]            CHAR (1)        NULL,
    [Term]                    VARCHAR (12)    NULL,
    [Right_Start_Date]        DATETIME        NULL,
    [Right_End_Date]          DATETIME        NULL,
    [Milestone_Type_Code]     INT             NULL,
    [Milestone_No_Of_Unit]    INT             NULL,
    [Milestone_Unit_Type]     INT             NULL,
    [Is_ROFR]                 CHAR (1)        NULL,
    [ROFR_Date]               DATETIME        NULL,
    [Restriction_Remarks]     NVARCHAR (4000) NULL,
    [Effective_Start_Date]    DATETIME        NULL,
    [Actual_Right_Start_Date] DATETIME        NULL,
    [Actual_Right_End_Date]   DATETIME        NULL,
    [Is_Pushback]             CHAR (1)        NULL,
    [ROFR_Code]               INT             NULL,
    [Inserted_By]             INT             NULL,
    [Inserted_On]             DATETIME        NULL,
    [Last_Updated_Time]       DATETIME        NULL,
    [Last_Action_By]          INT             NULL,
    [Right_Status]            CHAR (1)        NULL,
    [Is_Verified]             CHAR (1)        NULL,
    [Original_Right_Type]     CHAR (1)        NULL,
    [Promoter_Flag]           CHAR (1)        NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Code] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Rights_Milestone_Type] FOREIGN KEY ([Milestone_Type_Code]) REFERENCES [dbo].[Milestone_Type] ([Milestone_Type_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_ROFR] FOREIGN KEY ([ROFR_Code]) REFERENCES [dbo].[ROFR] ([ROFR_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_Sub_License] FOREIGN KEY ([Sub_License_Code]) REFERENCES [dbo].[Sub_License] ([Sub_License_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);








GO
-- =============================================
-- Author:		Adesh Arote
-- Create date: 26-Feb-2015
-- Description:	Insert Records in Syn_Deal_Rights_Process_Validation table for validation purpose
-- =============================================
CREATE TRIGGER [dbo].[TRG_Syn_Deal_Rights_Validation]
   ON  dbo.Syn_Deal_Rights
   AFTER INSERT, UPDATE
AS 
BEGIN
	Insert InTo Syn_Deal_Rights_Process_Validation(Syn_Deal_Rights_Code,[Status])
	Select Syn_Deal_Rights_Code, 'P' From Inserted i Inner Join Syn_Deal sd On i.Syn_Deal_Code = sd.Syn_Deal_Code And sd.Deal_Workflow_Status <> 'A' And Right_Status = 'P'

	DELETE SRC FROM Syn_Rights_Code SRC WHERE SRC.Syn_Deal_Rights_Code IN
	(
		SELECT I.Syn_Deal_Rights_Code
		FROM INSERTED I	
	)
	INSERT INTO Syn_Rights_Code(Syn_Deal_Code,Syn_Deal_Rights_Code,[Action],Created_On)
	SELECT DISTINCT U.Syn_Deal_Code,U.Syn_Deal_Rights_Code,'I',GETDATE()
	FROM INSERTED U 
	--WHERE U.Right_Status = 'P'
END

GO
CREATE TRIGGER [dbo].[Trg_Syn_Deal_Rights_DEL]      
ON dbo.Syn_Deal_Rights        
AFTER DELETE 
AS    
SET NOCOUNT ON;
BEGIN 
	DELETE SRC FROM Syn_Rights_Code SRC WHERE SRC.Syn_Deal_Rights_Code IN
	(
		SELECT D.Syn_Deal_Rights_Code
		FROM DELETED D	
	)
	INSERT INTO Syn_Rights_Code(
		Syn_Deal_Code,Syn_Deal_Rights_Code,[Action],Created_On)
	SELECT D.Syn_Deal_Code,D.Syn_Deal_Rights_Code,'D',GETDATE()
	FROM DELETED D
END
