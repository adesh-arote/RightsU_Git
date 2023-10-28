-- =============================================
-- Author:		Rajesh Godse
-- Create date: 19 March 2015
-- Description:	Get territory based on country code else return comma separated country code
-- =============================================
CREATE FUNCTION [dbo].[UFN_Get_Language_With_Parent]
(
	@LanguageCodes as varchar(MAX)
)
RETURNS  NVarchar(MAX)
AS
BEGIN
	declare @retStr NVarchar(MAX)
	declare @LanguageGroupCode int = 0

	SET @retStr = ''

	Declare @TempLanguage As Table(
		Language_Code Int
	)

	INSERT INTO @TempLanguage(Language_Code)
	Select number Language_Code From dbo.fn_Split_withdelemiter(ISNULL(@LanguageCodes,''), ',')

	Declare @Cnt_Language Int = 0

	

	Select @Cnt_Language = Count(*) From @TempLanguage
	
	Select  @LanguageGroupCode=Language_Group_Code From (
		Select lgd.Language_Group_Code, Count(*) As LanguageCnt,
		(Select Count(*) From Language_Group_Details lgd1 Where lgd1.Language_Group_Code= lgd.Language_Group_Code) GroupCnt
		From Language_Group_Details lgd Where Language_Code In (
			Select Language_Code From @TempLanguage
		)
		Group By lgd.Language_Group_Code
	) As a Where a.GroupCnt = @Cnt_Language And LanguageCnt = GroupCnt

	IF(@LanguageGroupCode <> 0)
	BEGIN
		select @retStr = Language_Group_Name from Language_Group where Language_Group_Code = @LanguageGroupCode
	END
	ELSE
	BEGIN
		select  @retStr =  STUFF(
				(Select distinct ', ' + Language_Name from [Language] WHERE Language_Code in (Select Language_Code From @TempLanguage)
				FOR XML PATH('')), 1, 1, '')
	END

   return @retStr
END


