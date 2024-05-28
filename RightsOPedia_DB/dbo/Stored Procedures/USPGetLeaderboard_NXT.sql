﻿
CREATE PROCEDURE [dbo].[USPGetLeaderboard_NXT] 
AS 
BEGIN 

	Declare @QuarterEndDate Date,@QuarterStartDate Date,@StartDate Varchar(20),@EndDate Varchar(20)

	BEGIN
		SELECT @QuarterEndDate = quarterenddate ,@QuarterStartDate = QuarterStartDate
					FROM  QuarterDefinition Q WITH(NOLOCK)
					WHERE  CONVERT(DATE, Getdate()) BETWEEN 
							Q.quarterstartdate AND 
							Q.quarterenddate 

		SELECT @StartDate = REPLACE(CONVERT(NVARCHAR,DATEADD(day,-1,getdate()), 106), ' ', '-'),
				@EndDate = REPLACE(CONVERT(NVARCHAR,getdate(), 106), ' ', '-')

	END
    
	BEGIN

		Select UserId,FirstName,LastName,UserImage,
				Department,SUM(RUPoints) RUPoints,CurrentDate,QuarterEndDate 
			From
				(Select l.UserId,
				u.First_Name As FirstName,
				u.Last_Name  AS LastName,
				u.User_Image AS UserImage,
				( SELECT Stuff((SELECT DISTINCT ', ' 
														+ Cast(ud.attrib_group_name AS 
														VARCHAR 
														( 
														max )) 
														[text()] 
										FROM   usersdetail ud WITH(NOLOCK)
										WHERE  ud.users_code = l.userid 
												AND ud.attrib_type = 'DP' 
										FOR xml path(''), type) .value('.', 'NVARCHAR(MAX)') 
									, 
									1, 2 
									, ' ') 
											)  Department, 
				l.RUPoints RUPoints,
				Getdate()  AS CurrentDate,
				@QuarterEndDate As QuarterEndDate
				From LeaderBoardData l (NOLOCK)
				Inner JOIN Users u (NOLOCK) ON l.UserId = u.Users_Code
				Where RptDate between @QuarterStartDate AND @QuarterEndDate) As Temp
					Group by  UserId,FirstName,LastName,UserImage,Department,CurrentDate,QuarterEndDate 

	END

 END

