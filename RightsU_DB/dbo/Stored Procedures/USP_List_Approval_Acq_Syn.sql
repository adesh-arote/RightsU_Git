CREATE PROCEDURE [dbo].[USP_List_Approval_Acq_Syn]
(
	@StrSearch NVARCHAR(MAX),
	@PageNo Int,
	@OrderByCndition Varchar(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int Out,
	@User_Code INT
)
AS
-- =============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create DATE: 08-October-2014
-- Description:	AcqDeal List
-- Updated by : Priti D Phand
-- Date : 17 Nov 2014
-- Reason: Added one column which will return count of milestones added from function UFN_Get_MIlestone_Count
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Approval_Acq_Syn]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET FMTONLY OFF

		--DECLARE
		--@StrSearch NVARCHAR(MAX) = '',
		--@PageNo Int = 0,
		--@OrderByCndition Varchar(100) = '',
		--@IsPaging Varchar(2) = 'N',
		--@PageSize Int = 10,
		--@RecordCount Int,
		--@User_Code INT = 172

		SET @IsPaging = 'N'
		IF(@PageNo = 0)
			SET @PageNo = 1

		DECLARE @currentUserGroupCode INT = 0
		SELECT @currentUserGroupCode = Security_Group_Code FROM Users U WITH(NOLOCK) WHERE U.Users_Code = @User_Code
	
		IF(OBJECT_ID('TEMPDB..#ApprovalList') IS NOT NULL)
			DROP TABLE #ApprovalList

		CREATE TABLE #ApprovalList(
			RowNo INT,
			Deal_Code INT,
			Agreement_No VARCHAR(MAX),
			Vendor_Name NVARCHAR(MAX),
			Title_Name NVARCHAR(MAX),
			Last_Updated_Time DATETIME,
			[Type] VARCHAR(2)
		);

		/* --- START : Acquisition Deal --- */
		IF(LTRIM(RTRIM(@StrSearch)) <> '')
		BEGIN
			PRINT 'In Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT AD.Acq_Deal_Code, AD.Agreement_No, V.Vendor_Name, AD.Last_Updated_Time, 'A' AS [Type] FROM Acq_Deal AD WITH(NOLOCK)
			INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = ADM.Title_Code
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = AD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE AD.Is_Active = 'Y' AND AD.Deal_Workflow_Status like 'W%'
			AND (
				AD.Agreement_No LIKE '%' + @StrSearch + '%' OR
				V.Vendor_Name LIKE '%' + @StrSearch + '%' OR
				T.Title_name LIKE '%' + @StrSearch + '%'
			)
			ORDER BY AD.Last_Updated_Time DESC
		END
		ELSE
		BEGIN
			PRINT 'Not in Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT AD.Acq_Deal_Code, AD.Agreement_No, V.Vendor_Name, AD.Last_Updated_Time, 'A' AS [Type] FROM Acq_Deal AD WITH(NOLOCK)
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = AD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
			WHERE AD.Is_Active = 'Y' AND AD.Deal_Workflow_Status like 'W%'
			ORDER BY AD.Last_Updated_Time DESC
		END

		DELETE FROM #ApprovalList WHERE ISNULL(dbo.UFN_Get_Current_Approver_Code(30, Deal_Code), 0) != @currentUserGroupCode AND [Type] = 'A'
	
		;With UpdatedRowNo  As
		(
			SELECT Deal_Code,
			ROW_NUMBER() OVER (ORDER BY Last_Updated_Time DESC) AS RowNo
			FROM #ApprovalList WHERE [Type] = 'A'
		)
	
		UPDATE AL SET AL.RowNo = UR.RowNo FROM #ApprovalList AL
		INNER JOIN UpdatedRowNo UR WITH(NOLOCK) ON UR.Deal_Code = AL.Deal_Code AND AL.[Type] = 'A'

		SELECT @RecordCount = Count(*) From #ApprovalList WHERE  [Type] = 'A'
		If(@IsPaging = 'Y')
		BEGIN	
			DELETE FROM #ApprovalList WHERE (RowNo < (((@PageNo - 1) * @PageSize) + 1) Or RowNo > @PageNo * @PageSize)  AND [Type] = 'A'
		END	

		UPDATE #ApprovalList SET Title_Name = dbo.UFN_Get_Title(Deal_Code, 'A') WHERE  [Type] = 'A'
		/* --- END : Acquisition Deal --- */


		/* --- START : Syndication Deal --- */
		IF(LTRIM(RTRIM(@StrSearch)) <> '')
		BEGIN
			PRINT 'In Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT SD.Syn_Deal_Code, SD.Agreement_No, V.Vendor_Name, SD.Last_Updated_Time, 'S' AS [Type] FROM Syn_Deal SD WITH(NOLOCK)
			INNER JOIN Syn_Deal_Movie SDM WITH(NOLOCK) ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = SD.Vendor_Code
			INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = SDM.Title_Code
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = SD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE SD.Is_Active = 'Y' AND SD.Deal_Workflow_Status like 'W%'
			AND (
				SD.Agreement_No LIKE '%' + @StrSearch + '%' OR
				V.Vendor_Name LIKE '%' + @StrSearch + '%' OR
				T.Title_name LIKE '%' + @StrSearch + '%'
			)
			ORDER BY SD.Last_Updated_Time DESC
		END
		ELSE
		BEGIN
			PRINT 'Not in Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT SD.Syn_Deal_Code, SD.Agreement_No, V.Vendor_Name, SD.Last_Updated_Time, 'S' AS [Type] FROM Syn_Deal SD WITH(NOLOCK)
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = SD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = SD.Vendor_Code
			WHERE SD.Is_Active = 'Y' AND SD.Deal_Workflow_Status like 'W%'
			ORDER BY SD.Last_Updated_Time DESC
		END

		DELETE FROM #ApprovalList WHERE ISNULL(dbo.UFN_Get_Current_Approver_Code(35, Deal_Code), 0) != @currentUserGroupCode AND [Type] = 'S'
	
		;With UpdatedRowNo  As
		(
			SELECT Deal_Code,
			ROW_NUMBER() OVER (ORDER BY Last_Updated_Time DESC) AS RowNo
			FROM #ApprovalList WHERE [Type] = 'S'
		)
	
		UPDATE AL SET AL.RowNo = UR.RowNo FROM #ApprovalList AL
		INNER JOIN UpdatedRowNo UR WITH(NOLOCK) ON UR.Deal_Code = AL.Deal_Code AND AL.[Type] = 'S'

		SELECT @RecordCount = Count(*) From #ApprovalList WHERE  [Type] = 'S'
		If(@IsPaging = 'Y')
		BEGIN	
			DELETE FROM #ApprovalList WHERE (RowNo < (((@PageNo - 1) * @PageSize) + 1) Or RowNo > @PageNo * @PageSize)  AND [Type] = 'S'
		END	

		UPDATE #ApprovalList SET Title_Name = dbo.UFN_Get_Title(Deal_Code, 'S') WHERE  [Type] = 'S'
		/* --- END : Syndication Deal --- */


		/* --- START : Music Deal --- */
		IF(LTRIM(RTRIM(@StrSearch)) <> '')
		BEGIN
			PRINT 'In Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Title_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT MD.Music_Deal_Code, MD.Agreement_No, V.Vendor_Name, ML.Music_Label_Name, MD.Last_Updated_Time, 'M' AS [Type] FROM Music_Deal MD WITH(NOLOCK)
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = MD.Primary_Vendor_Code
			INNER JOIN Music_Label ML WITH(NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = MD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE MD.Deal_Workflow_Status like 'W%'
			AND (
				MD.Agreement_No LIKE '%' + @StrSearch + '%' OR
				V.Vendor_Name LIKE '%' + @StrSearch + '%' OR
				ML.Music_Label_Name LIKE '%' + @StrSearch + '%'
			)
			ORDER BY MD.Last_Updated_Time DESC
		END
		ELSE
		BEGIN
			PRINT 'Not in Search'
			INSERT INTO #ApprovalList(Deal_Code, Agreement_No, Vendor_Name, Title_Name, Last_Updated_Time, [Type])
			SELECT DISTINCT MD.Music_Deal_Code, MD.Agreement_No, V.Vendor_Name, ML.Music_Label_Name, MD.Last_Updated_Time, 'M' AS [Type] FROM Music_Deal MD WITH(NOLOCK)
			INNER JOIN Vendor V WITH(NOLOCK) ON V.Vendor_Code = MD.Primary_Vendor_Code
			INNER JOIN Music_Label ML WITH(NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code
			INNER JOIN Users_Business_Unit UBU WITH(NOLOCK) ON UBU.Business_Unit_Code = MD.Business_Unit_Code AND UBU.Users_Code = @User_Code
			WHERE MD.Deal_Workflow_Status like 'W%'
			ORDER BY MD.Last_Updated_Time DESC
		END

		DELETE FROM #ApprovalList WHERE ISNULL(dbo.UFN_Get_Current_Approver_Code(163, Deal_Code), 0) != @currentUserGroupCode AND [Type] = 'M'
	
		;With UpdatedRowNo  As
		(
			SELECT Deal_Code,
			ROW_NUMBER() OVER (ORDER BY Last_Updated_Time DESC) AS RowNo
			FROM #ApprovalList WHERE [Type] = 'M'
		)
	
		UPDATE AL SET AL.RowNo = UR.RowNo FROM #ApprovalList AL
		INNER JOIN UpdatedRowNo UR WITH(NOLOCK) ON UR.Deal_Code = AL.Deal_Code AND AL.[Type] = 'M'

		SELECT @RecordCount = Count(*) From #ApprovalList WHERE  [Type] = 'M'
		If(@IsPaging = 'Y')
		BEGIN	
			DELETE FROM #ApprovalList WHERE (RowNo < (((@PageNo - 1) * @PageSize) + 1) Or RowNo > @PageNo * @PageSize)  AND [Type] = 'M'
		END	
		/* --- END : Music Deal --- */

		SELECT Deal_Code, Vendor_Name, Title_Name, Agreement_No, CONVERT(VARCHAR(11), Last_Updated_Time,106) AS Last_Updated_Time, [Type] 
		FROM #ApprovalList ORDER BY Last_Updated_Time DESC
	
		IF OBJECT_ID('tempdb..#ApprovalList') IS NOT NULL DROP TABLE #ApprovalList
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Approval_Acq_Syn]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END


