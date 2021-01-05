ALTER FUNCTION [dbo].[UFN_Auto_Genrate_Agreement_No]
(
	@Prefix VARCHAR(100),
	@date DATETIME,
	@MasterDealCode INT
)
RETURNS VARCHAR(100)
AS
-- =============================================
-- Author:		Pavitar
-- Create DATE: 08-October-2014
-- Description:	Gets New Agreement number
-- =============================================
BEGIN
	DECLARE @result AS VARCHAR(100)
	IF(@Prefix ='A')
	BEGIN
		SET @Prefix=@Prefix+'-'+Cast(year(@date) AS VARCHAR(100))
		IF(@MasterDealCode > 0)
		BEGIN
			DECLARE @MasterDealNo VARCHAR(100) = '', @DealCode INT = 0
			SELECT @MasterDealNo = Agreement_No, @DealCode = Acq_Deal_Code FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code 
			= (SELECT Acq_Deal_Code FROM Acq_Deal_Movie WHERE Acq_Deal_Movie_Code = @MasterDealCode)
			
			SELECT @result=@MasterDealNo+'-'+Right('000'+CAST(ISNULL(MAX(ABS(CAST(RIGHT(Agreement_No,3) AS INT))),0)+1 AS VARCHAR(10)),3) 
			FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No like @MasterDealNo + '%'  and Acq_Deal_Code <> @DealCode
		END
		ELSE
		BEGIN
			SELECT @result=@Prefix+'-'+Right('00000'+CAST(ISNULL(CAST(RIGHT(MAX(Agreement_No),4) AS INT),0)+1 AS VARCHAR(10)),5) 
			FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Agreement_No like @Prefix+'%' AND (Is_Master_Deal = 'Y' Or 
				Deal_Type_Code = CAST((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Music') AS INT)
			)
		END
	END
	ELSE IF(@Prefix ='S')
	BEGIN
		SET @Prefix=@Prefix+'-'+CAST(YEAR(@date) AS VARCHAR(100))
		SELECT @result=@Prefix+'-'+Right('00000'+CAST(ISNULL(CAST(RIGHT(MAX(Agreement_No),4) AS INT),0)+1 AS VARCHAR(10)),5) 
		FROM Syn_Deal WHERE Agreement_No like @Prefix+'%'
	END
	ELSE IF(@Prefix ='M')
	BEGIN
		SET @Prefix = @Prefix + '-' + CAST(YEAR(@date) AS VARCHAR(100))
		SELECT @result = @Prefix + '-' + RIGHT('00000' + CAST(ISNULL(CAST(RIGHT(MAX(Agreement_No),4) AS INT), 0) + 1 AS VARCHAR(10)), 5) 
		FROM Music_Deal WHERE Agreement_No like @Prefix+'%'
	END
	ELSE IF(@Prefix ='P')  
	BEGIN  
		SET @Prefix = @Prefix + '-' + CAST(YEAR(@date) AS VARCHAR(100))  
		SELECT @result = @Prefix + '-' + RIGHT('00000' + CAST(ISNULL(CAST(RIGHT(MAX(Agreement_No),4) AS INT), 0) + 1 AS VARCHAR(10)), 5)   
		FROM Provisional_Deal WHERE Agreement_No like @Prefix+'%'  
	END
	RETURN ISNULL(@result,'error')
END