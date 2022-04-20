SELECT [Scehma]=schema_name(o.schema_id), o.Name, o.type 
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON o.object_id = m.object_id
WHERE m.definition like '%CUR%'


MHConsumptionRequest		MHCR
MHMusicRequest		MHMUR
MHMovieRequest		MHMOR
MHCueSheetSubmit		MHCSS

sp_helptext USPMHMailNotification


Select * from email_config

--Update email_config set Allow_Config = 'Y' where Email_Type like 'MH%'