----int TOC, string PlatformCodes, char CntTerr, int[] CTCodes, string[] LPCodes, string SD, string ED,
----            int ObjType, string ObjRemarks, string ResRemarks, int TitleCode, string RecordType, int RecordCode, int Title_Status
DROP TYPE [Title_Objection_UDT]
CREATE TYPE [dbo].[Title_Objection_UDT] AS TABLE (
	Title_Objection_Code INT NULL,
    PlatformCodes		 VARCHAR (MAX) NULL,
    CTCodes				 VARCHAR (MAX) NULL,
    LPCodes				 NVARCHAR (MAX) NULL,
    SD					 VARCHAR (MAX) NULL,
    ED					 VARCHAR (MAX) NULL,
    ObjRemarks			 NVARCHAR (MAX) NULL,
    ResRemarks			 NVARCHAR (MAX) NULL,
    Objection_Type_Code	 INT NULL,
    Title_Status_Code	 INT NULL,
    CntTerr				 CHAR (1)      NULL,
    TitleCode			 INT NULL,
    RecordType			 CHAR (1)      NULL,
    RecordCode			 INT NULL);

--CREATE DROP  PROC [dbo].[USP_Validate_Title_Objection_Dup] 
--(  
--	@Title_Objection_UDT Title_Objection_UDT READONLY, 
--	@User_Code INT= 143
--)
--AS
BEGIN
	DECLARE @Title_Objection_UDT Title_Objection_UDT

	INSERT INTO @Title_Objection_UDT
	SELECT 8, '16,17,20,21,22,23,251,24,29,181,209,210,394','3,4,5','30-Jun-2013~29-Jun-2022,21-Jul-2013~20-Jul-2022','23/09/2021','23/09/2021','test','test',5,2,'C','562','A',39

	SELECT * FROM @Title_Objection_UDT



	SELECT 'Y' as Result
END
