-- =============================================
-- Author:		Rajesh Godse
-- Create date: 19 March 2015
-- Description:	Get territory based on country code else return comma separated country code
-- =============================================
CREATE FUNCTION [dbo].[UFN_Get_Territory]
(
	@CountryCodes as varchar(MAX)
)
RETURNS  NVARCHAR(MAX)
AS
BEGIN
	declare @retStr NVARCHAR(MAX)
	declare @TerritoryCode int = 0

	SET @retStr = ''

	Declare @TempCountry As Table(
		Country_Code Int
	)

	INSERT INTO @TempCountry(Country_Code)
	Select number Country_Code From dbo.fn_Split_withdelemiter(@CountryCodes, ',')

	Declare @Cnt_Country Int = 0

	Select @Cnt_Country = Count(*) From @TempCountry
	
	Select  @TerritoryCode=Territory_Code From (
		Select lgd.Territory_Code, Count(*) As CountryCnt,
		(
			Select Count(*) From Territory_Details lgd1 Where lgd1.Territory_Code= lgd.Territory_Code And lgd1.Country_Code In (
				Select Country_Code From Country Where Is_Active = 'Y'
			)
		) GroupCnt
		From Territory_Details lgd Where Country_Code In (
			Select Country_Code From @TempCountry
		)
		Group By lgd.Territory_Code
	) As a Where a.GroupCnt = @Cnt_Country And CountryCnt = GroupCnt

	IF(@TerritoryCode <> 0)
	BEGIN
		select @retStr = Territory_Name from Territory where Territory_Code = @TerritoryCode
	END
	ELSE
	BEGIN
		select  @retStr = ''
	END

   return @retStr
END

