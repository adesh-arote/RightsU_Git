CREATE TYPE [dbo].[DeliveryTracking_UDT] AS TABLE (
    [AL_Material_Tracking_Code] NVARCHAR (4000) NULL,
    [PO_Status]                 NVARCHAR (4000) NULL,
    [Delivery_Date]             VARCHAR (100)   NULL,
    [Poster]                    NVARCHAR (200)  NULL,
    [Still]                     NVARCHAR (200)  NULL,
    [Trailer]                   VARCHAR (100)   NULL,
    [Edited_Poster]             VARCHAR (100)   NULL,
    [Edited_Still]              NVARCHAR (2000) NULL);

