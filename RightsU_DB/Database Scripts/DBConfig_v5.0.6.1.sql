IF NOT EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_name = 'Is_Acq_Syn_Material_MultiTitle' )
BEGIN
	INSERT INTO System_Parameter_New (Parameter_Name,Parameter_Value, IsActive)
	SELECT 'Is_Acq_Syn_Material_MultiTitle' ,'Y','Y'
END

IF NOT EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_name = 'Is_Acq_Confirming_Party' )
BEGIN
	INSERT INTO System_Parameter_New (Parameter_Name,Parameter_Value, IsActive)
	SELECT 'Is_Acq_Confirming_Party' ,'Y','Y'
END

IF NOT EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_name = 'Is_AcqSyn_Type_Of_Film' )
BEGIN
	INSERT INTO System_Parameter_New (Parameter_Name,Parameter_Value, IsActive)
	SELECT 'Is_AcqSyn_Type_Of_Film' ,'Y','Y'
END

IF NOT EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_name = 'Is_Acq_Syn_CoExclusive' )
BEGIN
	INSERT INTO System_Parameter_New (Parameter_Name,Parameter_Value, IsActive)
	SELECT 'Is_Acq_Syn_CoExclusive' ,'Y','Y'
END

IF NOT EXISTS (SELECT * FROM System_Parameter_New WHERE Parameter_name = 'Is_Acq_rights_delay_validation' )
BEGIN
	INSERT INTO System_Parameter_New (Parameter_Name,Parameter_Value, IsActive)
	SELECT 'Is_Acq_rights_delay_validation' ,'Y','Y'
END

IF	EXISTS(SELECT TOP 1 * FROM  Extended_Columns WHERE Columns_Name = 'Creative Producer')
BEGIN
	INSERT INTO Extended_Columns (Columns_Name,Control_Type,Is_Ref,Is_Defined_Values,Is_Multiple_Select,Ref_Table,Ref_Display_Field,Ref_Value_Field,Additional_Condition)
	VALUES ('Creative Producer', 'DDL', 'Y','N','Y','TALENT','Talent_Name',	'Talent_Code',	4)
END

IF	EXISTS(SELECT TOP 1 * FROM  Role WHERE Role_Name = 'Name of Broker/Purchase Agent')
BEGIN
	INSERT INTO Role(Role_Name,Role_Type,Is_Rate_Card,Last_Action_By,Lock_Time,Last_Updated_Time,Deal_Type_Code)
	VALUES ('Name of Broker/Purchase Agent','V,S','N',NULL,NULL,NULL,NULL)
END