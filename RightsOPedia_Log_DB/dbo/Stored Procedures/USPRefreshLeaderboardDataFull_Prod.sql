﻿
CREATE PROCEDURE [dbo].[USPRefreshLeaderboardDataFull_Prod]  
@rptStartDate Date,
@rptEndDate Date
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
Exec USPGetLeaderboardUserWiseDataFull @rptStartDate,@rptEndDate
END

BEGIN
update r set Flag = 'U' From
[RightsU]..LeaderBoardData(NOLOCK) l  
INNER JOIN #Refreshdata r on l.UserId = r.UserId AND l.RptDate = r.RptDate
END

BEGIN
	update l set 
	UserId = r.UserId,
	RUPoints = r.RUPoints,
	RptDate = r.RptDate
	From
	[RightsU]..LeaderBoardData l  
	INNER JOIN #Refreshdata r on l.UserId = r.UserId AND l.RptDate = r.RptDate AND r.Flag = 'U'
END

BEGIN 
Update #Refreshdata SET Flag = 'I' Where ISNULL(Flag,'') = ''
END

BEGIN
Insert into [RightsU]..LeaderBoardData (UserId,RUPoints,RptDate)
	Select 
	UserId,
	RUPoints,
	RptDate
	From #Refreshdata 
	WHERE Flag = 'I'
END


Drop table #Refreshdata

END