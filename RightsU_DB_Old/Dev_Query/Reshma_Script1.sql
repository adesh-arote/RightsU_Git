--CREATE TYPE [dbo].[Title_Content_Version_UDT] AS TABLE 
--(
--    [Title_Content_Version_Details_Code] VARCHAR (MAX) NULL,
--    [Title_Content_Version_Code] VARCHAR (MAX) NULL,
--	[House_Id] VARCHAR(MAX) NULL
--)
--GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_Title_Content_Version_PI]
(
	@Title_Content_Version_UDT Title_Content_Version_UDT READONLY,
	@UserCode INT
)
AS
------ =============================================
---- author:  ADITYA BANDIBVADEKAR
---- create date: 06 december 2017
---- description: this usp call from title_content_viewcontroller  and check error and insert into title_content_version_udt
---- =============================================
BEGIN
	SET NOCOUNT ON;
	--DECLARE	@Title_Content_Code INT  
	--select top 1 @Title_Content_Code = Title_Content_Code from @Title_Content_Version_UDT
	
	INSERT INTO Title_Content_Version_Details([Title_Content_Version_Code],[House_Id])
	SELECT  [Title_Content_Version_Code], [House_Id] 
	FROM @Title_Content_Version_UDT T
	WHERE
	NOT EXISTS (SELECT * FROM Title_Content_Version_Details TCV WHERE T.Title_Content_Version_Code = TCV.Title_Content_Version_Code AND T.House_Id =TCV.House_Id)
end

--select * from Title_Content_Version
--select * from Title_Content_Version_Details

Select * from Email_Config_Detail



Select * from Title_Content_Version
Select * from Title_Content_Version_Details

Select * from Amort_Month
Select * from Amorted_Data



--EXEC USP_Title_Import_Schedule


Select DATEDIFF(MM,'2017-12-07','2023-03-31')
