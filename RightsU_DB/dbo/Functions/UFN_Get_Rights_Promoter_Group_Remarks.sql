CREATE Function [dbo].[UFN_Get_Rights_Promoter_Group_Remarks](@Rights_Code Int,@Type char(1),@Deal_Type CHAR(1))        
Returns NVARCHAR(MAX)        
AS        
-- =============================================        
-- Author:  Vipul Surve        
-- Create DATE: 13-September-2017        
-- Description: Return Promter_Groups and Promoter_Remarks added for Rights        
-- =============================================        
BEGIN        
        
 DECLARE @RetVal NVARCHAR(MAX) = ''       
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)      
 IF(@Deal_Type = 'A')    
 BEGIN    
 IF(@Type = 'P')        
 BEGIN        
 DECLARE  @Promoter_Group TABLE       
  (      
  ROWID INT IDENTITY,      
  Acq_Deal_Rights_Promoter_Code INT      
   )      
      
  INSERT INTO @Promoter_Group(Acq_Deal_Rights_Promoter_Code)       
  SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code =@Rights_Code      
      
  DECLARE @MAXID INT, @Counter INT,@Acq_Deal_Rights_Promoter_Code INT        
      
  SET @COUNTER = 1      
  SELECT @MAXID = COUNT(*) FROM @Promoter_Group      
      
    WHILE (@COUNTER <= @MAXID)      
 BEGIN      
   SELECT @Acq_Deal_Rights_Promoter_Code = Acq_Deal_Rights_Promoter_Code from @Promoter_Group where ROWID = @Counter      
   SET @RetVal += ' '+CAST(@Counter AS nvarchar) +'. '      
      SELECT @RetVal = @RetVal  +  Hierarchy_Name + ', ' FROM Promoter_Group WHERE Promoter_Group_Code IN (        
      SELECT ADRPG.Promoter_Group_Code FROM Acq_Deal_Rights_Promoter_Group ADRPG WHERE ADRPG.Acq_Deal_Rights_Promoter_Code = @Acq_Deal_Rights_Promoter_Code)      
   SET @COUNTER = @COUNTER + 1      
   IF (RIGHT(RTRIM(@RetVal), 1) = ',')      
    set @RetVal = LEFT(@RetVal, LEN(@RetVal) - 1)      
      
   SET @RetVal += @NewLineChar      
 END      
  END        
 ELSE        
 BEGIN        
 Declare  @Promoter_Remarks TABLE       
 (      
  ROWID INT IDENTITY,      
  Acq_Deal_Rights_Promoter_Code INT      
 )      
      
   INSERT INTO @Promoter_Remarks(Acq_Deal_Rights_Promoter_Code)       
   SELECT Acq_Deal_Rights_Promoter_Code FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code =@Rights_Code      
      
   DECLARE @MAXIDR INT, @COUNTERR INT,@Acq_Deal_Rights_Promoter_Codes INT        
      
      
   SET @COUNTERR = 1      
   SELECT @MAXIDR = COUNT(*) FROM @Promoter_Remarks      
      
    WHILE (@COUNTERR <= @MAXIDR)      
    BEGIN      
     SELECT @Acq_Deal_Rights_Promoter_Codes = Acq_Deal_Rights_Promoter_Code FROM @Promoter_Remarks WHERE ROWID = @COUNTERR      
     SET @RetVal += ' '+CAST(@COUNTERR AS NVARCHAR) +'. '      
     SELECT @RetVal = @RetVal  +  Promoter_Remark_Desc + ', ' FROM Promoter_Remarks WHERE Promoter_Remarks_Code IN (        
     SELECT ADRPR.Promoter_Remarks_Code FROM Acq_Deal_Rights_Promoter_Remarks ADRPR WHERE ADRPR.Acq_Deal_Rights_Promoter_Code = @Acq_Deal_Rights_Promoter_Codes)      
     SET @COUNTERR = @COUNTERR + 1       
     IF (RIGHT(RTRIM(@RetVal), 1) = ',')      
      SET @RetVal = LEFT(@RetVal, LEN(@RetVal) - 1)      
      
     SET @RetVal += @NewLineChar      
    END      
 END         
 END    
 ELSE    
 BEGIN    
  IF(@Type = 'P')        
 BEGIN        
 DECLARE  @Promoter_GroupS TABLE       
  (      
  ROWID INT IDENTITY,      
  Syn_Deal_Rights_Promoter_Code INT      
   )      
      
  INSERT INTO @Promoter_GroupS(Syn_Deal_Rights_Promoter_Code)       
  SELECT Syn_Deal_Rights_Promoter_Code FROM Syn_Deal_Rights_Promoter WHERE Syn_Deal_Rights_Code =@Rights_Code      
      
  DECLARE @MAXIDS INT, @COUNTERA INT,@Syn_Deal_Rights_Promoter_Code INT        
      
  SET @COUNTERA = 1      
  SELECT @MAXIDS = COUNT(*) FROM @Promoter_GroupS      
      
    WHILE (@COUNTERA <= @MAXIDS)      
 BEGIN     
   SELECT @Syn_Deal_Rights_Promoter_Code = Syn_Deal_Rights_Promoter_Code from @Promoter_GroupS where ROWID = @COUNTERA      
   SET @RetVal += ' '+CAST(@COUNTERA AS nvarchar) +'. '      
      SELECT @RetVal = @RetVal  +  Hierarchy_Name + ', ' FROM Promoter_Group WHERE Promoter_Group_Code IN (        
      SELECT SDRPG.Promoter_Group_Code FROM Syn_Deal_Rights_Promoter_Group SDRPG WHERE SDRPG.Syn_Deal_Rights_Promoter_Code = @Syn_Deal_Rights_Promoter_Code)      
   SET @COUNTERA = @COUNTERA + 1      
   IF (RIGHT(RTRIM(@RetVal), 1) = ',')      
    set @RetVal = LEFT(@RetVal, LEN(@RetVal) - 1)      
      
   SET @RetVal += @NewLineChar      
 END      
  END        
 ELSE  -----------------------------      
 BEGIN        
 Declare  @Promoter_RemarksS TABLE       
 (      
  ROWID INT IDENTITY,      
  Syn_Deal_Rights_Promoter_Code INT      
 )      
      
   INSERT INTO @Promoter_RemarksS(Syn_Deal_Rights_Promoter_Code)       
   SELECT Syn_Deal_Rights_Promoter_Code FROM Syn_Deal_Rights_Promoter WHERE Syn_Deal_Rights_Code =@Rights_Code      
      
   DECLARE @MAXIDRS INT, @COUNTERRS INT,@Syn_Deal_Rights_Promoter_Codes INT        
      
      
   SET @COUNTERRS = 1      
   SELECT @MAXIDRS = COUNT(*) FROM @Promoter_RemarksS      
      
    WHILE (@COUNTERRS <= @MAXIDRS)      
    BEGIN      
     SELECT @Syn_Deal_Rights_Promoter_Codes = Syn_Deal_Rights_Promoter_Code FROM @Promoter_RemarksS WHERE ROWID = @COUNTERRS      
     SET @RetVal += ' '+CAST(@COUNTERRS AS NVARCHAR) +'. '      
     SELECT @RetVal = @RetVal  +  Promoter_Remark_Desc + ', ' FROM Promoter_Remarks WHERE Promoter_Remarks_Code IN (        
     SELECT SDRPR.Promoter_Remarks_Code FROM Syn_Deal_Rights_Promoter_Remarks SDRPR WHERE SDRPR.Syn_Deal_Rights_Promoter_Code = @Syn_Deal_Rights_Promoter_Codes)      
     SET @COUNTERRS = @COUNTERRS + 1       
     IF (RIGHT(RTRIM(@RetVal), 1) = ',')      
      SET @RetVal = LEFT(@RetVal, LEN(@RetVal) - 1)      
      
     SET @RetVal += @NewLineChar      
    END      
 END    
 END    
 RETURN Substring(@RetVal, 1, Len(@RetVal))        
         
END


