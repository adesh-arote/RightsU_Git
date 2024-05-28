CREATE PROCEDURE [dbo].[Usp_Drop_Create_Tables]
AS
BEGIN
	BEGIN TRY

		/****** Object:  Table [dbo].[Title_Release]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title_Release')
		BEGIN
		DROP TABLE [dbo].Title_Release
		END
		/****** Object:  Table [dbo].[Title_Release_Platforms]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title_Release_Platforms')
		BEGIN
		DROP TABLE [dbo].Title_Release_Platforms
		END
		/****** Object:  Table [dbo].[Title_Release_Region]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title_Release_Region')
		BEGIN
		DROP TABLE [dbo].Title_Release_Region
		END
		/****** Object:  Table [dbo].[Title_Talent]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title_Talent')
		BEGIN
		DROP TABLE [dbo].[Title_Talent]
		END
		/****** Object:  Table [dbo].[Title_Geners]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title_Geners')
		BEGIN
		DROP TABLE [dbo].[Title_Geners]
		END
		/****** Object:  Table [dbo].[Title]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Title')
		BEGIN
		DROP TABLE [dbo].[Title]
		END
		/****** Object:  Table [dbo].[Territory_Details]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Territory_Details')
		BEGIN
		DROP TABLE [dbo].[Territory_Details]
		END
		/****** Object:  Table [dbo].[Territory]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Territory')
		BEGIN
		DROP TABLE [dbo].[Territory]
		END
		/****** Object:  Table [dbo].[Talent_Role]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Talent_Role')
		BEGIN
		DROP TABLE [dbo].[Talent_Role]
		END
		/****** Object:  Table [dbo].[Talent]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Talent')
		BEGIN
		DROP TABLE [dbo].[Talent]
		END
		/****** Object:  Table [dbo].[System_Parameter_New]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='System_Parameter_New')
		BEGIN
		DROP TABLE [dbo].[System_Parameter_New]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights_Title]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights_Title')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights_Title]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights_Territory]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights_Territory')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights_Territory]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights_Subtitling')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights_Subtitling]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights_Platform')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights_Platform]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights_Dubbing]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights_Dubbing')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights_Dubbing]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Rights]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Rights')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Rights]
		END
		/****** Object:  Table [dbo].[Syn_Deal_Movie]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal_Movie')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal_Movie]
		END
		/****** Object:  Table [dbo].[Syn_Deal]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Deal')
		BEGIN
		DROP TABLE [dbo].[Syn_Deal]
		END
		/****** Object:  Table [dbo].[Syn_Acq_Mapping]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Syn_Acq_Mapping')
		BEGIN
		DROP TABLE [dbo].[Syn_Acq_Mapping]
		END
		/****** Object:  Table [dbo].[Sub_License]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Sub_License')
		BEGIN
		DROP TABLE [dbo].[Sub_License]
		END
		/****** Object:  Table [dbo].[Role]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Role')
		BEGIN
		DROP TABLE [dbo].[Role]
		END
		/****** Object:  Table [dbo].[Platform]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Platform')
		BEGIN
		DROP TABLE [dbo].[Platform]
		END
		/****** Object:  Table [dbo].[Language_Group_Details]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Language_Group_Details')
		BEGIN
		DROP TABLE [dbo].[Language_Group_Details]
		END
		/****** Object:  Table [dbo].[Language_Group]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Language_Group')
		BEGIN
		DROP TABLE [dbo].[Language_Group]
		END
		/****** Object:  Table [dbo].[Language]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Language')
		BEGIN
		DROP TABLE [dbo].[Language]
		END
		/****** Object:  Table [dbo].[Genres]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Genres')
		BEGIN
		DROP TABLE [dbo].[Genres]
		END
		/****** Object:  Table [dbo].[Country]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Country')
		BEGIN
		DROP TABLE [dbo].[Country]
		END
		/****** Object:  Table [dbo].[Ancillary_Type]    Script Date: 4/02/2018 13:19:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Ancillary_Type')
		BEGIN
		DROP TABLE [dbo].[Ancillary_Type]
		END
		/****** Object:  Table [dbo].[Acq_Deal_ancillary_Title]    Script Date: 4/02/2018 13:19:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_ancillary_Title')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_ancillary_Title]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Ancillary_Platform]    Script Date: 4/02/2018 13:19:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Ancillary_Platform')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Ancillary_Platform]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Ancillary]    Script Date: 4/02/2018 13:19:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Ancillary')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Ancillary]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Territory]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Holdback_Territory')
		BEGIN
		DROP TABLE [dbo].Acq_Deal_Rights_Holdback_Territory
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Holdback_Subtitling')
		BEGIN
		DROP TABLE [dbo].Acq_Deal_Rights_Holdback_Subtitling
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Holdback_Platform')
		BEGIN
		DROP TABLE [dbo].Acq_Deal_Rights_Holdback_Platform
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Dubbing]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Holdback_Dubbing')
		BEGIN
		DROP TABLE [dbo].Acq_Deal_Rights_Holdback_Dubbing
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Holdback')
		BEGIN
		DROP TABLE [dbo].Acq_Deal_Rights_Holdback
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Title]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Title')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights_Title]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Territory]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Territory')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights_Territory]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Subtitling')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights_Subtitling]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Platform')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights_Platform]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Dubbing]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights_Dubbing')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights_Dubbing]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Rights]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Rights')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Rights]
		END
		/****** Object:  Table [dbo].[Acq_Deal_Movie]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal_Movie')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal_Movie]
		END
		/****** Object:  Table [dbo].[Acq_Deal]    Script Date: 4/16/2015 12:21:09 ******/
		IF EXISTS (SELECT *  FROM sys.tables  WHERE name='Acq_Deal')
		BEGIN
		DROP TABLE [dbo].[Acq_Deal]
		END
		/****** Object:  Table [dbo].[Acq_Deal]    Script Date: 4/16/2015 12:21:09 ******/
		/****** Object:  Table [dbo].[Deal_Type] ******/
		IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Deal_Type')
		BEGIN
			DROP TABLE [dbo].[Deal_Type]
		END
		/****** Object:  Table [dbo].[Deal_Type] ******/

		SET ANSI_PADDING ON
		SELECT * INTO Deal_Type FROM RightsU_Plus_Testing.dbo.Deal_Type
		ALTER TABLE dbo.Deal_Type ADD CONSTRAINT
		[PK_Deal_Type] PRIMARY KEY CLUSTERED 
		(
			[Deal_Type_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF


		SET ANSI_PADDING ON
		SELECT * INTO Acq_Deal FROM RightsU_Plus_Testing.dbo.Acq_Deal
		ALTER TABLE dbo.Acq_Deal ADD CONSTRAINT
		[PK_Acq_Deal] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Movie]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO Acq_Deal_Movie FROM RightsU_Plus_Testing.dbo.Acq_Deal_Movie
		ALTER TABLE dbo.Acq_Deal_Movie ADD CONSTRAINT [PK_Acq_Deal_Movie] PRIMARY KEY NONCLUSTERED 
		(
			[Acq_Deal_Movie_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Rights]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Acq_Deal_Rights] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights]
		ALTER TABLE [Acq_Deal_Rights]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Code] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Dubbing]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO Acq_Deal_Rights_Dubbing FROM RightsU_Plus_Testing.dbo.Acq_Deal_Rights_Dubbing 
		ALTER TABLE Acq_Deal_Rights_Dubbing
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Dubbing_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Platform] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Platform]
		ALTER TABLE [Acq_Deal_Rights_Platform]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Platform] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Platform_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Acq_Deal_Rights_Subtitling] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Subtitling]
		ALTER TABLE [Acq_Deal_Rights_Subtitling]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Subtitling_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Territory]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Acq_Deal_Rights_Territory] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Territory]
		ALTER TABLE [Acq_Deal_Rights_Territory]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Territory] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Territory_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Title]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Title] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Title]
		ALTER TABLE [Acq_Deal_Rights_Title]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Title] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Title_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		
		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Holdback] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Holdback]
		ALTER TABLE [Acq_Deal_Rights_Holdback]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Holdback] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Holdback_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[[Acq_Deal_Rights_Holdback_Dubbing]]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Holdback_Dubbing] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Holdback_Dubbing]
		ALTER TABLE [Acq_Deal_Rights_Holdback_Dubbing]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Dubbing] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Holdback_Dubbing_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Holdback_Platform] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Holdback_Platform]
		ALTER TABLE [Acq_Deal_Rights_Holdback_Platform]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_Holdback_Platform] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Holdback_Platform_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Holdback_Subtitling] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Holdback_Subtitling]
		ALTER TABLE [Acq_Deal_Rights_Holdback_Subtitling]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Subtitling] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Holdback_Subtitling_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Rights_Holdback_Territory]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Rights_Holdback_Territory] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Rights_Holdback_Territory]
		ALTER TABLE [Acq_Deal_Rights_Holdback_Territory]
		ADD CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Territory] PRIMARY KEY CLUSTERED 
		(
			[Acq_Deal_Rights_Holdback_Territory_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Ancillary_Type]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Ancillary_Type] FROM RightsU_Plus_Testing.dbo.[Ancillary_Type]
		ALTER TABLE [Ancillary_Type]
		ADD CONSTRAINT [PK_Ancillary_Type] PRIMARY KEY CLUSTERED 
		(
			Ancillary_Type_Code ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Ancillary]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Ancillary] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Ancillary]
		ALTER TABLE [Acq_Deal_Ancillary]
		ADD CONSTRAINT [PK_Acq_Deal_Ancillary] PRIMARY KEY CLUSTERED 
		(
			Acq_Deal_Ancillary_Code ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_ancillary_Title]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_ancillary_Title] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_ancillary_Title]
		ALTER TABLE [Acq_Deal_ancillary_Title]
		ADD CONSTRAINT [PK_Acq_Deal_ancillary_Title] PRIMARY KEY CLUSTERED 
		(
			Acq_Deal_ancillary_Title_Code ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Acq_Deal_Ancillary_Platform]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Acq_Deal_Ancillary_Platform] FROM RightsU_Plus_Testing.dbo.[Acq_Deal_Ancillary_Platform]
		ALTER TABLE [Acq_Deal_Ancillary_Platform]
		ADD CONSTRAINT [PK_Acq_Deal_Ancillary_Platform] PRIMARY KEY CLUSTERED 
		(
			Acq_Deal_Ancillary_Platform_Code ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Country]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Country] FROM RightsU_Plus_Testing.dbo.[Country]
		ALTER TABLE [Country]
		ADD CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
		(
			[Country_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Genres]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Genres] FROM RightsU_Plus_Testing.dbo.[Genres]
		ALTER TABLE [Genres]
		ADD CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED 
		(
			[Genres_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Language]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Language] FROM RightsU_Plus_Testing.dbo.[Language]
		ALTER TABLE [dbo].[Language]
		ADD CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
		(
			[Language_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF
		/****** Object:  Table [dbo].[Language_Group]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Language_Group] FROM RightsU_Plus_Testing.dbo.[Language_Group]
		ALTER TABLE [dbo].[Language_Group]
		ADD CONSTRAINT [PK_Language_Group] PRIMARY KEY CLUSTERED 
		(
			[Language_Group_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Language_Group_Details]    Script Date: 4/16/2015 12:21:09 ******/
		SELECT * INTO [Language_Group_Details] FROM RightsU_Plus_Testing.dbo.[Language_Group_Details]
		ALTER TABLE [dbo].[Language_Group_Details]
		ADD CONSTRAINT [PK_Language_Group_Details\] PRIMARY KEY CLUSTERED 
		(
			[Language_Group_Details_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Platform]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Platform] FROM RightsU_Plus_Testing.dbo.[Platform]
		ALTER TABLE [Platform] 
		ADD CONSTRAINT [PK_Platform_Demo] PRIMARY KEY CLUSTERED 
		(
			[Platform_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Role]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Role] FROM RightsU_Plus_Testing.dbo.[Role]
		ALTER TABLE [dbo].[Role]
		ADD CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
		(
			[Role_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Sub_License]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Sub_License] FROM RightsU_Plus_Testing.dbo.[Sub_License]
		ALTER TABLE [Sub_License]
		ADD CONSTRAINT [PK_Sub_License] PRIMARY KEY CLUSTERED 
		(
			[Sub_License_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Acq_Mapping]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Syn_Acq_Mapping] FROM RightsU_Plus_Testing.dbo.[Syn_Acq_Mapping]
		ALTER TABLE [Syn_Acq_Mapping]
		ADD CONSTRAINT [PK_Syndication_Acquisition_Mapping] PRIMARY KEY CLUSTERED 
		(
			[Syn_Acq_Mapping_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Syn_Deal]    Script Date: 4/16/2015 12:21:09 ******/
		SET ANSI_PADDING ON
		SELECT * INTO [Syn_Deal] FROM RightsU_Plus_Testing.dbo.[Syn_Deal]
		ALTER TABLE [Syn_Deal]
		ADD CONSTRAINT [PK_Syn_Deal] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Movie]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Syn_Deal_Movie] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Movie]
		ALTER TABLE [Syn_Deal_Movie]
		ADD CONSTRAINT [PK_Syn_Deal_Movie] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Movie_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Rights]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Syn_Deal_Rights] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights]
		ALTER TABLE [Syn_Deal_Rights]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Code] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Rights_Dubbing]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Syn_Deal_Rights_Dubbing] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights_Dubbing]
		ALTER TABLE [Syn_Deal_Rights_Dubbing]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Dubbing_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Rights_Platform]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Syn_Deal_Rights_Platform] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights_Platform]
		ALTER TABLE [Syn_Deal_Rights_Platform]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Platform] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Platform_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


		/****** Object:  Table [dbo].[Syn_Deal_Rights_Subtitling]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Syn_Deal_Rights_Subtitling] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights_Subtitling]
		ALTER TABLE [Syn_Deal_Rights_Subtitling]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Subtitling_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Rights_Territory]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON

		SELECT * INTO [Syn_Deal_Rights_Territory] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights_Territory]
		ALTER TABLE [Syn_Deal_Rights_Territory]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Territory] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Territory_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Syn_Deal_Rights_Title]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Syn_Deal_Rights_Title] FROM RightsU_Plus_Testing.dbo.[Syn_Deal_Rights_Title]
		ALTER TABLE [Syn_Deal_Rights_Title]
		ADD CONSTRAINT [PK_Syn_Deal_Rights_Title] PRIMARY KEY CLUSTERED 
		(
			[Syn_Deal_Rights_Title_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[System_Parameter_New]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [System_Parameter_New] FROM RightsU_Plus_Testing.dbo.[System_Parameter_New]
		ALTER TABLE [System_Parameter_New]
		ADD CONSTRAINT [PK_System_Parameter_New] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Talent]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Talent] FROM RightsU_Plus_Testing.dbo.[Talent]
		ALTER TABLE [Talent]
		ADD CONSTRAINT [PK_Talent] PRIMARY KEY CLUSTERED 
		(
			[Talent_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Talent_Role]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Talent_Role] FROM RightsU_Plus_Testing.dbo.[Talent_Role]
		ALTER TABLE [Talent_Role]
		ADD CONSTRAINT [PK_Talent_Role] PRIMARY KEY CLUSTERED 
		(
			[Talent_Role_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Territory]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Territory] FROM RightsU_Plus_Testing.dbo.[Territory]
		ALTER TABLE [Territory]
		ADD CONSTRAINT [PK_Territory] PRIMARY KEY CLUSTERED 
		(
			[Territory_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Territory_Details]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Territory_Details] FROM RightsU_Plus_Testing.dbo.[Territory_Details]
		ALTER TABLE [Territory_Details]
		ADD CONSTRAINT [PK_Territory_Details_1] PRIMARY KEY CLUSTERED 
		(
			[Territory_Details_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Title]    Script Date: 4/16/2015 12:21:09 ******/

		SET ANSI_PADDING ON
		SELECT * INTO [Title] FROM RightsU_Plus_Testing.dbo.[Title]
		ALTER TABLE [Title]
		ADD CONSTRAINT [PK_Title_1] PRIMARY KEY CLUSTERED 
		(
			[Title_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		SET ANSI_PADDING OFF

		/****** Object:  Table [dbo].[Title_Geners]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Title_Geners] FROM RightsU_Plus_Testing.dbo.[Title_Geners]
		ALTER TABLE [Title_Geners]
		ADD CONSTRAINT [PK_Title_Geners] PRIMARY KEY CLUSTERED 
		(
			[Title_Geners_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Title_Talent]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Title_Talent] FROM RightsU_Plus_Testing.dbo.[Title_Talent]
		ALTER TABLE [Title_Talent]
		ADD CONSTRAINT [PK_Title_Star] PRIMARY KEY CLUSTERED 
		(
			[Title_Talent_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Title_Talent]    Script Date: 4/16/2015 12:21:09 ******/

		/****** Object:  Table [dbo].[Title_Release]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Title_Release] FROM RightsU_Plus_Testing.dbo.[Title_Release]
		ALTER TABLE [Title_Release]
		ADD CONSTRAINT [PK_Title_Released_On] PRIMARY KEY CLUSTERED 
		(
			[Title_Release_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Title_Release]    Script Date: 4/16/2015 12:21:09 ******/

		/****** Object:  Table [dbo].[Title_Release_Region]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Title_Release_Region] FROM RightsU_Plus_Testing.dbo.[Title_Release_Region]
		ALTER TABLE [Title_Release_Region]
		ADD CONSTRAINT [PK_Title_Release_Region] PRIMARY KEY CLUSTERED 
		(
			[Title_Release_Region_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Title_Release_Region]    Script Date: 4/16/2015 12:21:09 ******/

		/****** Object:  Table [dbo].[Title_Release_Platforms]    Script Date: 4/16/2015 12:21:09 ******/

		SELECT * INTO [Title_Release_Platforms] FROM RightsU_Plus_Testing.dbo.[Title_Release_Platforms]
		ALTER TABLE [Title_Release_Platforms]
		ADD CONSTRAINT [PK_Title_Release_Platforms] PRIMARY KEY CLUSTERED 
		(
			[Title_Release_Platforms_Code] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		/****** Object:  Table [dbo].[Title_Release_Platforms]    Script Date: 4/16/2015 12:21:09 ******/

		/****** Object:  Table [dbo].[Approved_Deal]    Script Date: 4/16/2015 12:21:09 ******/
		DELETE FROM Approved_Deal
		SET IDENTITY_INSERT Approved_Deal ON
		DECLARE @Movie_DealTypeCode VARCHAR(100) = '1,10,33'
		Insert into Approved_Deal(Approved_Deal_Code, Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
		Select distinct Approved_Deal_Code,Record_Code, Deal_Type,Deal_Status, Inserted_On, Is_Amend, ISNULL(Deal_Rights_Code, 0) 
		from RightsU_Plus_Testing.dbo.Approved_Deal ad
		WHERE ((ad.Record_Code IN (SELECT adm.Acq_Deal_Code FROM RightsU_Plus_Testing.dbo.Acq_Deal_Movie adm
			INNER JOIN RightsU_Plus_Testing.dbo.Title t ON adm.Title_Code = t.Title_Code
			WHERE CAST(t.Deal_Type_Code AS VARCHAR) IN(SELECT DISTINCT number FROM fn_Split_withdelemiter(@Movie_DealTypeCode , ','))
		) AND ad.Deal_Type = 'A')
		OR
		(ad.Record_Code IN (SELECT sdm.Syn_Deal_Code FROM RightsU_Plus_Testing.dbo.Syn_Deal_Movie sdm
			INNER JOIN RightsU_Plus_Testing.dbo.Title t ON sdm.Title_Code = t.Title_Code
			WHERE CAST(t.Deal_Type_Code AS VARCHAR) IN(SELECT DISTINCT number FROM fn_Split_withdelemiter(@Movie_DealTypeCode , ','))
		) AND ad.Deal_Type = 'S')) AND ISNULL(GenerationStatus, '') NOT LIKE '%A%'

		SET IDENTITY_INSERT Approved_Deal OFF

		
		--Select distinct Approved_Deal_Code,Record_Code, Deal_Type,Deal_Status, Inserted_On, Is_Amend, ISNULL(Deal_Rights_Code, 0) 
		--Delete From RightsU_Plus_Testing.dbo.Approved_Deal
		--WHERE Record_Code IN (SELECT adm.Acq_Deal_Code FROM RightsU_Plus_Testing.dbo.Acq_Deal_Movie adm
		--	INNER JOIN RightsU_Plus_Testing.dbo.Title t ON adm.Title_Code = t.Title_Code
		--	WHERE CAST(t.Deal_Type_Code AS VARCHAR) IN(SELECT DISTINCT number FROM fn_Split_withdelemiter(@Movie_DealTypeCode , ','))
		--) AND Deal_Type = 'A'

		Update RightsU_Plus_Testing.dbo.Approved_Deal SET GenerationStatus = ISNULL(GenerationStatus, '') + 'A'
		WHERE Record_Code IN (SELECT adm.Acq_Deal_Code FROM RightsU_Plus_Testing.dbo.Acq_Deal_Movie adm
			INNER JOIN RightsU_Plus_Testing.dbo.Title t ON adm.Title_Code = t.Title_Code
			WHERE t.Deal_Type_Code = @Movie_DealTypeCode
		) AND Deal_Type = 'A' AND GenerationStatus NOT LIKE '%A%'
		
		--Delete From RightsU_Plus_Testing.dbo.Approved_Deal
		--WHERE Record_Code IN (SELECT sdm.Syn_Deal_Code FROM RightsU_Plus_Testing.dbo.Syn_Deal_Movie sdm
		--	INNER JOIN RightsU_Plus_Testing.dbo.Title t ON sdm.Title_Code = t.Title_Code
		--	WHERE CAST(t.Deal_Type_Code AS VARCHAR) IN(SELECT DISTINCT number FROM fn_Split_withdelemiter(@Movie_DealTypeCode , ','))
		--) AND Deal_Type = 'S'
		
		Update RightsU_Plus_Testing.dbo.Approved_Deal  SET GenerationStatus = ISNULL(GenerationStatus, '') + 'A'
		WHERE Record_Code IN (SELECT sdm.Syn_Deal_Code FROM RightsU_Plus_Testing.dbo.Syn_Deal_Movie sdm
			INNER JOIN RightsU_Plus_Testing.dbo.Title t ON sdm.Title_Code = t.Title_Code
			WHERE t.Deal_Type_Code = @Movie_DealTypeCode
		) AND Deal_Type = 'S' AND GenerationStatus NOT LIKE '%A%'

	END TRY
	BEGIN CATCH
		Declare @ernum int    
		Declare @errmsg varchar(max)   
		Declare @errser varchar(max)  
		Declare @errstate varchar(max)  
		Declare @errproc varchar(max)   
		Declare @errline int   
		Declare @StrHTML varchar(1000)
		DECLARE @DatabaseEmail_Profile varchar(200), @MailSubjectCr varchar(100)	
		
		set @ernum=0 
		set @errmsg=''
		set @errser=''
		set @errstate='' 
		set @errproc='[Usp_Drop_Create_Tables]'
		set @errline=0
		    
		SELECT @ernum=ERROR_NUMBER(), @errmsg=ERROR_MESSAGE(), @errser=ERROR_SEVERITY(), @errstate=ERROR_STATE(), @errproc=ERROR_PROCEDURE(),@errline=ERROR_LINE();
		SELECT @DatabaseEmail_Profile = parameter_value FROM RightsU_Plus_Testing.dbo.system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'
		-- 'UTO_AMS_VIACOM'
	
		set @StrHTML = '<HTML><BODY><FONT FACE="verdana" SIZE="2">There is a error while generating avail cache as on ' + convert(varchar(10), getdate(),120) + '<BR><BR><BR>'
		
		set @StrHTML = @StrHTML + 'Error Number :' + cast(@ernum as varchar) + '<BR>'
		set @StrHTML = @StrHTML + 'Error Message :' + @errmsg + '<BR>'
		set @StrHTML = @StrHTML + 'Error Severity :' + @errser + '<BR>'
		set @StrHTML = @StrHTML + 'Error State :' + @errstate + '<BR>'
		set @StrHTML = @StrHTML + 'Error Procedure :' + @errproc + '<BR>'
		set @StrHTML = @StrHTML + 'Error Line :' + cast(@errline as varchar) + '<BR>'
		
		set @StrHTML = @StrHTML + '</font><br>&nbsp;<br><FONT FACE="verdana" SIZE="2" COLOR="gray">This email is generated by RightsU (Rights Management System)</font></body></html>'
		set @StrHTML = @StrHTML + '</BODY></HTML>'

		Set @MailSubjectCr = 'RightsU Email Alert : RightsU Availability cache generation error as on' + convert(varchar(10), getdate(),120)
	
		EXEC msdb.dbo.sp_send_dbmail 
			@profile_name = @DatabaseEmail_Profile,
			@recipients =  'nilesh@uto.in, Adesh@uto.in, priyal@uto.in', 
			@subject = @MailSubjectCr,
			@body = @StrHTML, 
			@body_format = 'HTML';
	END CATCH;

END