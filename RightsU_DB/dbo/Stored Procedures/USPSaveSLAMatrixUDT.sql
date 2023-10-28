CREATE PROCEDURE [dbo].[USPSaveSLAMatrixUDT]
(
	@TATSLAUDT TATSLAUDT ReadOnly,
	@UserCode INT
)
AS
--DECLARE @TATSLAUDT TATSLAUDT
--	INSERT INTO @TATSLAUDT(
--		WorkflowStatus,SLA1FromDays, SLA1ToDays,SLA1Users,SLA2FromDays,SLA2ToDays,SLA2Users,SLA3FromDays,SLA3ToDays,SLA3Users,Action
--	)
--	VALUES
--		(1,1,1,'1219',2,2,'1219',1,1,'143','Add')
--	declare	@UserCode INT=143

BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPSaveSLAMatrixUDT]', 'Step 1', 0, 'Started Procedure', 0, ''
		DECLARE @TATSLACode INT, @TATSLAMatrix1Code INT, @TATSLAMatrix2Code INT, @TATSLAMatrix3Code INT, @WorkflowStatus INT, @SLA1FromDays INT, @SLA1ToDays INT, @SLA1Users VARCHAR(50), @SLA2FromDays INT,
		@SLA2ToDays INT, @SLA2Users VARCHAR(50), @SLA3FromDays INT,	@SLA3ToDays INT, @SLA3Users VARCHAR(50), @Action VARCHAR(10) 

		DECLARE db_cursor CURSOR FOR
		Select * from @TATSLAUDT

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @TATSLACode, @TATSLAMatrix1Code, @TATSLAMatrix2Code, @TATSLAMatrix3Code , @WorkflowStatus, @SLA1FromDays, @SLA1ToDays, @SLA1Users, @SLA2FromDays, @SLA2ToDays, @SLA2Users, @SLA3FromDays, @SLA3ToDays,
		@SLA3Users,@Action
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF(@Action = 'Add')
			BEGIN
				--Level 1 
				INSERT INTO TATSLAMatrix(TATSLACode, TATSLAStatusCode, LevelNo, FromDay, ToDay, InsertedOn, InsertedBy)
				select @TATSLACode, @WorkflowStatus, 1, @SLA1FromDays, @SLA1ToDays, GETDATE(),@UserCode 

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, SCOPE_IDENTITY(), GETDATE(), @UserCode from [dbo].[fn_Split_withdelemiter](@SLA1Users,',')
				--Level 2
				INSERT INTO TATSLAMatrix(TATSLACode, TATSLAStatusCode, LevelNo, FromDay, ToDay, InsertedOn, InsertedBy)
				Select @TATSLACode, @WorkflowStatus, 2, @SLA2FromDays, @SLA2ToDays, GETDATE(),@UserCode

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, SCOPE_IDENTITY(), GETDATE(), @UserCode from [dbo].[fn_Split_withdelemiter](@SLA2Users,',')

				--Level 3
				INSERT INTO TATSLAMatrix(TATSLACode, TATSLAStatusCode, LevelNo, FromDay, ToDay, InsertedOn, InsertedBy)
				Select @TATSLACode, @WorkflowStatus, 3, @SLA3FromDays, @SLA3ToDays, GETDATE(), @UserCode

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, SCOPE_IDENTITY(), GETDATE(), @UserCode from [dbo].[fn_Split_withdelemiter](@SLA3Users,',') 
			END
			IF(@Action = 'Edit')
			BEGIN
				--Level 1 
				Update TATSLAMatrix SET FromDay = @SLA1FromDays, ToDay = @SLA1ToDays, UpdatedOn = GETDATE(), UpdatedBy = @UserCode  WHERE TATSLAMatrixCode = @TATSLAMatrix1Code

				DELETE FROM TATSLAMatrixDetails WHERE TATSLAMatrixCode = @TATSLAMatrix1Code 

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, @TATSLAMatrix1Code , GETDATE(), @UserCode  from [dbo].[fn_Split_withdelemiter](@SLA1Users,',')

				--Level 2
				Update TATSLAMatrix SET FromDay = @SLA2FromDays, ToDay = @SLA2ToDays, UpdatedOn = GETDATE(), UpdatedBy = @UserCode  WHERE TATSLAMatrixCode = @TATSLAMatrix2Code

				DELETE FROM TATSLAMatrixDetails WHERE TATSLAMatrixCode = @TATSLAMatrix2Code 

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, @TATSLAMatrix2Code , GETDATE(), @UserCode from [dbo].[fn_Split_withdelemiter](@SLA2Users,',')

				--Level3
				 Update TATSLAMatrix SET FromDay = @SLA3FromDays, ToDay = @SLA3ToDays, UpdatedOn = GETDATE(), UpdatedBy = @UserCode  WHERE TATSLAMatrixCode = @TATSLAMatrix3Code

				DELETE FROM TATSLAMatrixDetails WHERE TATSLAMatrixCode = @TATSLAMatrix3Code 

				INSERT INTO TATSLAMatrixDetails(UserCode, TATSLAMatrixCode, InsertedOn, InsertedBy)
				select Number, @TATSLAMatrix3Code , GETDATE(), @UserCode from [dbo].[fn_Split_withdelemiter](@SLA3Users,',') 
			END

		FETCH NEXT FROM db_cursor INTO @TATSLACode, @TATSLAMatrix1Code, @TATSLAMatrix2Code, @TATSLAMatrix3Code, @WorkflowStatus, @SLA1FromDays, @SLA1ToDays, @SLA1Users, @SLA2FromDays, @SLA2ToDays, @SLA2Users, @SLA3FromDays, @SLA3ToDays,
		@SLA3Users,@Action

		END
	
		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPSaveSLAMatrixUDT]', 'Step 2', 0, 'Procedure Excution ompleted', 0, ''
END
