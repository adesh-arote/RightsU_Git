

CREATE PROCEDURE [dbo].[USPGetLeaderboardUserWiseData] 
@rptDate Date
AS 
  BEGIN 

   CREATE TABLE #SecurityGroup
	(
		Security_Group_Code int,
		Security_Group_Name Varchar(1000) 
	)

	Create Table #temp
	(
		UserId INT,
		RUPoints INT,
		RptDate Date,
		isunique INT
	)

	Insert into #SecurityGroup(Security_Group_Code,Security_Group_Name) Select Security_Group_Code,Security_Group_Name 
	From [RightsUngReports_V18]..SecurityGroup (NOLOCk) 
	WHERE Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')

	Insert into #temp(UserId,RUPoints,RptDate,isunique)
	Select UserId,RUPoints,RptDate,isunique From(
	SELECT Distinct t.TraceId, t.userid AS  UserId, 
					p.points AS RUPoints,
					CONVERT(DATE,t.RequestDateTime) As RptDate,p.isunique

				FROM   trace t WITH(NOLOCK)
							INNER JOIN [RightsUngReports_V18]..pointsystemurl pu WITH(NOLOCK) 
									ON pu.pointsystemurl COLLATE DATABASE_DEFAULT = t.requestmethod COLLATE DATABASE_DEFAULT    
							INNER JOIN [RightsUngReports_V18]..pointsystem p WITH(NOLOCK)
									ON p.pointsystemurlid = pu.pointsystemurlid --AND  p.isunique = 0
							INNER JOIN [RightsUngReports_V18]..users u WITH(NOLOCK)
									ON u.users_code = t.userid 
						INNER JOIN #SecurityGroup SG WITH(NOLOCK) ON SG.Security_Group_Code = u.Security_Group_Code
						WHERE 
						t.method = 'POST' AND  t.issuccess = 1  AND CONVERT(DATE,t.RequestDateTime) = CONVERT(DATE, @rptDate)) As Temp

        Select USERID,Sum(RUPoints) AS RUPoints,RptDate From
			(Select USERID,Sum(RUPoints) AS RUPoints,RptDate  From #temp Where isunique = 0 Group BY UserId,RptDate
			UNION ALL
			Select USERID,Sum(RUPoints) AS RUPoints,RptDate From 
			(Select USERID,RUPoints,RptDate,ROW_NUMBER() OVER(Partition By  USERID,RptDate ORDER BY USERID,RptDate) AS Row#   From #temp Where isunique = 1) As Temp Where Row# = 1 
			Group BY UserId,RptDate) As A
		Group BY UserId,RptDate 

	Drop table #SecurityGroup
	Drop table #temp

  END
