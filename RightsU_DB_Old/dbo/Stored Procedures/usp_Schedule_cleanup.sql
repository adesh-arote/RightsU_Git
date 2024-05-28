

CREATE PROC [dbo].[usp_Schedule_cleanup]    
(
	@File_Code INT,
	@Channel_Code INT
)
AS    
BEGIN    
-- =============================================
/*	
Steps:-
	1.0 Delete Junk data from Temp_BV_Schedule (i.e. Schedule file Contains double quote in the data.)
	2.0 Remove spaces from Temp_BV_Schedule columns
*/
-- =============================================
	
	----- Start 1.0 -----
	UPDATE Temp_BV_Schedule set Program_Episode_Title = REPLACE(Program_Episode_Title,'"', ''),
	Program_Episode_Number = REPLACE(Program_Episode_Number, '"', ''),
	Program_Episode_ID = REPLACE( Program_Episode_ID , '"', ''),
	Program_Version_ID = REPLACE( Program_Version_ID , '"', ''),
	Program_Title = REPLACE(Program_Title,'"', ''),
	Program_Category = REPLACE(Program_Category,'"', ''),
	Schedule_Item_Log_Date = REPLACE(Schedule_Item_Log_Date,'"', ''),
	Schedule_Item_Log_Time = REPLACE(Schedule_Item_Log_Time,'"', ''),
	Schedule_Item_Duration = REPLACE(Schedule_Item_Duration, '"', ''),
	Scheduled_Version_House_Number_List = REPLACE(Scheduled_Version_House_Number_List, '"', '')
	WHERE File_Code = @File_Code
	----- End 1.0 -----
	
	----- Start 2.0 ----- 
	UPDATE Temp_BV_Schedule SET 
   	Program_Episode_Title = ltrim(rtrim(Program_Episode_Title)),
   	Program_Episode_Number = LTRIM(rtrim(Program_Episode_Number)),
   	Program_Episode_ID = LTRIM(rtrim(Program_Episode_ID)),
	Program_Version_ID = LTRIM(rtrim(Program_Version_ID)),
   	Program_Category = LTRIM(rtrim(Program_Category)),
   	Schedule_Item_Log_Date = LTRIM(rtrim(Schedule_Item_Log_Date)),
   	Schedule_Item_Log_Time = LTRIM(rtrim(Schedule_Item_Log_Time)),
   	Schedule_Item_Duration = LTRIM(rtrim(Schedule_Item_Duration)),
   	Scheduled_Version_House_Number_List = LTRIM(rtrim(Scheduled_Version_House_Number_List))
   	WHERE File_Code = @File_Code
   	----- End 2.0 -----
	 
END    

/*    
EXEC [usp_Schedule_cleanup]
*/