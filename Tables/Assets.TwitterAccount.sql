CREATE TABLE [Assets].[TwitterAccount]
(
[TwitterAccountId] [int] NOT NULL IDENTITY(1, 1),
[TwitterHandle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LockedFlag] [bit] NOT NULL CONSTRAINT [DFLTAssociatedTwitterAccount_LockedFlag] DEFAULT ((0)),
[DeadAccountFlag] [bit] NOT NULL CONSTRAINT [DFLTAssociatedTwitterAccount_DeadAccountFlag] DEFAULT ((0)),
[FollowFridayFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[TwitterAccount] ADD CONSTRAINT [PKAssociatedTwitterAccount] PRIMARY KEY CLUSTERED  ([TwitterAccountId]) ON [PRIMARY]
GO
