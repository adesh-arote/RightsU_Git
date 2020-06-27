CREATE TABLE [dbo].[Talent] (
    [Talent_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Talent_Name]       NVARCHAR (100) NOT NULL,
    [Gender]            NCHAR (1)      NULL,
    [Inserted_On]       DATETIME       NULL,
    [Inserted_By]       INT            NULL,
    [Lock_Time]         DATETIME       NULL,
    [Last_Updated_Time] DATETIME       NULL,
    [Last_Action_By]    INT            NULL,
    [Is_Active]         CHAR (1)       CONSTRAINT [DF_Talent_Is_Active] DEFAULT ('Y') NULL,
    CONSTRAINT [PK_Talent] PRIMARY KEY CLUSTERED ([Talent_Code] ASC)
);








GO
CREATE TRIGGER [dbo].[Trg_Talent_UPD]    
ON [dbo].[Talent]      
AFTER UPDATE
AS  
 Declare @Talent_Code int
 Declare @Talent_Name NVARCHAR(200)
 
 Declare @dTalent_Code int
 Declare @dTalent_Name NVARCHAR(200)
  
 SET NOCOUNT ON    
 Declare @Count as int    
 Select @count =  0
 
 
BEGIN  
	Select  
		@Talent_Code=Talent_Code,
		@Talent_Name=Talent_Name
	from INSERTED I
 
    Select  
		@dTalent_Code=Talent_Code,
		@dTalent_Name=Talent_Name
	from DELETED D
  
  
    if update(Talent_name)	
	  if @Talent_Name<>@dTalent_Name
		Select @count =  @count + 1
		
 
   --select @count a 		
   if(@count > 0)			
	 UPDATE Title SET original_title=@Talent_Name,Title_Name=@Talent_Name,synopsis=@Talent_Name 
	 WHERE reference_Key=@Talent_Code AND Reference_Flag = 'T'

            
    
END
