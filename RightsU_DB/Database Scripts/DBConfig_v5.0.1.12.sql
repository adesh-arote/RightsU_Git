--///////////////// FILE DB CONFIG v5.0.1.12

IF NOT EXISTS(SELECT TOP 1 * from System_Versions where Version_No = '1.02.04')
BEGIN
	INSERT INTO System_Versions VALUES('1.02.04','MusicHub',GETDATE(),'First test version MusicHub')
END


IF NOT EXISTS (Select TOP 1 * from System_Parameter_New Where Parameter_Name = 'P&ARightsReport')
BEGIN
	INSERT INTO System_parameter_new(Parameter_Name,Parameter_Value,Inserted_On,Inserted_By,Lock_Time,Last_Updated_Time,Last_Action_By,Channel_Code,Type,isactive,Description,Is_System_Admin)
	VALUES('P&ARightsReport','\Download',Getdate(),0,'',Getdate(),247,'','U','Y','Acquisition','')
END
GO

---------- Title Import Utility changes
