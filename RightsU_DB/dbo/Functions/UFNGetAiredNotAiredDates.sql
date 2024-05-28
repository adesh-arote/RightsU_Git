CREATE FUNCTION [dbo].[UFNGetAiredNotAiredDates]()
Returns 
  @Temp TABLE(
    UnairedStartDate DATE,
    UnairedEndDate DATE,		
    AiredStartDate DATE,
    AiredEndDate DATE
)
 AS  
 BEGIN
  DECLARE
	@UStart_Date DATE,
	@UEnd_Date DATE,
	@AStart_Date DATE,
	@AEnd_Date DATE
	
	  --SET @UStart_Date=ISNULL(@StartDate,GETDATE())  
	  --SET @UEnd_Date=ISNULL(@EndDate,DATEADD(DAY,15,ISNULL(@StartDate,GETDATE())))  	 
	  --SET @AStart_Date=ISNULL(@StartDate,DATEADD(DAY,-15,ISNULL(@EndDate,CONVERT(DATE,(SELECT MAX(Schedule_Item_Log_Date)Schedule_Item_Log_Date from BV_Schedule_Transaction)))))  
	  --SET @AEnd_Date=ISNULL(@EndDate,CONVERT(DATE,(SELECT MAX(Schedule_Item_Log_Date)Schedule_Item_Log_Date from BV_Schedule_Transaction)))
	 
	  SET @UStart_Date=GETDATE()  
	  SET @UEnd_Date=DATEADD(DAY,15,@UStart_Date)  	  
	  SET @AStart_Date=DATEADD(DAY,-15,(SELECT CONVERT(DATE,(SELECT MAX(Schedule_Item_Log_Date)Schedule_Item_Log_Date from BV_Schedule_Transaction)))) 
	  SET @AEnd_Date=(SELECT CONVERT(DATE,(SELECT MAX(Schedule_Item_Log_Date) from BV_Schedule_Transaction where Schedule_Item_Log_Date < GETDATE())))
	  
	 INSERT INTO @Temp values(@UStart_Date,@UEnd_Date,@AStart_Date,@AEnd_Date)

	 RETURN
END
