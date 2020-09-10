CREATE TABLE [Tools].[Calendar]
(
[DateValue] [date] NOT NULL,
[DayName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MonthName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Year] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Day] [tinyint] NOT NULL,
[DayOfTheYear] [smallint] NOT NULL,
[Month] [smallint] NOT NULL,
[Quarter] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tools].[Calendar] ADD CONSTRAINT [PKTools_Calendar] PRIMARY KEY CLUSTERED  ([DateValue]) ON [PRIMARY]
GO
