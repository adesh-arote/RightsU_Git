CREATE TYPE [dbo].[Acq_Deal_Rights] AS TABLE (
    [Acq_Deal_Rights_Code]    INT          NULL,
    [Right_Type]              CHAR (1)     NULL,
    [Actual_Right_Start_Date] DATETIME     NULL,
    [Actual_Right_End_Date]   DATETIME     NULL,
    [Is_Title_Language_Right] CHAR (1)     NULL,
    [Is_Exclusive]            CHAR (1)     NULL,
    [Acq_Deal_Code]           INT          NOT NULL,
    [Agreement_No]            VARCHAR (50) NULL,
    [SubCnt]                  INT          NULL,
    [DubCnt]                  INT          NULL,
    [Sum_of]                  INT          NULL,
    [Partition_Of]            INT          NULL);

