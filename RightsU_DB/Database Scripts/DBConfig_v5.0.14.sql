/*
This script was created by Visual Studio on 21-05-2022 at 13:41.
Run this script on 192.168.0.115\MSSQLSERVER16.RightsUGMUAT (sa) to make it the same as 192.168.0.115.RightsU_Plus_Testing (dbserver2012).
This script performs its actions in the following order:
1. Disable foreign-key constraints.
2. Perform DELETE commands. 
3. Perform UPDATE commands.
4. Perform INSERT commands.
5. Re-enable foreign-key constraints.
Please back up your target database before running this script.
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*Pointer used for text / image updates. This might not be needed, but is declared here just in case*/
DECLARE @pv binary(16)
BEGIN TRANSACTION
ALTER TABLE [dbo].[Supplementary_Config] DROP CONSTRAINT [FK_Supplementary_Config_Supplementary]
ALTER TABLE [dbo].[Supplementary_Config] DROP CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab]
SET IDENTITY_INSERT [dbo].[Supplementary] ON
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (1, N'Social Media Platform', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (2, N'SM Remarks', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (3, N'Milestones', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (4, N'Committed Date', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (5, N'Interest type', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (6, N'Interest rate', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (7, N'Grace Period', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (8, N'Penalty', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (9, N'Interest Applicable', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (10, N'Penalty Charges: Terms and Conditions', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (11, N'Credits', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (12, N'Credits Remarks', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (13, N'Clauses', N'Y')
INSERT INTO [dbo].[Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active]) VALUES (14, N'Clauses Remarks', N'Y')
SET IDENTITY_INSERT [dbo].[Supplementary] OFF
SET IDENTITY_INSERT [dbo].[Supplementary_Config] ON
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (1, 1, 1, NULL, NULL, N'TXTDDL', N'N', N'Y', NULL, 1, 1, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'SM')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (2, 2, 1, NULL, NULL, N'TXTAREA', N'N', N'N', 2000, 2, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (3, 3, 2, NULL, NULL, N'TXTDDL', N'N', N'N', NULL, 1, 1, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'MS')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (4, 4, 2, NULL, NULL, N'DATE', N'N', N'N', NULL, 2, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (5, 5, 2, NULL, NULL, N'TXTDDL', N'N', N'N', NULL, 3, 1, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'IT')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (6, 6, 2, NULL, NULL, N'DBL', N'N', N'N', 5, 4, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (7, 7, 2, NULL, NULL, N'INT', N'N', N'N', 3, 5, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (8, 7, 2, NULL, NULL, N'TXTDDL', N'N', N'N', NULL, 5, 2, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'GP')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (9, 8, 2, NULL, NULL, N'TXTAREA', N'N', N'N', 2000, 6, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (10, 9, 2, NULL, NULL, N'CHK', N'N', N'N', NULL, 7, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (11, 10, 2, NULL, NULL, N'TXTAREA', N'N', N'N', 4000, 8, 1, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (12, 11, 3, NULL, NULL, N'TXTDDL', N'N', N'Y', NULL, 3, 1, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'CR')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (13, 12, 3, NULL, NULL, N'TXTAREA', N'N', N'N', 2000, 3, 2, N'', N'', N'', N'', N'')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (14, 13, 4, NULL, NULL, N'TXTDDL', N'N', N'Y', NULL, 4, 1, N'', N'Supplementary_Data', N'Data_Description', N'Supplementary_Data_Code', N'CL')
INSERT INTO [dbo].[Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria]) VALUES (15, 14, 4, NULL, NULL, N'TXTAREA', N'N', N'N', 2000, 4, 2, N'', N'', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[Supplementary_Config] OFF
SET IDENTITY_INSERT [dbo].[Supplementary_Tab] ON
INSERT INTO [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code], [Short_Name], [Supplementary_Tab_Description], [Order_No], [Tab_Type], [EditWindowType]) VALUES (1, N'SM', N'Social Media', 1, N'NS', N'inLine')
INSERT INTO [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code], [Short_Name], [Supplementary_Tab_Description], [Order_No], [Tab_Type], [EditWindowType]) VALUES (2, N'CM', N'Commitments', 2, N'NS', N'PopUp')
INSERT INTO [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code], [Short_Name], [Supplementary_Tab_Description], [Order_No], [Tab_Type], [EditWindowType]) VALUES (3, N'OC', N'Opening & Closing Credits', 3, N'NS', N'inLine')
INSERT INTO [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code], [Short_Name], [Supplementary_Tab_Description], [Order_No], [Tab_Type], [EditWindowType]) VALUES (4, N'EC', N'Essential Clauses', 4, N'NS', N'inLine')
SET IDENTITY_INSERT [dbo].[Supplementary_Tab] OFF
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (1, N'SM', N'Facebook', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (2, N'SM', N'Instagram', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (3, N'SM', N'YouTub', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (4, N'SM', N'Twitter', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (5, N'SM', N'Other', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (6, N'MS', N'Committed Theatriacal/ OTT Release Date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (7, N'MS', N'Committed Shooting Start Date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (8, N'MS', N'Committed Shooting End Date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (9, N'MS', N'Receipt Date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (10, N'MS', N'Termination Date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (11, N'IT', N'Simple Interest', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (12, N'IT', N'Compounded Interest', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (13, N'CR', N'GTPL cannot replace/modify the opening credits', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (14, N'CR', N'GTPL cannot license/assign the film simultaneously to two different channel', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (15, N'CR', N'GTPL cannot use sound recording/AV of song on a stand-alone basis', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (16, N'CR', N'GTPL cannot use sound recording/AV of song on a stand-alone basis', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (17, N'CR', N'GTPL cannot replace/modify the credits', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (18, N'CL', N'19 (4) Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (19, N'CL', N'Credits Clauses for Satalight and Digital Straming', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (20, N'CL', N'Assignor Obtained NOC Licensee', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (21, N'CL', N'Permission for 3rd Party Contest', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (22, N'CL', N'Interest Charge Clauses for not returning pages post movie release', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (23, N'CL', N'Interest Charge Clauses for shoting not commenced withen stipulsted date', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (24, N'CL', N'Interest Charge Clauses on ATM Paid', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (25, N'CL', N'Material Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (26, N'CL', N'Release Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (27, N'CL', N'Star Cast Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (28, N'CL', N'Payment Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (29, N'CL', N'Penalties Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (30, N'CL', N'Termination Clauses', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (31, N'CL', N'Clauses Breached', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (32, N'GP', N'Day', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (33, N'GP', N'Month', N'Y')
INSERT INTO [dbo].[Supplementary_Data] ([Supplementary_Data_Code], [Supplementary_Type], [Data_Description], [Is_Active]) VALUES (34, N'GP', N'Year', N'Y')
ALTER TABLE [dbo].[Supplementary_Config]
    ADD CONSTRAINT [FK_Supplementary_Config_Supplementary] FOREIGN KEY ([Supplementary_Code]) REFERENCES [dbo].[Supplementary] ([Supplementary_Code])
ALTER TABLE [dbo].[Supplementary_Config]
    ADD CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab] FOREIGN KEY ([Supplementary_Tab_Code]) REFERENCES [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code])
COMMIT TRANSACTION



SET IDENTITY_INSERT Supplementary OFF

SET IDENTITY_INSERT System_Message ON 
INSERT INTO System_Message(System_Message_Code, Message_Key) VALUES('15582', 'Supplementary')
INSERT INTO System_Message(System_Message_Code, Message_Key) VALUES('15584', 'AddSupplementary')
INSERT INTO System_Message(System_Message_Code, Message_Key) VALUES('15585', 'AddCommitments')
INSERT INTO System_Message(System_Message_Code, Message_Key) VALUES('15586', 'SupplementaryDetailssavedsuccesfully')
SET IDENTITY_INSERT System_Message OFF

SET IDENTITY_INSERT System_Module_Message ON

INSERT INTO System_Module_Message(System_Module_Message_Code, Module_Code, Form_ID, System_Message_Code) VALUES('17105', '30', 'Supplementary', '15582')
INSERT INTO System_Module_Message(System_Module_Message_Code, Module_Code, Form_ID, System_Message_Code) VALUES('17106', '30', 'AddSupplementary', '15584')
INSERT INTO System_Module_Message(System_Module_Message_Code, Module_Code, Form_ID, System_Message_Code) VALUES('17114', '30', 'AddCommitments', '15585')
INSERT INTO System_Module_Message(System_Module_Message_Code, Module_Code, Form_ID, System_Message_Code) VALUES('17115', '30', 'SupplementaryDetailssavedsuccesfully', '15586')

SET IDENTITY_INSERT System_Module_Message OFF

SET IDENTITY_INSERT System_Language_Message ON

INSERT INTO System_Language_Message(System_Language_Message_Code, System_Language_Code, System_Module_Message_Code, Message_Desc) VALUES('23483', '1', '17105', 'Supplementary')
INSERT INTO System_Language_Message(System_Language_Message_Code, System_Language_Code, System_Module_Message_Code, Message_Desc) VALUES('23484', '1', '17106', 'Add Supplementary')
INSERT INTO System_Language_Message(System_Language_Message_Code, System_Language_Code, System_Module_Message_Code, Message_Desc) VALUES('23492', '1', '17114', 'Add Commitments')
INSERT INTO System_Language_Message(System_Language_Message_Code, System_Language_Code, System_Module_Message_Code, Message_Desc) VALUES('23493', '1', '17115', 'Supplementary Details saved succesfully')

SET IDENTITY_INSERT System_Language_Message OFF

INSERT INTO System_Right(Right_Name, Right_Code) VALUES('Supplementary', '172')
INSERT INTO System_Right(Right_Name, Right_Code) VALUES('Add Supplementary', '173')

SET IDENTITY_INSERT System_Module_Right ON

INSERT INTO System_Module_Right(Module_Right_Code, Module_Code, Right_Code) VALUES('9854', '30', '172')
INSERT INTO System_Module_Right(Module_Right_Code, Module_Code, Right_Code) VALUES('9856', '30', '173')

SET IDENTITY_INSERT System_Module_Right OFF

