
IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'P&ARightsReport')
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Channel_Code,Type,isactive,Description,Is_System_Admin)
	VALUES('P&ARightsReport','\Download',Getdate(),0,'',Getdate(),247,'','U','Y','Acquisition','')
END
GO

