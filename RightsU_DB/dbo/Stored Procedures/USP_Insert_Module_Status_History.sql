
CREATE Procedure [dbo].[USP_Insert_Module_Status_History]
(
	@Module_Code INT,
	@Record_Code INT, 
	@User_Action CHAR(1), 
	@Login_User INT, 
	@Remarks NVARCHAR(4000)
)
AS
--	=================================
--	Created By : Priti Phand
--	Created On : 14 Nov 2014
--	Reason : When user set milestone for any deal, insert one entry in Module_Status_History with specified remarks
--	=================================
begin	
	Insert InTo Module_Status_History
	Select @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks
end
