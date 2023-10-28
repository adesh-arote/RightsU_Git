CREATE TABLE [dbo].[DashboardUserInfo] (
    [DashboardUserInfoId] INT      IDENTITY (1, 1) NOT NULL,
    [UserId]              INT      NOT NULL,
    [UniqueForMonth]      INT      CONSTRAINT [DF_DashboardUserInfo_UniqueForMonth] DEFAULT ((0)) NOT NULL,
    [FirstLoggedInAt]     DATETIME NULL,
    [LastLoggedInAt]      DATETIME NULL,
    [UniqueForDuration]   INT      CONSTRAINT [DF_DashboardUserInfo_UniqueForDuration] DEFAULT ((0)) NOT NULL,
    [DepartmentId]        INT      CONSTRAINT [DF_DashboardUserInfo_DepartmentId] DEFAULT ((0)) NOT NULL,
    [UniqueForAllTime]    INT      CONSTRAINT [DF_DashboardUserInfo_UniqueForAllTime] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DashboardUserInfo] PRIMARY KEY CLUSTERED ([DashboardUserInfoId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIDX_UserId_DepartmentId]
    ON [dbo].[DashboardUserInfo]([UserId] ASC, [DepartmentId] ASC);

