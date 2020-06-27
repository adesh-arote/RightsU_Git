--INSERT INTO System_Language(
--	[Language_Name], [Layout_Direction], [Is_Default], [Is_Active]
--)VALUES
--('English', 'LTR', 'Y', 'Y'),
--('Hindi', 'LTR', 'N', 'Y'),
--('عربى', 'RTL', 'N', 'Y')

--INSERT INTO System_Message(Message_Key)
--VALUES('शीर्षक जोड़ें'),('Add'),('SaveToExcel'),
--('TerritoryName'),('Serach'),('ShowAll'),('SortBy'),
--('Territory'),('Theatrical'),('Countries'),('Status'),('Action'),
--('Edit'),('Activate'),('Deactivate'),
--('TotalRecords'),('PageSize')

--INSERT INTO System_Module_Message([Module_Code], [Form_ID], [System_Message_Code])
--VALUES(NULL, 'Common', 2), (NULL, 'Common', 3), (NULL, 'Common', 5), (NULL, 'Common', 6), (NULL, 'Common', 7), (NULL, 'Common', 11), (NULL, 'Common', 12),
--(NULL, 'Common', 13), (NULL, 'Common', 14), (NULL, 'Common', 15), (NULL, 'Common', 16), (NULL, 'Common', 17),
--(59, 'TerritoryList', 1), (59, 'TerritoryList', 4), (59, 'TerritoryList', 8), (59, 'TerritoryList', 9), (59, 'TerritoryList', 10)

--INSERT INTO System_Language_Message(System_Language_Code, System_Module_Message_Code, Message_Desc)
--VALUES
--(2, 476, N'शीर्षक जोड़ें'), (2, 1, N'जोड़ें'), (3, 1, N'إضافة'), 
--(1, 2, 'Save To Excel'), (2, 2, N'एक्सेल में सहेजें'), (3, 2, N'حفظ إلى إكسيل'), 
--(1, 3, 'Search'), (2, 3, N'खोजे'), (3, 3, N'بحث'), 
--(1, 4, 'Show All'), (2, 4, N'सभी दिखाएँ'), (3, 4, N'عرض الكل'), 
--(1, 5, 'Sort By'), (2, 5, N'क्रमबद्ध करें'), (3, 5, N'ترتيب حسب'), 
--(1, 6, 'Status'), (2, 6, N'स्थिति'), (3, 6, N'الحالة'), 
--(1, 7, 'Action'), (2, 7, N'कार्रवाई'), (3, 7, N'عمل'), 
--(1, 8, 'Edit'), (2, 8, N'संपादित करें'), (3, 8, N'تصحيح'), 
--(1, 9, 'Activate'), (2, 9, N'सक्रिय करें'), (3, 9, N'تفعيل'), 
--(1, 10, 'Deactivate'), (2, 10, N'निष्क्रिय करें'), (3, 10, N'عطل'), 
--(1, 11, 'Total Records'), (2, 11, N'कुल '), (3, 11, N'إجمالي السجلات'), 
--(1, 12, 'Page Size'), (2, 12, N'प्रति पृष्ठ अभिलेख'), (3, 12, N'حجم الصفحة'), 
--(1, 13, 'Territory List'), (2, 13, N'क्षेत्र सूची'), (3, 13, N'قائمة الأقاليم'), 
--(1, 14, 'Territory Name'), (2, 14, N'क्षेत्र का नाम'), (3, 14, N'اسم الإقليم'), 
--(1, 15, 'Territory'), (2, 15, N'क्षेत्र'), (3, 15, N'منطقة'), 
--(1, 16, 'Theatrical'), (2, 16, N'नाटकीय'), (3, 16, N'مسرحي'), 
--(1, 17, 'Countries'), (2, 17, N'देश'), (3, 17, N'بلدان')

use RightsU_Plus

--select * from System_Message where message_key like '%MusicLanguageList%'
--select * from System_Module_Message where System_Message_Code = 3380
--select * from System_Language_Message where System_Module_message_code=4790
--UPDATE System_Module_Message SET Form_ID = 'View Content' WHERE System_Message_Code = 3361
--UPDATE System_Module_Message SET Module_Code = NULL WHERE System_Message_Code = 3318
--UPDATE System_Message SET Message_Key = 'AddMovieAlbum' where System_Message_Code = 3299
--select * from system_language
--update system_language set Layout_Direction = 'RTL' where System_Language_Code=1
--update System_Message set  Message_Key = 'Lengthmin' where System_Message_Code = 3297
--INSERT INTO SYSTEM_MESSAGE(MESSAGE_KEY,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
--VALUES('ErrorinAddToContentMusicLinkmethod',GETDATE(),143,GETDATE(),143)
--SELECT TOP(1) * FROM SYSTEM_MESSAGE ORDER BY SYSTEM_MESSAGE_CODE DESC

--INSERT INTO SYSTEM_LANGUAGE_MESSAGE(SYSTEM_LANGUAGE_CODE, SYSTEM_MODULE_MESSAGE_CODE, MESSAGE_DESC,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
--	VALUES(3, @SYSTEM_MODULE_MESSAGE_CODE, @A_MesgDesc,GETDATE(),143,GETDATE(),143)

--INSERT INTO SYSTEM_MODULE_MESSAGE([MODULE_CODE], [FORM_ID], [SYSTEM_MESSAGE_CODE], [Inserted_On], [Inserted_By], [Last_Updated_Time], [Last_Action_By])
--VALUES(160, null, 3367, GETDATE(), 143, GETDATE(), 143)
--SELECT TOP(1) * FROM SYSTEM_MODULE_MESSAGE ORDER BY SYSTEM_MODULE_MESSAGE_CODE DESC
--UPDATE SYSTEM_MODULE_MESSAGE SET  FORM_ID='View Content' WHERE SYSTEM_MODULE_MESSAGE_CODE = 3361

--INSERT INTO SYSTEM_LANGUAGE_MESSAGE(SYSTEM_LANGUAGE_CODE, SYSTEM_MODULE_MESSAGE_CODE, MESSAGE_DESC, Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
--VALUES
--(2, 492, N'वास्तविक भाषा', GETDATE(), 143, GETDATE(), 143)
--SELECT  TOP(1)* FROM SYSTEM_LANGUAGE_MESSAGE ORDER BY SYSTEM_LANGUAGE_MESSAGE_CODE DESC
--update System_Language_Message set System_Language_Code = 2 where System_Language_Message_Code = 5136 
--update System_Language_Message set System_Module_Message_Code = 1 where system_language_message_code in(599,598,597,596,595,594,593,592,591,590,589,588,587,586,585,584)
--update System_Language_Message set Message_Desc = N'Music Title Track Assignment' where System_Language_Message_Code = 4759
--select * from system_language
--update system_language set layout_direction='RTL' where system_language_code=1


--Select * from System_Module where Module_Name like '%Music Track%'

--UPDATE System_Module_Message SET Form_ID = NULL WHERE System_Module_Message_Code = 4856
--UPDATE System_Language_Message SET Message_Desc = N'Airing' WHERE System_Language_Message_Code = 6775
--UPDATE System_Language_Message SET Message_Desc = N'प्रसारण' WHERE System_Language_Message_Code = 6776
--UPDATE System_Language_Message SET Message_Desc = N'تعافي' WHERE System_Language_Message_Code = 8183

--DELETE FROM System_Language_Message where System_Language_Message_Code = 15304
--DELETE FROM System_Module_Message where System_Module_Message_Code = 13464
-- DELETE FROM System_Message where System_Message_Code = 10760

--update System_Language_Message set Message_Desc = N'Rights Start Date'


--Update System_Module_Message SET 

--UPDATE System_Language_Message SET Message_Desc = N'Remarks' WHERE System_Language_Message_Code = 20150
--UPDATE System_Language_Message SET Message_Desc = N'प्टिप्पणियां' WHERE System_Language_Message_Code = 20151
--UPDATE System_Language_Message SET Message_Desc = N'التقييد' WHERE System_Language_Message_Code = 20152


--update System_Module_Message set Module_Code = null where System_Module_Message_Code = 13658

--update System_Module_Message set Form_ID = 'Sports Ancillary-Marketing' where System_Module_Message_Code = 12437
--update System_Language_Message SET Message_Desc = N'क्या आप वाकई यह सही हटाना चाहते हैं?' WHERE System_Language_Message_Code = 17151
--Update System_Module_Message set Form_ID = null where System_Module_Message_Code = 11341
--DELETE from System_Message where System_Message_Code = 8677
--DELETE from System_Module_Message where System_Module_Message_Code = 10236

--SELECT DISTINCT System_Module_Message_Code
--FROM System_Module_Message
--WHERE System_Module_Message_Code NOT IN (SELECT DISTINCT System_Module_Message_Code FROM System_Language_Message)
-----------------------------------------------------------------------------------------------------------------------------------------------------
--SELECT
--    System_Module_Message_Code, Message_Desc, COUNT(*)
--FROM
--    System_Language_Message
--WHERE 
--	System_Language_Code = '1'
--GROUP BY
--    System_Module_Message_Code, Message_Desc
--HAVING 
--    COUNT(*) > 1

	
--SELECT
--    System_Message_Code, Module_Code, COUNT(*)
--FROM
--    System_Module_Message
----WHERE 
----	System_Language_Code = ''
--GROUP BY
--    System_Message_Code, Module_Code
--HAVING 
--    COUNT(*) > 1

	
--SELECT
--    Message_Key, COUNT(*)
--FROM
--    System_Message

--GROUP BY
-- Message_Key
--HAVING 
--    COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--DELETE FROM System_Message WHERE System_Message_Code = 8686

--Update System_Language_Message set Message_Desc= N'रिकॉर्ड सफलतापूर्वक जोड़ा गया' where System_Language_Message_Code = 2722

--update System_Message set Message_Key = 'RoyaltyRecoupmentList' where System_Message_Code = 5635
--update System_Module_Message set Module_Code = 18 where System_Module_Message_Code = 10230
--update System_Module_Message set Form_ID = null where System_Module_Message_Code = 9189


--update System_Language_Message set Message_Desc = N'Platforms' where System_Language_Message_Code = 8082
--update System_Module_Message set Modul e_Code = 153 where System_Module_Message_Code = 4725
--update System_Module_Message set Form_ID = null where System_Module_Message_Code = 5995

--delete from System_Message where System_Message_Code = 3448
--delete from System_Module_Message where System_Module_Message_Code = 4900
--DELETE from System_Language_Message where System_Language_Message_Code = 2842
--UPDATE System_Language_Message SET Message_Desc = N'Please Select at least one Right' WHERE System_Language_Message_Code = 7023
--UPDATE System_Language_Message SET Message_Desc = N'कृपया कम से कम एक दाईं ओर का चयन करें' WHERE System_Language_Message_Code = 7024
--UPDATE System_Language_Message SET Message_Desc = N'الرجاء تحديد حق واحد على الأقل' WHERE System_Language_Message_Code = 7025

--update System_Language_Message set Message_Desc = N'Title Deactivated successfully' where System_Language_Message_Code = 2728
select * from System_Module_Message where Module_Code = 115	

EXEC USP_Validate_Rights_Duplication_UDT_Syn


select * from System_Message where  message_key like '%ChannelLi%'
select * from System_Module_Message where System_Message_Code = 7674
select * from System_Language_Message where System_Module_message_code=16881
 
INSERT INTO SYSTEM_MESSAGE(MESSAGE_KEY,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
VALUES('MileStoneNatureName',GETDATE(),143,GETDATE(),143)
SELECT TOP(1) * FROM SYSTEM_MESSAGE ORDER BY SYSTEM_MESSAGE_CODE DESC

INSERT INTO SYSTEM_MODULE_MESSAGE([MODULE_CODE], [FORM_ID], [SYSTEM_MESSAGE_CODE], [Inserted_On], [Inserted_By], [Last_Updated_Time], [Last_Action_By])
VALUES(203,'Milestone Nature', 3411, GETDATE(), 143, GETDATE(), 143)
SELECT TOP(1) * FROM SYSTEM_MODULE_MESSAGE ORDER BY SYSTEM_MODULE_MESSAGE_CODE DESC
	
INSERT INTO SYSTEM_LANGUAGE_MESSAGE(SYSTEM_LANGUAGE_CODE, SYSTEM_MODULE_MESSAGE_CODE, MESSAGE_DESC, Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
VALUES 
(1, 17049, N'Milestone Nature Name Dsc', GETDATE(), 143, GETDATE(), 143),
(2, 17049, N'स्थिति संचय', GETDATE(), 143, GETDATE(), 143),
(3, 17049, N'صفقة مخصصة ل', GETDATE(), 143, GETDATE(), 143)
SELECT  TOP(1)* FROM SYSTEM_LANGUAGE_MESSAGE ORDER BY SYSTEM_LANGUAGE_MESSAGE_CODE DESC

Update System_Language_Message SET Message_Desc = N'Nature of Deal Name' where System_Language_Message_Code = 23315


--Delete from System_Language_Message where System_Language_Message_Code = 17344

--INSERT INTO SYSTEM_LANGUAGE_MESSAGE(SYSTEM_LANGUAGE_CODE, SYSTEM_MODULE_MESSAGE_CODE, MESSAGE_DESC, Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
--VALUES
--(1, 10300, N'Status', GETDATE(), 143, GETDATE(), 143),
--(2, 10300, N'स्थिति संचय', GETDATE(), 143, GETDATE(), 143),
--(3, 10300, N'الحالة', GETDATE(), 143, GETDATE(), 143)
--SELECT  TOP(1)* FROM SYSTEM_LANGUAGE_MESSAGE ORDER BY SYSTEM_LANGUAGE_MESSAGE_CODE DESC

--update System_Module_Message SET Form_ID = 'ExportToExcel' where System_Module_Message_Code = 10230


SELECT * FROM System_Module where Module_Name like '%pro%'
select * from System_Module where Module_Code = 161
SELECT * FROM System_Module where Module_Name like '%Content%'
Select * from System_Module where Module_Code = 130
SELECT * FROM System_Module where Module_Name like '%BV Exception%'
SELECT * FROM System_Module where Module_Name like '%Language%'
SELECT * FROM System_Module where Module_Name like '%System Parameter%'


Select * from Users where Login_Name like '%Aditya%'

Select * From System_Module Where Parent_Module_Code= 130
Select * From System_Module Where Module_Code = 162


Select * from Acq_Deal_Pushback_Title
Select * from Acq_Deal where Deal_Desc like '%holdback%'
Select * from DM_Pushback where Title like '%holdback%'



Select * from Deal_Type where Deal_Type_Name like '%Embedded%'

Select * from System_Parameter_New where Parameter_Name like '%DealTypeCodesForMusicDeal%'

--INSERT INTO Deal_Type(Deal_Type_Name,Is_Default,Is_Grid_Required,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Is_Active,Is_Master_Deal,Parent_Code,Deal_Or_Title,Deal_Title_Mapping_Code)
--VALUES
--('Promos/Standalone','N','Y',Null,Null,Null,Null,Null,'Y','N',Null,'TA',Null)

--UPDATE System_Parameter_New SET Parameter_Value = '1,11,31' WHERE Id = 150

--select * from Music_Type

--INSERT INTO Music_Type VALUES('Cover','MV','Y')

--Select * from Music_Deal_DealType

--Select * from Music_Deal where Agreement_No = 'M-2017-00030'
--update Music_Deal set Deal_Type_Code = '1,11' where Music_Deal_Code = 62

--CREATE TABLE Music_Deal_Type (
--    Music_Deal_Type_Code INT IDENTITY(1,1) PRIMARY KEY,
--    Music_Deal_Code INT NOT NULL,
--    Music_Deal_Code VARCHAR(200)
--);

--Select * from Music_Deal_Channel where Music_Deal_Code = 67

--  Select * from Music_Deal_DealType where Music_Deal_Code = 67
--  Insert into Music_Deal_DealType Values(67,1)
--  Update music_Deal_DealType SET Deal_Type_Code = '1,11,31' where Music_Deal_Type_Code = 20


--  INSERT INTO Music_Deal_DealType(
--		Music_Deal_Code, Deal_Type_Code
--	)
--	SELECT  Music_Deal_Code, Deal_Type_Code
--	FROM Music_Deal


--	Select * from Music_Title

	EXEC USP_Validate_Rights_Duplication_UDT_Syn

	Select Parameter_Value from System_Parameter_New Where Parameter_Name = 'SPN_Music_Version'
	UPDATE System_Parameter_New SET Parameter_Value = 'N' WHERE Id = 1112

	Select * from Users
	update Users SET Email_Id = 'sainath.suryawanshi@uto.in' Where Users_Code = 136

	Select * from DM_Music_Title



	Select * from Music_Title Order by 1 desc
	Select * from Music_Title where Music_Title_Code = 5125
	Select * from Music_Album where Music_Album_Code = 1227
	Select * from Music_Album_Talent where Music_Album_Code = 1227



	Select * from Music_Title_Talent 
	Select * from Music_Album
	Select * from Music_Title_Label Where Music_Title_Code = 5125

	Select * from Role
	Select  * from Talent_Role
	Select  * from Talent where Talent_Name like '%MovieStarcast%'

	   SELECT                 
        CAST(Tal.Talent_Name  AS NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title TT                
        --INNER JOIN Role R ON R.Role_Code = TT.Role_Code                
        --INNER JOIN Talent Tal ON tal.talent_Code = TT.Talent_code
		INNER JOIN Music_Album MA ON MA.Music_Album_Code = TT.Music_Album_Code
		INNER JOIN Music_Album_Talent MAT ON MAT.Music_Album_Code =  MA.Music_Album_Code
		INNER JOIN Talent Tal On Tal.Talent_Code = MAT.Talent_Code
       WHERE                 
        TT.Music_Title_Code = 5125           
       ORDER BY                
        Tal.Talent_Name          

	EXEC	USP_DM_Music_Title_PIII 6439
    

		Select * from System_Parameter_New Where Parameter_Name like '%SPN%'
		update System_Parameter_New set Parameter_Value = 'Y' where Id = 1112


		exec USP_Music_Title_Import_Schedule

		EXEC USP_Music_Title_Import_Schedule
		select * from DM_Master_Import order by 1 desc
		update DM_Master_Import SET Status = 'Q' Where DM_Master_Import_Code IN(6448)
		DELETE FROM DM_Master_Import  Where DM_Master_Import_Code IN(6448)

		DROP Procedure USP_DM_Music_Title_PI
		DROP Procedure [USP_DM_Music_Title_PIII]
		DROP Procedure USP_Insert_Music_Title_Import_UDT
		DROP Type Music_Title_Import

		alter Table DM_Music_Title add Public_Domain CHAR(1)
		Select * from DM_Music_Title


			CREATE TYPE [dbo].[Music_Title_Import] AS TABLE (
    [Music_Title_Name]      NVARCHAR (1000) NULL,
    [Duration]              NVARCHAR (100)  NULL,
    [Movie_Album]           NVARCHAR (1000) NULL,
    [Singers]               NVARCHAR (2000) NULL,
    [Lyricist]              NVARCHAR (2000) NULL,
    [Music_Director]        NVARCHAR (2000) NULL,
    [Title_Language]        NVARCHAR (100)  NULL,
    [Music_Label]           NVARCHAR (1000) NULL,
    [Year_of_Release]       NVARCHAR (100)  NULL,
    [Title_Type]            NVARCHAR (100)  NULL,
    [Genres]                NVARCHAR (100)  NULL,
    [Star_Cast]             NVARCHAR (1000) NULL,
    [Music_Version]         NVARCHAR (100)  NULL,
    [Effective_Start_Date]  NVARCHAR (100)  NULL,
    [Theme]                 NVARCHAR (100)  NULL,
    [Music_Tag]             NVARCHAR (200)  NULL,
    [Movie_Star_Cast]       NVARCHAR (1000) NULL,
    [Music_Album_Type]      NVARCHAR (100)  NULL,
    [DM_Master_Import_Code] NVARCHAR (100)  NULL,
    [Excel_Line_No]         VARCHAR (50)    NULL,
	[Public_Domain]         CHAR(1) NULL
	);





Select * from Deal_Expiry_Email





SET IDENTITY_INSERT Extended_Columns ON 

INSERT INTO Extended_Columns(Columns_Code, Columns_Name, Control_Type, Is_Ref, Is_Defined_Values, Is_Multiple_Select) SELECT 16, 'VMP Share IPR', 'TXT', 'N' ,'N', 'N' UNION SELECT 17, 'VMP Share Derivative Rights', 'TXT', 'N', 'N', 'N'

SET IDENTITY_INSERT Extended_Columns OFF 

Select * from Extended_Columns



Select * from Users order by 1 desc 1284,1295
update Users Set Password = 'rV14GJfSa3iDe1kKsBtdpQ==' where Users_Code in(1284,1295)

Select * from Users where Login_Name like '%ni%'
--UPDATE Users Set Password = 'rV14GJfSa3iDe1kKsBtdpQ==' Where Users_Code = 1299

Select * from Party_Category