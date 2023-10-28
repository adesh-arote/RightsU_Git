CREATE PROCEDURE [dbo].[USP_Get_Login_Details]
(
   	@Data_For VARCHAR(MAX),
	@Entity_Code INT,
	@User_Code INT
)
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Login_Details]', 'Step 1', 0, 'Started Procedure', 0, '' 
		SET NOCOUNT ON;
		SET FMTONLY OFF;

		CREATE TABLE #PreReqData
		(
			Parameter_Value VARCHAR(MAX),
			Data_For VARCHAR(3)
		)
	
		IF(CHARINDEX('MLA',@Data_For) > 0)
		BEGIN
		
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT Parameter_Value, 'MLA' FROM System_Parameter_New WHERE Parameter_Name = 'MAXLOGINATTEMPTS'

		END

		IF(CHARINDEX('MLM',@Data_For) > 0)
		BEGIN
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT Parameter_Value, 'MLM' FROM System_Parameter_New WHERE Parameter_Name = 'MAXLOCKTIMEMINUTES'
		END

		IF(CHARINDEX('DEN',@Data_For) > 0)
		BEGIN
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT Entity_Name, 'DEN' FROM Entity (NOLOCK) Where Entity_Code = @Entity_Code
		END

		IF(CHARINDEX('DEL',@Data_For) > 0)
		BEGIN
			INSERT INTO #PreReqData(Parameter_Value, Data_For)
			SELECT Logo_Name, 'DEL' FROM Entity (NOLOCK) Where Entity_Code = @Entity_Code
		END

		IF(CHARINDEX('PVD',@Data_For) > 0)
		BEGIN
			DECLARE @LastPasswordChangeDate VARCHAR(50),@daydiff INT=0,@defaultdays INT=0
			SET @LastPasswordChangeDate=(SELECT TOP 1 Password_Change_Date FROM Users_Password_Detail (NOLOCK) WHERE Users_Code=@User_Code ORDER BY Password_Change_Date DESC )
			if(@LastPasswordChangeDate IS NULL)
			set @LastPasswordChangeDate='1900-01-01'
			SELECT @daydiff=DATEDIFF(day,@LastPasswordChangeDate,GETDATE())
			SELECT @defaultdays=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'PASSWORDVALIDDAY'
			IF(@daydiff>@defaultdays)
				BEGIN
				INSERT INTO #PreReqData(Parameter_Value, Data_For)
				SELECT 'true', 'PVD'
				END
			ELSE
				BEGIN
				INSERT INTO #PreReqData(Parameter_Value, Data_For)
				SELECT 'false', 'PVD'
				END
		END

		SELECT Parameter_Value, Data_For FROM #PreReqData

		IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Login_Details]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END