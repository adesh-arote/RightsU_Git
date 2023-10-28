CREATE PROCEDURE [dbo].[USPMHShowNameList]
@UsersCode Int,
@ChannelCode INT
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHShowNameList]', 'Step 1', 0, 'Started Procedure', 0, ''
		--Select DISTINCT ADM.Title_Code,T.Title_Name,T.Deal_Type_Code 
		--from Acq_Deal_Movie ADM 
		--INNER JOIN Title T on T.Title_Code = ADM.Title_Code
		--INNER JOIN Acq_Deal AD on AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		--where AD.Vendor_Code In (Select Vendor_Code From MHUsers Where Users_Code = @UsersCode)
		--AND AD.Is_Master_Deal = 'Y' AND AD.Deal_Type_Code <> 1 order by ADM.Title_Code

		Declare @FromDate NVARCHAR(20),@ToDate NVARCHAR(20)
		SET @FromDate =(SELECT CONVERT(VARCHAR(25),DateAdd(month, -1, Convert(date, GetDate())),106)); --(select CONVERT(VARCHAR(25),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),106))--First Day of previous month 
		SET @ToDate = CONVERT(VARCHAR(25),GETDATE(),106)--(select CONVERT(VARCHAR(25),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),106))--Last Day of previous month
	
		SELECT T.Title_Code,T.Title_Name,T.Deal_Type_Code,TitleCount FROM (
		select distinct ADRT.Title_Code,T.Title_Name,T.Deal_Type_Code
		,(Select Count(MR.TitleCode) AS TitleCount From MHRequest MR  (NOLOCK) where MR.TitleCode = T.Title_Code AND ((CAST(MR.RequestedDate AS DATE)   BETWEEN REPLACE(CONVERT(NVARCHAR,@FromDate, 106),' ', '-') AND REPLACE(CONVERT(NVARCHAR,@ToDate, 106),' ', '-')))) AS TitleCount
		from  Acq_Deal_Run ADR (NOLOCK)
		INNER JOIN Acq_Deal_Run_Title ADRT (NOLOCK) ON  ADR.Acq_Deal_Run_Code= ADRT.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC (NOLOCK)  on ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
		INNER JOIN Title T  (NOLOCK) ON T.Title_Code = ADRT.Title_Code
		INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		Where AD.Vendor_Code In (Select Vendor_Code From MHUsers (NOLOCK) Where Users_Code = @UsersCode) AND (ADRC.Channel_Code = @ChannelCode OR @ChannelCode = 0)
		AND AD.Is_Master_Deal = 'Y' AND AD.Deal_Type_Code <> 1 
		) AS T
		order by T.TitleCount desc
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPMHShowNameList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END

