CREATE FUNCTION [dbo].[UFN_Get_Channels_Beam]          
(          
 @Channel_Name NVARCHAR(MAX)
)           
-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 14 Nov 2014
-- Description:	Get Channel Beam Call From USP_
-- =============================================

RETURNS NVARCHAR(MAX)          
AS          
BEGIN           
        -- Declare return variable here           
        DECLARE  @retChannel_Beam AS NVARCHAR(MAX)          
        SET @retChannel_Beam = ''          
                  
  DECLARE @ChannelNames AS NVARCHAR(MAX)          
  SET @ChannelNames = ''          
           
  SELECT @ChannelNames += C.channel_name + ', '  FROM Channel C           
  WHERE C.channel_id = @Channel_Name          
            
     set @retChannel_Beam = SUBSTRING(@ChannelNames,0,LEN(@ChannelNames))          
                   
RETURN @retChannel_Beam          
               
END