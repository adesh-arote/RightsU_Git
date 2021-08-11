CREATE PROCEDURE USP_IPR_IntDom_Report
(
	@Trademark NVARCHAR(MAX),
	@Registration_Date NVARCHAR(MAX),
	@Renewed_Until NVARCHAR(MAX),
	@Organization NVARCHAR(MAX),
	@Class  NVARCHAR(MAX),
	@IntDom CHAR(1) = 'D'
)
AS
BEGIN
	--DECLARE
	--@Trademark NVARCHAR(MAX) = 'SPECIAL 26',
	--@Registration_Date NVARCHAR(MAX) = '21-Oct-2011',
	--@Renewed_Until NVARCHAR(MAX)= '13-Jul-2008',
	--@Organization NVARCHAR(MAX)= 'Shogakukan - Shueisha Productions Co. Ltd',
	--@Class NVARCHAR(MAX)= '02',
	--@IntDom CHAR(1) = 'D'

	SELECT 
	  IR.Trademark_No,
	  IR.Trademark,
	  IT.Type AS 'Trademark_Type',

	  STUFF((
				SELECT DISTINCT ', ' + BU.Business_Unit_Name
				FROM IPR_Rep_Business_Unit A inner join Business_Unit BU ON A.Business_Unit_Code = BU.Business_Unit_Code
				WHERE A.IPR_Rep_Code = IR.IPR_Rep_Code
				FOR XML PATH('')
	  ), 1, 1, '') AS 'Content_Category',
	   STUFF((
				SELECT DISTINCT ', ' + BU.Channel_Name
				FROM IPR_Rep_Channel A inner join Channel BU ON A.Channel_Code = BU.Channel_Code
				WHERE A.IPR_Rep_Code = IR.IPR_Rep_Code
				FOR XML PATH('')
	  ), 1, 1, '') AS 'Channel',
	  IR.Application_No,
	  IR.Application_Date,
	  IC.IPR_Country_Name,
	  IR.Date_Of_Use,
	  IR.Date_Of_Actual_Use,
	  IAS.App_Status AS 'Application_Status',
	  IR.Renewed_Until,
	  IE.Entity AS 'Applicant',
	  IR.Trademark_Attorney,
	  IR.International_Trademark_Attorney,
	  IR.Class_Comments AS 'Goods_Description',
		STUFF((
				SELECT DISTINCT ', ' +  C.Description from IPR_REP_CLASS A
				INNER JOIN IPR_CLASS B ON A.IPR_Class_Code = B.IPR_Class_Code
				INNER JOIN IPR_CLASS C ON C.IPR_Class_Code = B.Parent_Class_Code
				WHERE A.IPR_Rep_Code = IR.IPR_Rep_Code 

				FOR XML PATH('')
	  ), 1, 1, '') AS 'Class'
	FROM IPR_Rep IR
		INNER JOIN IPR_TYPE IT ON IR.IPR_Type_Code = IT.IPR_Type_Code
		INNER JOIN IPR_Country IC ON IC.IPR_Country_Code = IR.Country_Code
		INNER JOIN IPR_APP_STATUS IAS ON IAS.IPR_App_Status_Code = IR.Application_Status_Code
		INNER JOIN IPR_ENTITY IE ON IE.IPR_Entity_Code = IR.Applicant_Code
	WHERE
		IR.IPR_For = @IntDom
		AND(
			IR.Trademark like '%'+ @Trademark +'%'
			OR IR.Application_Date =  CAST(@Registration_Date AS DATETIME)
			OR IR.Renewed_Until = CAST(@Renewed_Until AS DATETIME)
			OR IE.Entity LIKE '%'+ @Organization +'%'
			OR IR.IPR_Rep_Code IN ( SELECT DISTINCT a.IPR_Rep_Code from IPR_REP_CLASS A
				INNER JOIN IPR_CLASS B ON A.IPR_Class_Code = B.IPR_Class_Code
				INNER JOIN IPR_CLASS C ON C.IPR_Class_Code = B.Parent_Class_Code
				WHERE C.Description =  @Class
			)
		)
END


