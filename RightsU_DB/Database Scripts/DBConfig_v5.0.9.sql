if not exists(select * from System_Module where module_code = 248)
begin
INSERT INTO System_Module VALUES(248,'Deal Status Report','EZ',40,'N','Reports/DealStatusReport','mainframe','sub','N','Y')
end

GO 

if not exists(select * from System_Module_Right where module_code = 248 and right_code = 7)
begin
INSERT INTO System_Module_Right VALUES(248,7)
end

GO
alter table System_Parameter_New
add Client_Name NVARCHAR(MAX)

go
