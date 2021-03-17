	SELECT DISTINCT MWD.Record_Code,
	DEE.Users_Email_id + ';' +
	   STUFF(( SELECT DISTINCT  ';' + U.Email_Id FROM
                Users U
				INNER JOIN Users_Business_Unit ubu on ubu.Users_Code = u.Users_Code and ubu.Business_Unit_Code = bu.Business_Unit_Code
				WHERE  U.Security_Group_Code = MWD.Group_Code
              FOR
                XML PATH('')
              ), 1, 1, '')  AS Email_Id 

	,DATEDIFF(d,MSH.Status_Changed_On,GETDATE()) AS [Days]
    ,BU.Business_Unit_Name

	FROM Module_Workflow_Detail MWD
	INNER JOIN Module_Status_History MSH ON MSH.Record_Code=MWD.Record_Code AND MSH.Module_Code=30
	INNER JOIN Acq_Deal AD ON MSH.Record_Code=AD.Acq_Deal_Code
	INNER JOIN Workflow_Module WM ON WM.Workflow_Code=AD.Work_Flow_Code AND WM.Module_Code=MSH.Module_Code AND WM.Business_Unit_Code=AD.Business_Unit_Code
	AND (MSH.Status_Changed_On>=WM.Effective_Start_Date AND MSH.Status_Changed_On<=ISNULL(WM.System_End_Date,CONVERT(datetime,'31 Dec 9999')))  
	INNER JOIN Business_Unit BU ON BU.Business_Unit_Code=AD.Business_Unit_Code AND BU.Is_Active='Y'
	INNER JOIN Workflow_Module_Role WMR ON WMR.Workflow_Module_Code=WM.Workflow_Module_Code AND WMR.Group_Code=MWD.Group_Code AND WMR.Group_Level=MWD.Role_Level
	
	LEFT JOIN Deal_Expiry_Email DEE ON DEE.Business_Unit_Code=AD.Business_Unit_Code
	where MWD.Module_Workflow_Detail_Code IN(
	select MIN(Module_Workflow_Detail_Code) from Module_Workflow_Detail
	WHERE Is_Done='N' and Module_Code = 30
		GROUP BY Record_Code,Module_Code,Is_Done) 
		AND
	( MSH.Module_Status_Code in (
	select  MAX(Module_Status_Code) from Module_Status_History WHERE Module_Code=30
	group by Record_Code, Module_Code 
	)
	and MSH.Status = 'W')
	--AND (
	--(dateadd(d, WMR.Reminder_Days, MSH.Status_Changed_On)<GETDATE())
	--OR
	--(DATEDIFF(d,MSH.Status_Changed_On,GETDATE())>DEE.Mail_alert_days)
	--)
	AND ((
	((dateadd(d, WMR.Reminder_Days, MSH.Status_Changed_On)<=GETDATE())
	OR
	(DATEDIFF(d,MSH.Status_Changed_On,GETDATE())>DEE.Mail_alert_days)
	)
	AND @Is_Daily='Y'
	)
	OR (
	((dateadd(d, WMR.Reminder_Days, MSH.Status_Changed_On)=GETDATE())
	OR
	(DATEDIFF(d,MSH.Status_Changed_On,GETDATE())=DEE.Mail_alert_days)
	)
	AND @Is_Daily='N'
	))
	AND DEE.Alert_Type='W'
	AND Business_Unit_Code = 1
	--SELECT * FROM Deal_Expiry_Email WHERE Alert_Type = 'W' and Business_Unit_Code = 1
	select * from Module_Workflow_Detail where Record_Code in( 95,170,181)   order by Record_Code
	
	select * from users where Security_Group_Code = 278
		select * from users where Security_Group_Code = 294
		select * from Security_Group where Security_Group_Code in (278,294)

	select * from users A
	inner join Users_Business_Unit B on B.Users_Code = A.Users_Code
	where Security_Group_Code = 278 and b.Business_Unit_Code = 1

	Update Deal_Expiry_Email set Users_Email_id = 'aparna.nair@uto.in' where Users_Email_id <> ''

	sele
