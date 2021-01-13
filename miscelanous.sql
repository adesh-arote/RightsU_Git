select * from DM_Title_Import_Utility_Data

SELECT * FROM ROLE WHERE Talent_Code = 24
select * from DM_Title_Import_Utility_Data WHERE DM_MASTER_IMPORT_CODE = (SELECT MAX(DM_MASTER_IMPORT_CODE) FROM DM_MASTER_Import)
select * from DM_Master_Log				   WHERE DM_MASTER_IMPORT_CODE = (SELECT MAX(DM_MASTER_IMPORT_CODE) FROM DM_MASTER_Import)
select * from DM_Master_Import			   WHERE DM_MASTER_IMPORT_CODE = (SELECT MAX(DM_MASTER_IMPORT_CODE) FROM DM_MASTER_Import)

TRUNCATE TABLE DM_Title_Import_Utility_Data
TRUNCATE TABLE DM_Master_Log
TRUNCATE TABLE DM_Master_Import
truncate table dm_title
--UPDATE DM_Master_Import SET [Status] = 'I' WHERE DM_Master_Import_Code = 1  
	


exec USP_Title_Import_Utility_PII 13


select * from Genres where Genres_Name like '%gec%'

Select  * from msdb..sysmail_allitems 
WHERE send_request_date BETWEEN CONVERT(DATETIME,'10-01-2021',103) AND CONVERT(DATETIME,GETDATE(),103)
and subject like '%A-2016-00060%'
order by 1 desc

select * from Module_Workflow_Detail A where Record_Code in (select Acq_Deal_Code from Acq_Deal where Agreement_No='A-2016-00060')

select * from Users A where Users_Code in (229,179,234,223)

select * from Users where Security_Group_Code in (281,37,282) and Is_Active = 'Y'
select * from Security_Group where Security_Group_Code = 37
SELECT * FROM Users WHERE Users_Code = 223

select A.*, B.Security_Group_Name from Workflow_Module_Role A
INNER JOIN Security_Group B ON A.Group_Code = B.Security_Group_Code
where Workflow_Module_Code = 1186

SELECT * FROM Business_Unit

		SELECT DISTINCT U2.Email_Id, SG.Security_Group_Name, MWD.Next_Level_Group, U2.Security_Group_Code,  U2.Users_Code 
		FROM Users U1
		INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (9)
		INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'
		INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		INNER JOIN Module_Workflow_Detail MWD ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Is_Done = 'Y' 
		AND MWD.Module_Code = 30 
		AND MWD.Record_Code = 1828 
		AND MWD.Module_Workflow_Detail_Code < 3076
		--------------------------------------------------------
			SELECT DISTINCT U1.Email_Id, 
			ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U1.Security_Group_Code, 
			U1.Users_Code 
			FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
				  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code

			Users U1
			INNER JOIN Module_Workflow_Detail MWD ON MWD.Primary_User_Code = U1.Users_Code AND MWD.Is_Done = 'Y' 
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'

			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code


select * from Acq_Deal where Acq_Deal_Code IN (

select DISTINCT Record_Code from Module_Status_History where Status IN ('A','R')
AND Status_Changed_On BETWEEN CONVERT(DATETIME,'10-01-2021',103) AND CONVERT(DATETIME,GETDATE(),103)
AND Module_Code = 30
) AND Deal_Workflow_Status <> 'W'



