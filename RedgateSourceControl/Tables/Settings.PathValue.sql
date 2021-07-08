CREATE TABLE [Settings].[PathValue]
(
[PathHandle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PathValue] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Settings].[PathValue] ADD CONSTRAINT [PKPathValues] PRIMARY KEY CLUSTERED  ([PathHandle]) ON [PRIMARY]
GO
