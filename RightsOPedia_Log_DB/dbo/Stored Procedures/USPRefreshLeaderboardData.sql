

CREATE PROCEDURE [dbo].[USPRefreshLeaderboardData]  
@rptDate Date
AS
BEGIN

Create Table #Refreshdata(
UserId        int,
RUPoints int,
RptDate Date,
Flag Char(1)
)

BEGIN
Insert into #Refreshdata(UserId,RUPoints,RptDate)
Exec USPGetLeaderboardUserWiseData @rptDate
END

BEGIN
update r set Flag = 'U' From
[RightsUngReports_V18]..LeaderBoardData(NOLOCK) l  
INNER JOIN #Refreshdata r on l.UserId = r.UserId AND l.RptDate = r.RptDate
END

BEGIN
	update l set 
	UserId = r.UserId,
	RUPoints = r.RUPoints,
	RptDate = r.RptDate
	From
	[RightsUngReports_V18]..LeaderBoardData l  
	INNER JOIN #Refreshdata r on l.UserId = r.UserId AND l.RptDate = r.RptDate AND r.Flag = 'U'
END

BEGIN 
Update #Refreshdata SET Flag = 'I' Where ISNULL(Flag,'') = ''

END

BEGIN
Insert into [RightsUngReports_V18]..LeaderBoardData (UserId,RUPoints,RptDate)
	Select 
	UserId,
	RUPoints,
	RptDate
	From #Refreshdata 
	WHERE Flag = 'I'

END


Drop table #Refreshdata

END
