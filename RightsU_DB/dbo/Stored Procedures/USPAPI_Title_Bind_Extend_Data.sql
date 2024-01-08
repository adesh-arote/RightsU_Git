CREATE PROCEDURE [dbo].[USPAPI_Title_Bind_Extend_Data]
	@Title_Code INT
AS
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPAPI_Title_Bind_Extend_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
		select distinct 
				EC.Columns_Name
				,Ec.Columns_Code
				,EC.Control_Type
				,EC.Is_Ref
				,EC.Is_Defined_Values
				,EC.Is_Multiple_Select
				,EC.Ref_Table
				,EC.Ref_Display_Field
				,EC.Ref_Value_Field
				,MEC.Columns_Value_Code
				--,case when MEC.Columns_Value_Code IS NULL THEN MECD.Columns_Value_Code ELSE 1 END as 'Columns_Value_Code1'
				,[dbo].[UFN_Get_Column_Value_Data] (MEC.Map_Extended_Columns_Code)as 'Columns_Value_Code1'
				, CASE WHEN (Control_Type = 'DATE' OR Control_Type = 'INT')  THEN Column_Value ELSE 
				[dbo].[UFN_Get_Column_Name_Data]  
				( 
						case when  ISNULL(MEC.Columns_Value_Code,0) = 0 
							THEN Ec.Columns_Code 
							--ELSE MEC.Columns_Code 
							ELSE MEC.Columns_Value_Code
						END
						,EC.Is_Defined_Values
						,MEC.Record_Code
						,MEC.Map_Extended_Columns_Code
				) END as Name
				,MEC.Map_Extended_Columns_Code
				,MEC.Column_Value
				,'Y' as IsDelete 
				,(
					select EG.Extended_Group_Code FROM Extended_Group_Config EGC
					INNER JOIN Extended_Group EG ON EG.Extended_Group_Code = EGC.Extended_Group_Code					
					Where Columns_Code = EC.Columns_Code AND EG.Module_Code=27 AND EG.IsActive='Y'
				) as Extended_Group_Code
				,(
					select EG.Group_Name FROM Extended_Group_Config EGC
					INNER JOIN Extended_Group EG ON EG.Extended_Group_Code = EGC.Extended_Group_Code					
					Where Columns_Code = EC.Columns_Code AND EG.Module_Code=27 AND EG.IsActive='Y'
				) as Group_Name
		from Map_Extended_Columns MEC (NOLOCK)
		inner join Extended_Columns EC (NOLOCK) on MEC.Columns_Code = EC.Columns_Code AND MEC.Record_Code = @Title_Code
		LEFT join Extended_Columns_Value ECV (NOLOCK) on EC.Columns_Code = ECV.Columns_Code
		LEFT JOIN Map_Extended_Columns_Details MECD (NOLOCK) on MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPAPI_Title_Bind_Extend_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''


	