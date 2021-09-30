--///////////////// FILE DB CONFIG v5.0.1.12

IF NOT EXISTS(SELECT TOP 1 * from System_Versions where Version_No = '1.02.04')
BEGIN
	INSERT INTO System_Versions VALUES('1.02.04','MusicHub',GETDATE(),'First test version MusicHub')
END


IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'P&ARightsReport')
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Channel_Code,Type,isactive,Description,Is_System_Admin)
	VALUES('P&ARightsReport','\Download',Getdate(),0,'',Getdate(),247,'','U','Y','Acquisition','')
END
GO

---------- Title Import Utility changes

DELETE FROM [DM_Title_Import_Utility]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[DM_Title_Import_Utility] ON 

GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (1, N'Title Name', 1, N'Title', N'Title_Name', N'TEXT', N'N', NULL, NULL, NULL, N'', N'Y', N'man~dup~', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (2, N'Title Type', 2, N'Title', N'Deal_Type_Code', N'TEXT', N'N', N'Deal_Type', N'Deal_Type_Name', N'Deal_Type_Code', N'', N'Y', N'man', N'Y', N'TT')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (3, N'Title Language name', 3, N'Title', N'Title_Language_Code', N'TEXT', N'N', N'Language', N'Language_Name', N'Language_Code', N'', N'Y', N'man', N'Y', N'TL')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (4, N'Original Title Language Name', 4, N'Title', N'Original_Language_Code', N'TEXT', N'N', N'Language', N'Language_Name', N'Language_Code', N'', N'Y', N'', N'Y', N'OL')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (5, N'Year of Release', 6, N'Title', N'Year_Of_Production', N'INT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (6, N'Banner', 7, N'Map_Extended_Column', N'Columns_Value_Code', N'TEXT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (7, N'Director', 8, N'Title_Talent', N'Talent_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 1)', N'Y', N'man', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (8, N'Producer', 9, N'Title_Talent', N'Talent_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 4)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (9, N'Star Cast', 10, N'Title_Talent', N'Talent_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 2)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (10, N'Music Composer', 11, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 21)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (11, N'Program', 12, N'Title', N'Program_Code', N'TEXT', N'N', N'Program', N'Program_Name', N'Program_Code', N'', N'Y', N'', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (12, N'Lyricist', 14, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 15)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (13, N'DOP', 15, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 22)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (14, N'Duration In Minute', 13, N'Title', N'Duration_In_Min', N'INT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (15, N'Synopsis', 16, N'Title', N'Synopsis', N'TEXT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (16, N'Original Title Name', 17, N'Title', N'Original_Title', N'TEXT', N'N', N'', N'', N'', N'', N'Y', N'man', N'N', NULL)
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (17, N'Genres', 18, N'Title_Geners', N'Genres_Code', N'TEXT', N'Y', N'Genres', N'Genres_Name', N'Genres_Code', N'', N'Y', N'', N'Y', N'GE')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (18, N'Country Of Origin', 19, N'Title_Country', N'Country_Code', N'TEXT', N'Y', N'Country', N'Country_Name', N'Country_Code', N'', N'Y', N'', N'N', N'CO')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (19, N'Story', 21, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 16)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (20, N'Script', 22, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 17)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (21, N'Dialogues', 23, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 19)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (22, N'Screen play', 24, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 18)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (23, N'Choreographer', 25, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 23)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (24, N'Singers', 26, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 13)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (25, N'Others Talent', 27, N'Map_Extended_Column_Values', N'Column_Code', N'TEXT', N'Y', N'Talent', N'Talent_Name', N'Talent_Code', N' AND Talent_Code IN (Select Talent_Code From Talent_Role WHERE Role_Code = 24)', N'Y', N'', N'Y', N'TA')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (26, N'Type of Film', 28, N'Map_Extended_Column', N'Columns_Value_Code', N'TEXT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', N'TF')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (27, N'Colour or B&W', 29, N'Map_Extended_Column', N'Columns_Value_Code', N'TEXT', N'N', N'', N'', N'', N'', N'Y', N'', N'N', N'COB')
GO
INSERT [dbo].[DM_Title_Import_Utility] ([DM_Title_Import_Utility_Code], [Display_Name], [Order_No], [Target_Table], [Target_Column], [Colum_Type], [Is_Multiple], [Reference_Table], [Reference_Text_Field], [Reference_Value_Field], [Reference_Whr_Criteria], [Is_Active], [validation], [Is_Allowed_For_Resolve_Conflict], [ShortName]) VALUES (28, N'CBFC Rating', 30, N'Map_Extended_Column', N'Columns_Value_Code', N'TEXT', N'Y', N'', N'', N'', N'', N'Y', N'', N'N', N'CR')
GO
SET IDENTITY_INSERT [dbo].[DM_Title_Import_Utility] OFF
GO



--------------------------IPR Module Changes------------------------------------------------------------------------------------------------
INSERT INTO SYSTEM_PARAMETER_NEW(Parameter_Name,Parameter_Value,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Channel_Code,Type,IsActive,Description,IS_System_Admin,Client_Name)SELECT 'DB-ITE',90,NULL,NULL,NULL,NULL,NULL,NULL,'U','Y','International trademark expiring in','Y','VMP'INSERT INTO SYSTEM_PARAMETER_NEW(Parameter_Name,Parameter_Value,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Channel_Code,Type,IsActive,Description,IS_System_Admin,Client_Name)SELECT 'DB-TE',90,NULL,NULL,NULL,NULL,NULL,NULL,'U','Y','Domestic trademark expiring in','Y','VMP'INSERT INTO Users_Configuration(Dashboard_Key,Dashboard_Value,Users_Code)SELECT 'DB-ITE',30,136INSERT INTO Users_Configuration(Dashboard_Key,Dashboard_Value,Users_Code)SELECT 'DB-TE',30,136INSERT INTO System_Module(Module_Code,Module_Name,Module_Position,Parent_Module_Code,Is_Sub_Module,Url,Target,Css,Can_Workflow_Assign,Is_Active)
VALUES (249,'IPR Dashboard','CC',113,'N','IPR_Dashboard/Dashboard','mainframe','sub','N','Y')

INSERT INTO System_Module_Right(Module_Code,Right_Code)
VALUES (249,1),(249,2),(249,6),(249,7)

INSERT INTO Email_Config(Email_Type,OnScreen_Notification,Allow_Config,IsChannel,IsBusinessUnit,Notification_Frequency,Days_Config,Days_Freq,Remarks,[Key],Is_Include_Job)
VALUES('Trademark Expiry','Y','Y','N','N','Y','N','<30,60,90',null,'TE','Y')

INSERT INTO Email_Config_Detail(Email_Config_Code,OnScreen_Notification,Notification_Frequency,Notification_Days,Notification_Time)
SELECT 27,'Y','N',0,GETDATE()
	
INSERT INTO Email_Config_Detail_Alert (Email_Config_Detail_Code,Mail_Alert_Days,Allow_Less_Than)
VALUES(1021,30,'N'),(1021,60,'N'),(1021,90,'Y')
	
INSERT INTO System_Module_Right(Module_Code,Right_Code)
SELECT 114,10


INSERT INTO Email_Template (Template_For, Template_Desc)
SELECT 'Trademark' , ' <html>        <head>          <style>           table.tblFormat {      border: 1px solid black;     border-collapse: collapse;                }        td.tblHead {        border: 1px solid black;       color: #ffffff;                  background-color: #585858;         font-family: verdana;               font-size: 12px;              }      td.tblData {       border: 1px solid black;        vertical-align: top;           font-family: verdana;       font-size: 12px;              }      .textFont {        color: black;    font-family: verdana;          font-size: 12px;        }              #divFooter {     color: gray;              }            </style>          </head>      <body>       <div class="textFont">        Dear &nbsp;USER,<br />              <br />          Kindly take note that the below mention trademarks or expiry on their expiry dates mentioned below.You are requested to take note of the same and determine next steps. if you need any further information regarding any of the below trademarks please get in touch with your legal contact</b>.<br />              <br />           <br />                  </div>             <table class="tblFormat">             <tr>              <td align="center" width="14%" class="tblHead"><b>Trademark No</b></td>         <td align="center" width="14%" class="tblHead"><b>Trademark Name</b></td>            <td align="center" width="15%" class="tblHead"><b>Applicant Name</b></td>             <td align="center" width="15%" class="tblHead"><b>Expiry On</b></td>         <td align="center" width="20%" class="tblHead"><b>Created By</b></td>         <td align="center" width="15%" class="tblHead"><b>Creation Date</b></td>          <td align="center" width="15%" class="tblHead"><b>Class</b></td>                 </tr>           <tr>                   <td align="center" class="tblData">{Trademark No}</td>        <td align="center" class="tblData">{Trademark Name}</td>             <td align="center" class="tblData">{Applicant Name}</td>               <td align="center" class="tblData">{Expiry On}</td>             <td align="center" class="tblData">{Created By}</td>             <td align="center" class="tblData">{Creation Date}</td>           <td align="center" class="tblData">{Class}</td>                        </tr>       </table>             <br />          <br />              Please <a href="{link}" target="_blank"><b>click here</b></a> for more details.      <br />          <br />         <div id="divFooter" class="textFont">This email is generated by RightsU</div>       </body>    </html>'


--INSERT INTO Deal_Description (Deal_Desc_Name, Type, Is_Active)
--SELECT 'All Rights Agreement', 'A', 'Y'
--UNION ALL SELECT 'All Rights Agreement', 'S', 'Y'
--UNION ALL SELECT 'Theatrical Rights Agreement', 'A', 'Y'
--UNION ALL SELECT 'Theatrical Rights Agreement', 'S', 'Y'



--insert into Extended_Columns_Value (Columns_Code, Columns_Value)
--  SELECT 5 , 'U/A 7+'
--UNION ALL SELECT 5 , 'U/A 13+'
--UNION ALL SELECT 5 , 'U/A 16+'

--insert into Deal_Type (Deal_Type_Name, Is_Default, Is_Grid_Required, Is_Active, Is_Master_Deal, Parent_Code, Deal_Or_Title )
--SELECT  'Contractor','N', 'Y','Y','N',17,'A'

--INSERT INTO Role (Role_Name, Role_Type, Is_Rate_Card, Deal_Type_Code)
--SELECT 'Contractor', 'T', 'N',1036

--INSERT INTO Extended_Columns (Columns_Name, Control_Type, Is_Ref,Is_Defined_Values, Is_Multiple_Select, Ref_Table, Ref_Display_Field, Ref_Value_Field, Additional_Condition, Is_Add_OnScreen)
--SELECT 'Contractor','DDL',	'Y'	,'N',	'Y',	'TALENT',	'Talent_Name',	'Talent_Code',	'34'	,'Y'

INSERT INTO System_Module (Module_Code,Module_Name,Module_Position,Parent_Module_Code,Is_Sub_Module,Url,Target,Css,Can_Workflow_Assign,Is_Active)
SELECT 250,'IPR Report','CD',113,'N','Reports/IPRReport','mainframe','sub','N','Y'

INSERT INTO System_Module_Right(Module_Code,Right_Code)
VALUES (250,7),(250,152)

INSERT INTO System_Module_Right(Module_Code,Right_Code)
VALUES (251,1),(251,2)