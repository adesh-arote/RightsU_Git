IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'Is_AllowMultiBUsyndealreport')	
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,IsActive)
	VALUES('Is_AllowMultiBUsyndealreport','Y','Y')
END

IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'Is_AllowMultiBUacqdealreport')	
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,IsActive)
	VALUES('Is_AllowMultiBUacqdealreport','Y','Y')
END

IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'Is_AllowMultiBUsyndeal')	
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,IsActive)
	VALUES('Is_AllowMultiBUsyndeal','Y','Y')
END

IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'Is_AllowMultiBUacqdeal')	
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,IsActive)
	VALUES('Is_AllowMultiBUacqdeal','Y','Y')
END
