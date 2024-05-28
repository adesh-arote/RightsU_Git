CREATE PROCEDURE [dbo].[USPAL_GetLoadsheetList]
AS
BEGIN
	SELECT ls.AL_Load_Sheet_Code, ls.Load_sheet_No, ls.Load_Sheet_Month, COUNT(lsd.AL_Load_Sheet_Code) AS NoOfBookingSheet,
	--CASE WHEN  ls.Status = 'P' THEN 'Pending'
	--	WHEN ls.Status = 'W' THEN 'Waiting'
	--	WHEN ls.Status = 'E' THEN 'Error'
	--ELSE 'Success'
	--END AS Status, 
	ls.Status,
	u.First_Name +' '+ u.Last_Name AS InsertedBy, ls.Inserted_On
	FROM AL_Load_Sheet ls
	INNER JOIN AL_Load_Sheet_Details lsd ON lsd.AL_Load_Sheet_Code = ls.AL_Load_Sheet_Code
	INNER JOIN Users u ON u.Users_Code = ls.Inserted_By
	GROUP BY ls.AL_Load_Sheet_Code, ls.Load_sheet_No, ls.Load_Sheet_Month, ls.Status, u.First_Name +' '+ u.Last_Name , ls.Inserted_On
	ORDER BY ls.AL_Load_Sheet_Code desc
END