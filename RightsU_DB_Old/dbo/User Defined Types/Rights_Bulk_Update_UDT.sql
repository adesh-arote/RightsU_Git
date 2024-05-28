--CREATE TYPE [dbo].[Rights_Bulk_Update_UDT]
--	FROM varchar(11) NOT NULL


	--CREATE TYPE [dbo].[Rights_Bulk_Update_UDT] AS TABLE (
 --   [Right_Codes] VARCHAR (MAX)  NULL,
	--[Change_For] CHAR (2)  NULL,
	--[Action_For] CHAR (1)  NULL,
	--[Start_Date] DATE NULL,
	--[End_Date] DATE NULL,
	--[Term] VARCHAR (12) NULL,
	--[Milestone_Type_Code] VARCHAR (10) NULL,
	--[Milestone_No_Of_Unit] VARCHAR (10) NULL,
	--[Milestone_Unit_Type] VARCHAR (10) NULL, 
	--[Rights_Type] CHAR (1)  NULL,
	--[Platform_Codes] VARCHAR (MAX)  NULL,
	--[Country_Codes] VARCHAR (MAX)  NULL,
	--[Territory_Codes] VARCHAR (MAX)  NULL,
	--[Sub_Lan_Codes] VARCHAR (MAX)  NULL,
	--[Sub_Lan_Grp_Codes] VARCHAR (MAX)  NULL,
	--[Dub_Lan_Codes] VARCHAR (MAX)  NULL,
	--[Dub_Lan_Grp_Codes] VARCHAR (MAX)  NULL,
	--[Is_Exclusive] VARCHAR (5)  NULL,
	--[Is_Title_Language] VARCHAR (5)  NULL,
	--[Sub_licensing_Code] VARCHAR (10) NULL,
	--[Is_Sublicensing] CHAR (1) NULL,
	--[Is_Tentative] CHAR (1) NULL
	--);
	CREATE TYPE [dbo].[Rights_Bulk_Update_UDT] AS TABLE (
    [Right_Codes] VARCHAR (MAX)  NULL,
	[Change_For] CHAR (2)  NULL,
	[Action_For] CHAR (1)  NULL,
	[Start_Date] DATE NULL,
	[End_Date] DATE NULL,
	[Term] VARCHAR (12) NULL,
	[Milestone_Type_Code] VARCHAR (10) NULL,
	[Milestone_No_Of_Unit] VARCHAR (10) NULL,
	[Milestone_Unit_Type] VARCHAR (10) NULL, 
	[Rights_Type] CHAR (1)  NULL,
	[Codes] VARCHAR (MAX)  NULL,
	[Is_Exclusive] VARCHAR (5)  NULL,
	[Is_Title_Language] VARCHAR (5)  NULL,
	[Is_Tentative] CHAR (1) NULL
	);