
CREATE  PROCEDURE [dbo].[USP_Bind_Extend_Column_Grid]
(

	@Title_Code INT
)	
AS


BEGIN	
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
			, [dbo].[UFN_Get_Column_Name_Data]  
			( 
					case when  ISNULL(MEC.Columns_Value_Code,0) = 0 
						THEN Ec.Columns_Code 
						--ELSE MEC.Columns_Code 
						ELSE MEC.Columns_Value_Code
					END
					,EC.Is_Defined_Values
					,MEC.Record_Code
					,MEC.Map_Extended_Columns_Code
			) as  Name
			,MEC.Map_Extended_Columns_Code
			,MEC.Column_Value
			,'Y' as IsDelete 
	from Map_Extended_Columns MEC
	inner join Extended_Columns EC on MEC.Columns_Code = EC.Columns_Code AND MEC.Record_Code = @Title_Code
	LEFT join Extended_Columns_Value ECV on EC.Columns_Code = ECV.Columns_Code
	LEFT JOIN Map_Extended_Columns_Details MECD on MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
END



--exec USP_Bind_Extend_Column_Grid 2921
