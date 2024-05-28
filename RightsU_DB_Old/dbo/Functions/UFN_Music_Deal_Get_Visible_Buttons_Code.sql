----SELECT * FROM Title_Content WHERE Title_Code = 26087 AND Title_Content_Code = 4600

--DECLARE
--@TitleCode BIGINT = 26087, 
--@EpisodeNo INT = 5, 
--@BV_Schedule_Transaction_Code BIGINT = 0

----INSERT INTO BV_Schedule_Transaction (
----	Program_Episode_ID, Program_Version_ID, Program_Episode_Number, Program_Title, Program_Category, Schedule_Item_Log_Date, Schedule_Item_Log_Time, Schedule_Item_Duration,
----	Scheduled_Version_House_Number_List, Found_Status, File_Code, Channel_Code, IsProcessed, Inserted_By, Inserted_On, Title_Code, Deal_Movie_Code, Deal_Movie_Rights_Code, IsIgnore
----)VALUES(
----	'134554325', '530454015', '5', 'Title Music Schedule', 'Hindi Content', 'Mar 20, 2017', '3:30 PM', '1:05:04', 
----	'1', 'Y', '23193', '24', 'N', 143, GETDATE(), '26087', '15332', '22130', 'N'
----)


--SELECT BST.BV_Schedule_Transaction_Code, TC.Title_Code, TC.Episode_No, CONVERT(DATETIME, BST.Schedule_Item_Log_Date, 121) AS Schedule_Date,
--BST.Schedule_Item_Log_Time, BST.Channel_Code, CAST('' AS VARCHAR(3)) AS Valid_Flag
--FROM BV_Schedule_Transaction BST
--INNER JOIN Title_Content TC ON TC.Ref_BMS_Content_Code = BST.Program_Episode_ID AND TC.Title_Code = BST.Title_Code
--WHERE TC.Title_Code = @TitleCode AND TC.Episode_No = @EpisodeNo
--	AND (BST.BV_Schedule_Transaction_Code = @BV_Schedule_Transaction_Code OR @BV_Schedule_Transaction_Code = 0)

CREATE FUNCTION [dbo].[UFN_Music_Deal_Get_Visible_Buttons_Code]
(
 	@Music_Deal_Code INT = 0,
	@Version FLOAT = 0003,
	@User_Code INT = 143,
	@WorkFlowStatus VARCHAR(10) = 'A'
) 
RETURNS VARCHAR(MAX)
AS
BEGIN
	--SET NOCOUNT ON
	--DECLARE 
	--@Music_Deal_Code INT = 2,
	--@Version FLOAT = 0001,
	--@User_Code INT = 204,
	--@WorkFlowStatus VARCHAR(10) = 'W'

	DECLARE 
		@Visible_Buttons_Code VARCHAR(MAX) = '' , @IsZeroWorkFlow VARCHAR(2) = '', @ParentDealCode INT = 0 , @Module_Code INT = 163,
		@currentApproverGroupCode INT = 0, @currentUserGroupCode INT = 0, @Business_Unit_Code INT = 0

	DECLARE 
		@Edit INT = 2, @Delete INT = 6 , @View INT = 7, @SendForApproval INT = 8, @Clone INT = 10,
		@Approve INT = 11, @Reject INT = 12, @Amendment INT = 18, @Rollback INT = 116

	DECLARE @Module_Rights Table
	(
		Right_Code INT,
		Right_Name  NVARCHAR(100),
		Visible varchar(1)
	)

	SELECT @currentUserGroupCode = Security_Group_Code FROM Users WHERE Users_Code = @User_Code  

	INSERT INTO @Module_Rights (Right_Code, Right_Name,Visible)
	SELECT DISTINCT SR.Right_Code, SR.Right_Name, CASE WHEN ISNULL(SGR.Security_Group_Code, 0) = 0 THEN  'N' ELSE 'Y' END
	FROM System_Module_Right SMR 
	INNER JOIN System_Right SR ON SR.Right_Code = SMR.Right_Code
	LEFT JOIN Security_Group_Rel SGR ON SMR.Module_Right_Code = SGR.System_Module_Rights_Code AND SGR.Security_Group_Code = @currentUserGroupCode
	WHERE SR.Right_Code IN (@Edit, @Delete, @View, @SendForApproval, @Clone, @Approve, @Reject, @Amendment, @Rollback) AND SMR.Module_Code = @Module_Code  
	ORDER BY SR.Right_Code

	--- Zero Level  WorkFlow ---
	SELECT @IsZeroWorkFlow = [dbo].[UFN_Check_Workflow](@Module_Code, @Music_Deal_Code) 

	SELECT @ParentDealCode = COUNT(AT_Music_Deal_Code) FROM AT_Music_Deal WHERE Music_Deal_Code = @Music_Deal_Code

	IF(@IsZeroWorkFlow = 'Y')
	BEGIN
		-- PRINT 'Zero Level workflow has assigned thats''why no need to show ''Send for Approval'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code = @SendForApproval
	END
	ELSE IF(@IsZeroWorkFlow != 'N')
	BEGIN
		-- PRINT 'More than Zero Level workflow has assigned thats''why no need to show ''Send for Approval, Approve, Reject'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@SendForApproval, @Approve, @Reject)
	END
	
	IF(@Version <= 1)
	BEGIN
		-- PRINT 'Version is less then or qual to 1 thats''why no need to show ''Rollback'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @Rollback 
	END
	ELSE 
	BEGIN
		-- PRINT 'Version is greater then 1 thats''why no need to show ''Delete'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  = @Delete 
	END

	IF(@WorkFlowStatus = 'A')
	BEGIN
		-- PRINT 'Deal status is Approved thats''why no need to show ''Edit, Delete, Send for Approval, Approve, Reject, Rollback'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SendForApproval, @Approve, @Reject, @Rollback)
	END
	ELSE IF(@WorkFlowStatus = 'W')
	BEGIN
		-- PRINT 'Deal status is Waiting thats''why no need to show ''Edit, Delete, Send for Approval, Amendment, Rollback'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @Delete, @SendForApproval, @Amendment, @Rollback)
	END
	ELSE IF(@WorkFlowStatus = 'R')
	BEGIN
		--PRINT 'Deal status is Rejected thats''why no need to show ''Delete, Amendment'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amendment, @Delete)

		Declare @AllowEditAllOnRejection VARCHAR(1), @RetValue Int = 0
		SELECT @AllowEditAllOnRejection = Parameter_value FROM System_Parameter_New 
		WHERE Parameter_Name = 'Allow_Edit_All_On_Rejection' AND IsActive = 'Y'

		Select Top 1 @RetValue = Group_Code From Module_Workflow_Detail 
		Where Record_Code = @Music_Deal_Code AND Module_Code = 163 And Role_Level = 0 Order By Module_Workflow_Detail_Code Desc
		IF (@currentUserGroupCode = @RetValue OR @AllowEditAllOnRejection = 'Y') 
		BEGIN
			IF(@IsZeroWorkFlow = 'N')
			BEGIN
				UPDATE @Module_Rights SET Visible = 'Y' WHERE Right_Code = @SendForApproval
			END
		END
		ELSE
		BEGIN
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@EDIT, @SendForApproval,@Approve)
		END
	END
	
	IF(@WorkFlowStatus != 'A')
	BEGIN
		-- PRINT 'Deal status is not Approved thats''why no need to show ''Amendment, Clone'' button(s)'
		UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code IN (@Amendment ,@Clone)
	END
	
	--For Approve
	SELECT @Business_Unit_Code = Business_Unit_Code FROM Music_Deal WHERE Music_Deal_Code = @Music_Deal_Code

	SET @currentUserGroupCode = 0
	SELECT @currentUserGroupCode = Security_Group_Code FROM Users U
	INNER JOIN Users_Business_Unit UBU ON UBU.Users_Code = U.Users_Code
	WHERE U.Users_Code = @User_Code AND UBU.Business_Unit_Code = @Business_Unit_Code

	SELECT @currentApproverGroupCode = ISNULL(dbo.UFN_Get_Current_Approver_Code(@Module_Code, @Music_Deal_Code), 0)

	-- PRINT '@currentUserGroupCode : ' + CAST(@currentUserGroupCode AS VARCHAR)
	-- PRINT '@currentApproverGroupCode : ' + CAST(@currentApproverGroupCode AS VARCHAR)
	IF( @currentUserGroupCode != @currentApproverGroupCode OR  @currentUserGroupCode = 0 OR @currentApproverGroupCode = 0)
	BEGIN
		IF(@IsZeroWorkFlow = 'N')
		BEGIN
			-- PRINT 'Current logged-in user is not belonging to Current approver group thats''why no need to show ''Approve, Reject'' button(s)'
			UPDATE @Module_Rights SET Visible = 'N' WHERE Right_Code  IN(@Approve, @Reject)
		END
	END

  	SELECT  @Visible_Buttons_Code = (SELECT STUFF((SELECT ','+ Cast(Right_Code as Varchar(MAX)) FROM @Module_Rights WHERE Visible='Y' FOR XML PATH('')), 1, 1, '' ) )
	RETURN  ',' + @Visible_Buttons_Code + ','
	--select *  FROM @Module_Rights WHERE Visible='Y' 
END
GO
