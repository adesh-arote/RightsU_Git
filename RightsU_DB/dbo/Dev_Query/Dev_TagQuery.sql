
IF NOT EXISTS (Select TOP 1 * from System_Right Where Right_Name = 'Download')
BEGIN
	Insert Into System_Right(Right_Name, Right_Code) Values('Download',168)
END

IF NOT EXISTS (Select TOP 1 * from System_Module_Right Where Module_Code = 149 AND Right_Code = 168)
BEGIN
	Insert Into System_Module_Right(Module_Code, Right_Code) Values(149,168)
END
GO




