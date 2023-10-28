CREATE PROCEDURE [dbo].[USPGetLeaderboard_Old1] 
AS 
  BEGIN 

      SELECT Temp.userid 
             AS 
             UserId, 
             Temp.first_name 
             AS FirstName, 
			 ISNULL(Temp.Int_Department,'')
			 AS UserDepartment,
             Temp.last_name 
             AS LastName, 
			 Temp.User_Image
			 AS UserImage,
             ISNULL(Temp.department,'') 
             AS Department, 
             Sum(Temp.points) 
             AS RUPoints, 
             (SELECT Getdate()) 
             AS CurrentDate, 
             (SELECT quarterenddate 
              FROM   quarterdefinition WITH(NOLOCK)
              WHERE  CONVERT(DATE, Getdate()) BETWEEN 
                     quarterdefinition.quarterstartdate AND 
                     quarterdefinition.quarterenddate) AS 
             QuarterEndDate 
      FROM   (SELECT userid, 
                     first_name, 
					 Int_Department,
                     last_name, 
					 User_Image,
                     Sum(points) AS Points, 
                     Stuff((SELECT DISTINCT ', ' 
                                            + Cast(ud.attrib_group_name AS 
                                            VARCHAR 
                                            ( 
                                            max )) 
                                            [text()] 
                            FROM   usersdetail ud WITH(NOLOCK)
                            WHERE  ud.users_code = trace.userid 
                                   AND ud.attrib_type = 'DP' 
                            FOR xml path(''), type) .value('.', 'NVARCHAR(MAX)') 
                     , 
                     1, 2 
                     , ' ') 
                                 Department 
              FROM   trace WITH(NOLOCK)
                     INNER JOIN pointsystemurl WITH(NOLOCK)
                             ON pointsystemurl.pointsystemurl = trace.requestmethod 
                     INNER JOIN pointsystem WITH(NOLOCK)
                             ON pointsystem.pointsystemurlid = 
                                pointsystemurl.pointsystemurlid 
                     INNER JOIN quarterdefinition WITH(NOLOCK)
                             ON quarterdefinition.quarterid = 
                                pointsystem.quarterid 
                     INNER JOIN users WITH(NOLOCK)
                             ON users.users_code = trace.userid 
					INNER JOIN SecurityGroup SG WITH(NOLOCK) ON SG.Security_Group_Code = Users.Security_Group_Code
              WHERE  trace.method = 'POST' 
                     AND issuccess = 1 
                     AND pointsystem.isunique = 0 
                     AND (CONVERT(DATE, Getdate()) BETWEEN 
                         quarterdefinition.quarterstartdate 
                         AND 
                         quarterdefinition.quarterenddate)
					AND SG.Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
					--users.Security_Group_Code NOT IN(1, 277,284) -- 1 System Admin 277 Legal 284 utosupport
              GROUP  BY userid, 
                        first_name, 
						Int_Department,
                        last_name,
						User_Image
              UNION ALL 
              SELECT A.userid, 
                     A.first_name, 
					 A.Int_Department,
                     A.last_name, 
					 User_Image,
                     Sum(A.points) AS Points, 
                     A.department 
              FROM   (SELECT userid, 
                             first_name, 
							 Int_Department,
                             last_name, 
							 User_Image,
                             Sum(DISTINCT( points ))                AS Points, 
                             pointsystemurltitle, 
                             Datepart(year, trace.requestdatetime)  AS 'Year', 
                             Datepart(month, trace.requestdatetime) AS 'Month', 
                             Datepart(day, trace.requestdatetime)   AS 'Day', 
                             Stuff((SELECT DISTINCT ', ' 
                                                    + Cast(ud.attrib_group_name 
                                                    AS 
                                                    VARCHAR( 
                                                    max )) 
                                                    [text()] 
                                    FROM   usersdetail ud WITH(NOLOCK)
                                    WHERE  ud.users_code = trace.userid 
                                           AND ud.attrib_type = 'DP' 
                                    FOR xml path(''), type) .value('.', 
                             'NVARCHAR(MAX)'), 1, 
                             2 
                             , ' ') 
                                                                    Department 
                      FROM   trace WITH(NOLOCK)
                             INNER JOIN pointsystemurl WITH(NOLOCK)
                                     ON pointsystemurl.pointsystemurl = 
                                        trace.requestmethod 
                             INNER JOIN pointsystem WITH(NOLOCK)
                                     ON pointsystem.pointsystemurlid = 
                                        pointsystemurl.pointsystemurlid 
                             INNER JOIN quarterdefinition WITH(NOLOCK)
                                     ON quarterdefinition.quarterid = 
                                        pointsystem.quarterid 
                             INNER JOIN users  WITH(NOLOCK)
                                     ON users.users_code = trace.userid
							INNER JOIN SecurityGroup SG WITH(NOLOCK) ON SG.Security_Group_Code = Users.Security_Group_Code
                      WHERE  trace.Method = 'POST' 
                             AND issuccess = 1 
                             AND CONVERT(DATE, Getdate()) BETWEEN 
                                 quarterdefinition.quarterstartdate 
                                 AND 
                                 quarterdefinition.quarterenddate 
                             AND pointsystem.isunique = 1 
							 AND SG.Security_Group_Name NOT IN ('System Admin','Support','IT','IT_View','IT View', 'Deal Entry', 'Legal','Legal Head','PFT Users')
							 --users.Security_Group_Code NOT IN(1, 277,284) -- 1 System Admin 277 Legal 284 utosupport
                      GROUP  BY userid, 
                                first_name, 
								Int_Department,
                                last_name, 
								User_Image,
                                pointsystemurltitle, 
                                Datepart(day, trace.requestdatetime), 
                                Datepart(month, trace.requestdatetime), 
                                Datepart(year, trace.requestdatetime)) AS A 
              GROUP  BY A.userid, 
                        A.first_name, 
						A.Int_Department,
                        A.last_name, 
						A.User_Image,
                        A.department) AS Temp 
      GROUP  BY Temp.userid, 
                Temp.first_name,
				Temp.Int_Department, 
                Temp.last_name, 
                Temp.department,
				Temp.User_Image
  END
