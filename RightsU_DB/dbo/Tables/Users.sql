CREATE TABLE [dbo].[Users] (
    [Users_Code]             INT            IDENTITY (1, 1) NOT NULL,
    [Login_Name]             NVARCHAR (300) NULL,
    [First_Name]             NVARCHAR (300) NULL,
    [Middle_Name]            NVARCHAR (300) NULL,
    [Last_Name]              NVARCHAR (300) NULL,
    [Password]               NVARCHAR (150) NULL,
    [Email_Id]               NVARCHAR (300) NULL,
    [Contact_No]             VARCHAR (150)  NULL,
    [Security_Group_Code]    INT            NULL,
    [Is_Active]              VARCHAR (1)    CONSTRAINT [DF_Users_IsActive_1] DEFAULT ('Y') NOT NULL,
    [Is_System_Password]     VARCHAR (1)    CONSTRAINT [DF_Users_IsSystemPassword_1] DEFAULT ('Y') NOT NULL,
    [Password_Fail_Count]    INT            CONSTRAINT [DF_Users_PasswordFailCount1] DEFAULT ((0)) NOT NULL,
    [Default_Channel_Code]   INT            NULL,
    [IsLDAPUser]             CHAR (1)       NULL,
    [IsProductionHouseUser]  CHAR (1)       NULL,
    [Lock_Time]              DATETIME       NULL,
    [Created_On]             DATETIME       NULL,
    [Created_By]             INT            NULL,
    [Last_Updated_Time]      DATETIME       NULL,
    [Last_Action_By]         INT            NULL,
    [Default_Entity_Code]    INT            NULL,
    [User_Image]             VARCHAR (500)  NULL,
    [System_Language_Code]   INT            NULL,
    [ChangePasswordLinkGUID] NVARCHAR (150) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Users_Code] ASC),
    CONSTRAINT [FK_Users_Security_Group] FOREIGN KEY ([Security_Group_Code]) REFERENCES [dbo].[Security_Group] ([Security_Group_Code]),
    CONSTRAINT [FK_Users_System_Language] FOREIGN KEY ([System_Language_Code]) REFERENCES [dbo].[System_Language] ([System_Language_Code])
);




GO
CREATE TRIGGER AfterINSERTTrigger_NewUser on [Users]
FOR INSERT 
AS DECLARE @Users_Code INT, @MailSentStatus VARCHAR(50)

SELECT @Users_Code = ins.Users_Code FROM INSERTED ins;
SET @MailSentStatus = 'P';

INSERT INTO [UserCreationEmail](Users_Code, MailSentStatus, EmailSentOn, ErrorMsg, Created_On)
VALUES (@Users_Code, @MailSentStatus,NULL,NULL, GETDATE());