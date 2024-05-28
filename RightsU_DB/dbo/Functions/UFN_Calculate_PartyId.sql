CREATE FUNCTION [dbo].[UFN_Calculate_PartyId]
(
	--@Prefix Varchar(100),
	--@Padding INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	
	DECLARE @PartyIdPrefix VARCHAR(50)
	DECLARE @PartyIdPadding INT
	DECLARE @MaxPartyId INT
	DECLARE @Party_Id VARCHAR(50)

	SET @PartyIdPrefix = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'PartyIdPrefix')
	SET @PartyIdPadding = (SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'PartyIdPadding')

	SET @MaxPartyId = (SELECT ISNULL(MAX(CAST(REPLACE(Party_Id,@PartyIdPrefix,'') as INT)),0) FROM Vendor (NOLOCK) WHERE Party_Type='V' AND Party_Id LIKE '%'+@PartyIdPrefix+'%')

	SET @MaxPartyId = ISNULL(@MaxPartyId,0) + 1

	SET @Party_Id = @PartyIdPrefix + REPLACE(STR(@MaxPartyId,@PartyIdPadding),' ','0')

	--IF(@MaxPartyId > 0)
	--BEGIN
	--	SET @Party_Id = @PartyIdPrefix + REPLACE(STR(@MaxPartyId+1,@PartyIdPadding),' ','0')
	--END
	--ELSE
	--BEGIN
	--	SET @Party_Id = @PartyIdPrefix + REPLACE(STR(1,@PartyIdPadding),' ','0')
	--END

	RETURN ISNULL(@Party_Id, '')
END
