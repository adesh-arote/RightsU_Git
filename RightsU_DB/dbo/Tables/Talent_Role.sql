CREATE TABLE [dbo].[Talent_Role] (
    [Talent_Role_Code] INT IDENTITY (1, 1) NOT NULL,
    [Talent_Code]      INT NULL,
    [Role_Code]        INT NULL,
    CONSTRAINT [PK_Talent_Role] PRIMARY KEY CLUSTERED ([Talent_Role_Code] ASC),
    CONSTRAINT [FK_Talent_Role_Role] FOREIGN KEY ([Role_Code]) REFERENCES [dbo].[Role] ([Role_Code]),
    CONSTRAINT [FK_Talent_Role_Talent] FOREIGN KEY ([Talent_Code]) REFERENCES [dbo].[Talent] ([Talent_Code])
);




GO
CREATE TRIGGER [dbo].[Trg_Talent_Role_Del]      
ON [dbo].[Talent_Role]
AFTER DELETE
AS   
 DECLARE @dtalent_role_code INT, @dtalent_code INT, @drole_code INT
 ,@Deal_Type_Code INT, @Talent_Name  NVARCHAR(250)
  
 SET NOCOUNT ON    
 Declare @Count as int    
 Select @count =  0 
 
BEGIN  
	
	--DELETE tit
	--FROM Deleted tr
	--INNER JOIN Talent as t ON t.Talent_Code = tr.Talent_Code
	--INNER JOIN Role as r ON tr.Role_Code = R.Role_Code
	--INNER JOIn Title tit ON r.Deal_Type_Code = tit.Deal_Type_Code AND tit.Original_Title = t.Talent_Name 
	--		AND tit.Reference_Flag = 'T' AND tit.Reference_Key = t.Talent_Code
	--WHERE R.Role_Type = 'T' AND ISNULL(R.Deal_Type_Code, 0) <> 0 

	SELECT
	@dtalent_role_code=talent_role_code,
	@dtalent_code=T.talent_code,
	@drole_code=R.role_code,
	@Deal_Type_Code=R.Deal_Type_Code,
    @Talent_Name= talent_name    
	FROM DELETED D
    INNER JOIN [Role] as R ON D.role_code=R.role_code  
	INNER JOIN Talent as T ON T.talent_code=D.talent_code
	WHERE R.role_type='T' AND ISNULL(R.Deal_Type_Code,0)<>0
   
	--IF NOT EXISTS (
	--   SELECT TOP 1 * FROM Talent_Role tr 
	--   INNER JOIN Role r ON r.Role_Code = tr.Role_Code WHERE r.Deal_Type_Code = @Deal_Type_Code AND talent_code = @dtalent_code
	--)
	IF NOT EXISTS (
	   SELECT TOP 1 * FROM Talent_Role  
	   WHERE Role_Code = @drole_code AND talent_code = @dtalent_code
	)
	BEGIN	
		DELETE FROM Title WHERE Deal_Type_Code = @Deal_Type_Code AND original_title = @Talent_Name	 AND Reference_Flag = 'T'
	END 
END

GO
CREATE TRIGGER [dbo].[Trg_Talent_Role_INS]      
ON [dbo].[Talent_Role]        
AFTER INSERT  
AS    
 DECLARE @Deal_Type_Code INT, @Talent_Name  NVARCHAR(250),@Talent_Code INT    
 SET NOCOUNT ON         
BEGIN    
 
 SELECT   
   @Deal_Type_Code=R.Deal_Type_Code,
   @Talent_Name= talent_name,
   @Talent_Code = I.talent_code
 FROM INSERTED I
 INNER JOIN [Role] as R ON I.role_code=R.role_code  
 INNER JOIN Talent as T ON T.talent_code=I.talent_code
 WHERE R.role_type='T' AND ISNULL(R.Deal_Type_Code,0)<>0

 IF(ISNULL(@Talent_Name,'')<>'')
 BEGIN
	IF NOT EXISTS (
	   SELECT TOP 1 original_title 
	   FROM Title WHERE original_title=@Talent_Name AND Deal_Type_Code=@Deal_Type_Code
	)
	 INSERT INTO Title(original_title,Title_Name,synopsis,Deal_Type_Code,inserted_on,is_active,reference_Key,reference_flag)  
	 VALUES (
		@Talent_Name,@Talent_Name,@Talent_Name,@Deal_Type_Code,GETDATE(),'Y',@Talent_Code,'T'
	 )    
 END            
      
END
