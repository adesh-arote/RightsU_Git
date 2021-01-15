IF NOT EXISTS(SELECT TOP 1 * from System_Versions where Version_No = '1.02.04')
BEGIN
	INSERT INTO System_Versions VALUES('1.02.04','MusicHub',GETDATE(),'First test version MusicHub')
END
