CREATE Procedure [dbo].[USPAL_List_Status_History]
@Record_Code INT
AS
BEGIN
--DECLARE
--@Record_Code INT = 1479

		SELECT 
			ROW_NUMBER() OVER( ORDER BY MSH.Module_Status_Code ) AS 'MSH_Code',
			MSH.Module_Status_Code as ID,
			CAST(ISNULL(MSH.Version_No, ' ') as varchar(MAX)) AS [Version],
			--MSH.Status,
			CASE  
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'C' THEN 'Created'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'W' THEN 'Sent for authorization'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'A' THEN 'Approved'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'R' THEN 'Rejected'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'E' THEN 'Updated'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AM' THEN 'Amended'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'RO' THEN 'Re-Open'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'EO' THEN 'Edit Without Approval'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AP' THEN 'Auto Pushed'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'AR' THEN 'Archived'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'WA' THEN 'Waiting (Archive)'
					WHEN UPPER(RTRIM(LTRIM(ISNULL(MSH.[status],'')))) = 'F' THEN 'Finally Closed'
					ELSE '' 
			END AS [Status],
			MSH.status_changed_on as [Date],U.login_name + ' ('+Security_Group_Name +')' AS [By]  ,CASE WHEN MSH.Status IN('AM','E','C') THEN '' ELSE MSH.remarks  END AS [Remarks]
			--INTO #Temp_Module_Status_History
			FROM Module_Status_History  MSH (NOLOCK)
			INNER JOIN Users U (NOLOCK) ON MSH.status_changed_by = U.users_code
			INNER JOIN Security_Group SG (NOLOCK) ON U.Security_Group_Code=SG.Security_Group_Code
			--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code =MSH.Record_Code
			WHERE record_code = @Record_Code AND module_code = 262

END