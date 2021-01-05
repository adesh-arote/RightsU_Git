
----Table Createion-----------------------------------------------------------------------------------------------------------------------------------------
--CREATE TABLE Music_Platform(
--    Music_Platform_Code INT IDENTITY (1,1),
--    Platform_Name NVARCHAR(MAX),
--    Parent_Code INT,
--    Is_Last_Level CHAR(1),
--    Module_Position VARCHAR(10),
--    Platform_Hierarchy NVARCHAR(MAX),
--    Inserted_On DATETIME,
--    Inserted_By INT,
--    Last_Updated_Time DATETIME,
--    Last_Action_By INT,
--    Is_Active CHAR(1)
--)

--INSERT INTO Music_Platform(Platform_Name, Parent_Code, Is_Last_Level, Module_Position, Platform_Hierarchy, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Is_Active)
--VALUES
--('Sound Recording(Audio)', NULL, 'N', 'A', 'Sound Recording(Audio)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Synchronisation / public', 1, 'Y', 'AA', 'Sound Recording(Audio)-Synchronisation/ public', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Edit Rights(restricted only to duration)', 1, 'N', 'AB', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)',GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Non-Commercial(Synchronisation)', 3, 'N', 'ABA', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Promotional', 3, 'N', 'ABB', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Promotional', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 4, 'Y', 'ABAA', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 4, 'Y', 'ABAB', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)-Right to use Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 4, 'Y', 'ABAC', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)-Right to use of Song Audio/ Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 5, 'Y', 'ABBA', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Promotional-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 5, 'Y', 'ABBB', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Promotional-Right to use Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 5, 'Y', 'ABBC', 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Promotional-Right to use of Song Audio/ Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')

--INSERT INTO Music_Platform(Platform_Name, Parent_Code, Is_Last_Level, Module_Position, Platform_Hierarchy, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Is_Active)
--VALUES
--('Underlying Works', NULL, 'N', 'B', 'Underlying Works', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Lyrics', 12, 'N', 'BA', 'Underlying Works-Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Musical Composition', 12, 'N', 'BB', 'Underlying Works-Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Edit Rights (restricted only to duration)', 12, 'N', 'BC', 'Underlying Works-Edit Rights (restricted only to duration)', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Re-recording', 13, 'Y', 'BAA', 'Underlying Works-Lyrics-Re-recording', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Re-creating Title Track', 13, 'Y', 'BAB', 'Underlying Works-Lyrics-Re-creating Title Track', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Re-recording', 14, 'Y', 'BBA', 'Underlying Works-Music Composition-Re-recording', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Re-creating Title Track', 14, 'Y', 'BBB', 'Underlying Works-Music Composition-Re-creating Title Track', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Non-Commercial (Synchronisation)', 15, 'N', 'BCA', 'Underlying Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Promotional', 15, 'N', 'BCB', 'Underlying Works-Edit Rights (restricted only to duration)-Promotional', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 20, 'Y', 'BCAA', 'Underlying Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Lyrics',  GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 20, 'Y', 'BCAB', 'Underlying Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Musical Composition',  GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 20, 'Y', 'BCAC', 'Underlying Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use of Song Audio/ Sound Recording',  GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 21, 'Y', 'BCBA', 'Underlying Works-Edit Rights (restricted only to duration)-Promotional-Right to use Lyrics',  GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 21, 'Y', 'BCBB', 'Underlying Works-Edit Rights (restricted only to duration)-Promotional-Right to use Musical Composition',  GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 21, 'Y', 'BCBC', 'Underlying Works-Edit Rights (restricted only to duration)-Promotional-Right to use of Song Audio/ Sound Recording',  GETDATE(), NULL, GETDATE(), NULL, 'Y')

--INSERT INTO Music_Platform(Platform_Name, Parent_Code, Is_Last_Level, Module_Position, Platform_Hierarchy, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Is_Active)
--VALUES
--('Stock/ Production Music', NULL, 'N', 'C', 'Stock/Production Music', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Only Musical Works (No Lyrics)', 28, 'Y', 'CA', 'Stock/ Production Music-Only Musical Works (No Lyrics)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Musical Work with lyrics', 28, 'Y', 'CB', 'Stock/ Production Music-Musical Work with lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Edit Rights (restricted only to duration)', 28, 'N', 'CC', 'Stock/ Production Music-Edit Rights (restricted only to duration)', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Non-Commercial (Synchronisation)', 31, 'N', 'CCA', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Promotional', 31, 'N', 'CCB', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Promotional',GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 32, 'Y', 'CCAA', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 32, 'Y', 'CCAB', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Musical Composition',GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 32, 'Y', 'CCAC', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use of Song Audio/ Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 33, 'Y', 'CCBA', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Promotional-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 33, 'Y', 'CCBB', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Promotional-Right to use Musical Composition',GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio/ Sound Recording', 33, 'Y', 'CCBC', 'Stock/ Production Music-Edit Rights (restricted only to duration)-Promotional-Right to use of Song Audio/ Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')


INSERT INTO Music_Platform(Platform_Name, Parent_Code, Is_Last_Level, Module_Position, Platform_Hierarchy, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Is_Active)
VALUES
--('Commissioned Works', NULL, 'N', 'D', 'Commissioned Works', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Sound Recordings', 40, 'N', 'DA', 'Commissioned Works-Sound Recordings', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Audio Visual Rights', 40, 'N', 'DB', 'Commissioned Works-Audio Visual Rights', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Underlying Works', 40, 'N', 'DC', 'Commissioned Works-Underlying Works', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Edit Rights (restricted only to duration)', 40, 'N', 'DD', 'Commissioned Works-Edit Rights (restricted only to duration)', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Clip of audio-visual recording from a song', 41, 'Y', 'DAA', 'Commissioned Works-Sound Recordings-Clip of audio-visual recording from a song', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Complete audio-visual recording of a song', 41, 'Y', 'DAB', 'Commissioned Works-Sound Recordings-Clip of audio-Complete audio-visual recording of a song', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Clip of audio-visual recording from a song', 42, 'Y', 'DBA', 'Commissioned Works-Audio Visual Rights-Clip of audio-visual recording from a song', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Complete audio-visual recording of a song', 42, 'Y', 'DBB', 'Commissioned Works-Audio Visual Rights-Clip of audio-Complete audio-visual recording of a song', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Lyrical Work', 43, 'N', 'DCA', 'Commissioned Works-Underlying Works-Lyrical Work', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Musical Work', 43, 'N', 'DCB', 'Commissioned Works-Underlying Works-Musical Work', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Re-recording', 49, 'Y', 'DCAA', 'Commissioned Works-Underlying Works-Lyrical Work-Re-recording', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Re-creating Title Track', 49, 'Y', 'DCAB', 'Commissioned Works-Underlying Works-Lyrical Work-Re-creating Title Track', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Clip of audio-visual recording from a song', 49, 'Y', 'DCAC', 'Commissioned Works-Underlying Works-Lyrical Work-Clip of audio-visual recording from a song',GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Complete audio-visual recording of a song', 49, 'Y', 'DCAD', 'Commissioned Works-Underlying Works-Lyrical Work-Complete audio-visual recording of a song', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Re-recording', 50, 'Y', 'DCBA', 'Commissioned Works-Underlying Works-Musical Work-Re-recording', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Re-creating Title Track', 50, 'Y', 'DCBB', 'Commissioned Works-Underlying Works-Musical Work-Re-creating Title Track', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Clip of audio-visual recording from a song', 50, 'Y', 'DCBC', 'Commissioned Works-Underlying Works-Musical Work-Clip of audio-visual recording from a song', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Complete audio-visual recording of a song', 50, 'Y', 'DCBD', 'Commissioned Works-Underlying Works-Musical Work-Complete audio-visual recording of a song', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Non-Commercial (Synchronisation)', 44, 'N', 'DDA', 'Commissioned Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Commercial (Right to sublicense)', 44, 'N', 'DDB', 'Commissioned Works-Edit Rights (restricted only to duration)-Commercial (Right to sublicense)', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Promotional', 44, 'N', 'DDC', 'Commissioned Works-Edit Rights (restricted only to duration)-Promotional', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 59, 'Y', 'DDAA', 'Commissioned Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 59, 'Y', 'DDAB', 'Commissioned Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio / Sound Recording', 59, 'Y', 'DDAC', 'Commissioned Works-Edit Rights (restricted only to duration)-Non-Commercial (Synchronisation)-Right to use of Song Audio / Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 60, 'Y', 'DDBA', 'Commissioned Works-Edit Rights (restricted only to duration)-Commercial (Right to sublicense)-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 60, 'Y', 'DDBB', 'Commissioned Works-Edit Rights (restricted only to duration)-Commercial (Right to sublicense)-Right to use Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio / Sound Recording', 60, 'Y', 'DDBC', 'Commissioned Works-Edit Rights (restricted only to duration)-Commercial (Right to sublicense)-Right to use of Song Audio / Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')
--('Right to use Lyrics', 61, 'Y', 'DDCA', 'Commissioned Works-Edit Rights (restricted only to duration)-Promotional-Right to use Lyrics', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use Musical Composition', 61, 'Y', 'DDCB', 'Commissioned Works-Edit Rights (restricted only to duration)-Promotional-Right to use Musical Composition', GETDATE(), NULL, GETDATE(), NULL, 'Y'),
--('Right to use of Song Audio / Sound Recording', 61, 'Y', 'DDCC', 'Commissioned Works-Edit Rights (restricted only to duration)-Promotional-Right to use of Song Audio / Sound Recording', GETDATE(), NULL, GETDATE(), NULL, 'Y')




--DBCC CHECKIDENT ('Music_Platform', RESEED, 1)
--DELETE FROM Music_Platform where Music_Platform_Code in(5,6)
--UPDATE Music_Platform SET Platform_Hierarchy = 'Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)-Right to use of Song Audio/ Sound Recording' WHERE Music_Platform_Code = 8

---End Insert statements------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------USP_Get_Music_Platform_Tree_Hierarchy--------------------------------------------------------------

 CREATE PROC [dbo].[USP_Get_Music_Platform_Tree_Hierarchy]
 (
       @MusicPlatformCodes VARCHAR(2000),
	   @Search_Music_Platform_Name NVARCHAR(500)
 )
 AS
 BEGIN

 --Declare @MusicPlatformCodes Varchar(2000) = ''
    IF(RTRIM(LTRIM(@Search_Music_Platform_Name)) <> '')
        SET @Search_Music_Platform_Name = RTRIM(LTRIM(@Search_Music_Platform_Name))

    CREATE TABLE #TEMP_MPF(
        Music_Platform_Code INT,
        Parent_Code INT,
        Is_Last_Level VARCHAR(2)
    )
   
    IF(@MusicPlatformCodes <> '')
    BEGIN
   
        INSERT INTO #TEMP_MPF
        SELECT Music_Platform_Code, ISNULL(Parent_Code, 0), Is_Last_Level
        FROM [Music_Platform] WHERE Music_Platform_Code IN (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@MusicPlatformCodes, ',')) ORDER BY Platform_Name
        WHILE((   
            SELECT COUNT(*) FROM [Music_Platform] WHERE Music_Platform_Code IN (SELECT Parent_Code FROM #TEMP_MPF) AND Music_Platform_Code NOT IN (SELECT Music_Platform_Code FROM #TEMP_MPF)
        ) > 0)
        BEGIN
            INSERT INTO #TEMP_MPF
            SELECT Music_Platform_Code, ISNULL(Parent_Code , 0), Is_Last_Level
            FROM [Music_Platform] WHERE Music_Platform_Code  IN (SELECT Parent_Code FROM #TEMP_MPF) AND Music_Platform_Code NOT IN (SELECT Music_Platform_Code  FROM #TEMP_MPF)
        END
    END
    ELSE
    BEGIN
        INSERT INTO #TEMP_MPF(Music_Platform_Code, Parent_Code )
        SELECT Music_Platform_Code, ISNULL(Parent_Code , 0) FROM [Music_Platform]
    End

    SELECT Music_Platform_Code, REPLACE(Platform_Name,@Search_Music_Platform_Name
	  --,'<span style="background-color:yellow">'+@Search_Platform_Name+'</span>') AS Platform_Name
	  ,'<span style="background-color:yellow">'
            + (SUBSTRING(Platform_Name,CHARINDEX(@Search_Music_Platform_Name,Platform_Name ,0),CHARINDEX(@Search_Music_Platform_Name,Platform_Name ,0) + (LEN(@Search_Music_Platform_Name)  - CHARINDEX(@Search_Music_Platform_Name,Platform_Name,0))) +'</span>')
            ) AS Platform_Name
	  , ISNULL(Parent_Code, 0) Parent_Code, Is_Last_Level, Module_Position,
	 (SELECT COUNT(*) FROM #TEMP_MPF tmp WHERE tmp.Parent_Code = [Music_Platform].Music_Platform_Code) ChildCount
	 From [Music_Platform] WHERE Is_Active = 'Y'
	  And Music_Platform_Code In (SELECT Music_Platform_Code FROM #TEMP_MPF)
	  --AND (Platform_Hiearachy LIKE  '%'+@Search_Platform_Name+'%' or ISNULL(@Search_Platform_Name,'') = '')
	 ORDER BY Module_Position
   
	 --Select Platform_Code, Platform_Name, IsNull(Parent_Platform_Code, 0) Parent_Platform_Code, Is_Last_Level, Module_Position From [Platform] Where Is_Active = 'Y' Order By Module_Position
    DROP TABLE #TEMP_MPF
END

--/*

--Exec USP_Get_Platform_Tree_Hierarchy '','Gaming Rights'
--Exec USP_Get_Platform_Tree_Hierarchy '1,81,122,101,78,85,45,76,121,55,77,98,165,53,158',''

--*/

--Select * from System_Parameter_New where Parameter_Name like '%Promoter_Tab_Syn%'
--Select * from Syn_Deal where Deal_Description like '%Pad%'
--select * from Title where Title_Name like '%padma%'

--Select * from Music_Platform


--Select * from Acq_Deal_Rights_Platform
--Select * from Music_Deal_DealType


--select * from sys.tables where name like 'Music%'

--CREATE TABLE Music_Deal_Platform(
--    Music_Deal_Platform_Code INT IDENTITY (1,1),
--	Music_Deal_Code INT,
--    Music_Platform_Code INT
--)

--ALTER TABLE Music_Deal_Platform
--ADD FOREIGN KEY (Music_Platform_Code) REFERENCES Music_Platform(Music_Platform_Code);

--ALTER TABLE Music_Deal_Platform
--ADD PRIMARY KEY (Music_Deal_Platform_Code);

--Select * from Music_Deal_Platform

--sp_help Music_Deal_Platform