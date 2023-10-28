CREATE PROCEDURE [dbo].[USP_EmailNotification_Supp_Commitment]
@MailFrequency VARCHAR(10)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[USP_EmailNotification_Supp_Commitment]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
		IF OBJECT_ID('tempdb..#TempSupplementary') IS NOT NULL DROP TABLE #TempSupplementary  
		IF OBJECT_ID('tempdb..#TempSupplementary_td') IS NOT NULL DROP TABLE #TempSupplementary_td  

		--DECLARE
		--@MailFrequency VARCHAR(10) = 'W'

		/*Data Fetching*/
		BEGIN
		
			Select DISTINCT ads.Acq_Deal_Code,adsd.Acq_Deal_Supplementary_Detail_Code ,ad.Agreement_No, v.Vendor_Name, t.Title_Code, t.Title_Name  ,adsd.User_Value, s.Supplementary_Name,
			sd.Data_Description
			INTO #temp
			FROM Acq_Deal ad (NOLOCK)
			INNER JOIN Acq_Deal_Supplementary ads (NOLOCK) ON ads.Acq_Deal_Code = ad.Acq_Deal_Code
			INNER JOIN Acq_Deal_Supplementary_Detail adsd (NOLOCK) ON adsd.Acq_Deal_Supplementary_Code = ads.Acq_Deal_Supplementary_Code
			INNER JOIN Vendor v (NOLOCK) ON v.Vendor_Code = ad.Vendor_Code
			INNER JOIN Title t (NOLOCK) ON t.Title_Code = ads.Title_code
			INNER JOIN Supplementary_Config sc (NOLOCK) ON sc.Supplementary_Config_Code = adsd.Supplementary_Config_Code
			INNER JOIN Supplementary s (NOLOCK) ON s.Supplementary_Code = sc.Supplementary_Code
			LEFT JOIN Supplementary_Data sd (NOLOCK) ON sd.Supplementary_Data_Code = adsd.Supplementary_Data_Code
			WHERE --adsd.Supplementary_Config_Code = 4 AND 
			adsd.Supplementary_Tab_Code = 2 AND s.Supplementary_Code IN (3,4,9,7)
			order by 1,2

			CREATE TABLE #TempSupplementary(
				Acq_Deal_Code INT,
				Agreement_No NVARCHAR(MAX),
				Primary_Licensor NVARCHAR(MAX),
				Titles NVARCHAR(MAX),
				Commitments NVARCHAR(MAX),
				Applicable_Date NVARCHAR(MAX),
				Interest_Charge_Applicable NVARCHAR(MAX),
				Grace_Period NVARCHAR(MAX)
			)

			CREATE TABLE #TempSupplementary_td(
				Acq_Deal_Code INT,
				Agreement_No NVARCHAR(MAX),
				Primary_Licensor NVARCHAR(MAX),
				Titles NVARCHAR(MAX),
				Commitments NVARCHAR(MAX),
				Applicable_Date NVARCHAR(MAX),
				Interest_Charge_Applicable NVARCHAR(MAX),
				Grace_Period NVARCHAR(MAX)
			)
		
			DECLARE @Acq_Deal_Code INT, @Acq_Deal_Supplementary_Detail_Code INT
			DECLARE db_cursor CURSOR FOR 
			SELECT Acq_Deal_Code, Acq_Deal_Supplementary_Detail_Code FROM #temp
		
			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @Acq_Deal_Code, @Acq_Deal_Supplementary_Detail_Code  
		
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
			
			
				--Select @Acq_Deal_Code, @Acq_Deal_Supplementary_Detail_Code
		
				if EXISTS(SELECT * FROM #TempSupplementary WHERE Acq_Deal_Code = @Acq_Deal_Code)
				BEGIN
				
					UPDATE ts SET ts.Commitments = t.Data_Description
					FROM #TempSupplementary ts 
					INNER JOIN #temp t ON t.Acq_Deal_Code = ts.Acq_Deal_Code 
					WHERE t.Supplementary_Name = 'Milestones'
		
					UPDATE ts SET ts.Applicable_Date = t.User_Value
					FROM #TempSupplementary ts 
					INNER JOIN #temp t ON t.Acq_Deal_Code = ts.Acq_Deal_Code 
					WHERE t.Supplementary_Name = 'Committed Date'
		
					UPDATE ts SET ts.Interest_Charge_Applicable = t.User_Value
					FROM #TempSupplementary ts 
					INNER JOIN #temp t ON t.Acq_Deal_Code = ts.Acq_Deal_Code 
					WHERE t.Supplementary_Name = 'Interest Applicable'
		
					UPDATE ts SET ts.Grace_Period = CAST(t.User_Value AS NVARCHAR) +' ' + t.Data_Description
					FROM #TempSupplementary ts 
					INNER JOIN #temp t ON t.Acq_Deal_Code = ts.Acq_Deal_Code 
					WHERE t.Supplementary_Name = 'Grace Period'
				
				END
				ELSE
				BEGIN
					INSERT INTO #TempSupplementary(Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles)
					SELECT Acq_Deal_Code, Agreement_No, Vendor_Name, Title_Name FROM #temp where Acq_Deal_Supplementary_Detail_Code = @Acq_Deal_Supplementary_Detail_Code
				END
		
		
				FETCH NEXT FROM db_cursor INTO @Acq_Deal_Code, @Acq_Deal_Supplementary_Detail_Code 
			END 
		
			CLOSE db_cursor  
			DEALLOCATE db_cursor 

		END
	

		DECLARE @MailSubjectCr AS NVARCHAR(MAX),  
		@DatabaseEmail_Profile varchar(MAX),  
		@EmailUser_Body NVARCHAR(Max),  
		@DefaultSiteUrl VARCHAR(MAX),  
		@Emailbody NVARCHAR(MAX) = '',  
		@EmailHead NVARCHAR(max),  
		@EMailFooter NVARCHAR(max),  
		@EmailConfigCode INT,  
		@Subject NVARCHAR(MAX),  
		@ToMail NVARCHAR(MAX),  
		@UserCode INT  
	

		SELECT @DatabaseEmail_Profile = parameter_value FROM System_Parameter_New  WHERE Parameter_Name = 'DatabaseEmail_Profile_MusicHub'  
		SET @MailSubjectCr= 'Titles with Contractual Committed Dates' 
		SET @Subject ='Titles with Contractual Committed Dates' 

		  set @EmailHead=   
						'<html>  
						<head>  
					   
						</head>  
						<body>  
						  <p>Dear User,</p>  
						  <p>Below are the list of Title with approaching Contractual Commitments.</p>
							 <table class="tblFormat" style="width:90%; border:1px solid black;border-collapse:collapse;">  
							<tr>  
						  <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Agreement Date</th>  
						  <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Primary Licensor</th>  
						  <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Titles</th>  
						  <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Commitments</th>  
							 <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Applicable Date</th>  
							 <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Interest Charge Applicable</th>
							 <th align="center" width="25%" class="tblHead" style="border:1px solid black;  color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold; padding:5px;">Grace Period</th>  
						 </tr>' 
			/*TBD*/
		
			--UPDATE #TempSupplementary SET Applicable_Date = '2022-07-13' WHERE Acq_Deal_Code = 24720
			--UPDATE #TempSupplementary SET Applicable_Date = '2022-07-14' WHERE Acq_Deal_Code = 24724
			--UPDATE #TempSupplementary SET Applicable_Date = '2022-07-15' WHERE Acq_Deal_Code = 24735
			--UPDATE #TempSupplementary SET Applicable_Date = '2022-07-16' WHERE Acq_Deal_Code = 24752
			--SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period,DATEDIFF(dd, GETDATE(), Applicable_Date) AS Days from #TempSupplementary 
			--RETURN

			IF(@MailFrequency = '1')
			BEGIN
				INSERT INTO #TempSupplementary_td
				SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period 
				FROM (
					SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period,DATEDIFF(dd, GETDATE(), Applicable_Date) AS Days from #TempSupplementary 
				) AS A
				WHERE A.Days BETWEEN 31 AND 180
			END
			ELSE IF (@MailFrequency = '16')
			BEGIN
				INSERT INTO #TempSupplementary_td
				SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period 
				FROM (
					SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period,DATEDIFF(dd, GETDATE(), Applicable_Date) AS Days from #TempSupplementary 
				) AS A
				WHERE A.Days BETWEEN 31 AND 120
			END
			ELSE IF (@MailFrequency = 'W')
			BEGIN
				INSERT INTO #TempSupplementary_td
				SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period 
				FROM (
					SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period,DATEDIFF(dd, GETDATE(), Applicable_Date) AS Days from #TempSupplementary 
				) AS A
				WHERE A.Days BETWEEN 1 AND 30
			END
				
			DECLARE @Acq_Deal_Code_td INT, @Agreement_No_td NVARCHAR(MAX), @Primary_Licensor_td NVARCHAR(MAX), 
					@Titles_td NVARCHAR(MAX), @Commitments_td NVARCHAR(MAX), @Applicable_Date_td NVARCHAR(MAX), @Interest_Charge_Applicable_td NVARCHAR(MAX), @Grace_Period_td NVARCHAR(MAX)


			DECLARE db_cursor CURSOR FOR 
			SELECT Acq_Deal_Code, Agreement_No, Primary_Licensor, Titles, Commitments, Applicable_Date, Interest_Charge_Applicable, Grace_Period FROM #TempSupplementary_td
		
			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO  @Acq_Deal_Code_td, @Agreement_No_td, @Primary_Licensor_td, @Titles_td, @Commitments_td, @Applicable_Date_td, @Interest_Charge_Applicable_td, @Grace_Period_td
		
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				SET @Emailbody = @Emailbody +  
				'<tr>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Agreement_No_td+'</td>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Primary_Licensor_td+'</td>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Titles_td+'</td>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Commitments_td+'</td>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Applicable_Date_td+'</td>  
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Interest_Charge_Applicable_td+'</td>
				  <td class="tblData" style="border:1px solid black;text-align:center; vertical-align:top;font-family:verdana;font-size:12px; padding:5px">'+@Grace_Period_td+'</td>  
				</tr>'  

				FETCH NEXT FROM db_cursor INTO @Acq_Deal_Code_td, @Agreement_No_td, @Primary_Licensor_td, @Titles_td, @Commitments_td, @Applicable_Date_td, @Interest_Charge_Applicable_td, @Grace_Period_td
			END 
		
			CLOSE db_cursor  
			DEALLOCATE db_cursor 
		 
  
	   SET @EMailFooter =  
		 ' </table>
		 </br>  
		 (This is a system generated mail. Please do not reply back to the same)</br>  
		 </p>  
		 </body></html>'  

		SELECT  @EmailUser_Body= @EmailHead+@Emailbody+@EMailFooter  
		SELECT @EmailUser_Body 
   
	
		--EXEC msdb.dbo.sp_send_dbmail   
		--@profile_name = @DatabaseEmail_Profile,  
		--@recipients =  @ToMail,  
		--@subject = @MailSubjectCr,  
		--@body = @EmailUser_Body,   
		--@body_format = 'HTML';

   
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp  
		IF OBJECT_ID('tempdb..#TempSupplementary') IS NOT NULL DROP TABLE #TempSupplementary 
		IF OBJECT_ID('tempdb..#TempSupplementary_td') IS NOT NULL DROP TABLE #TempSupplementary_td  

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_EmailNotification_Supp_Commitment]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
--UPDATE #TempSupplementary SET Applicable_Date = '2022-12-16' WHERE Acq_Deal_Code = 24724

/*
6 Months = 180 days
5 Months = 150 days
4 Months = 120 days
3 Months = 90 days
2 Months = 60 days
1 Months = 30 days
*/