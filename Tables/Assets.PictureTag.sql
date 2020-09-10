CREATE TABLE [Assets].[PictureTag]
(
[PictureTagId] [int] NOT NULL IDENTITY(1, 1),
[PictureId] [int] NOT NULL,
[TagId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[PictureTag] ADD CONSTRAINT [PK_picturetags] PRIMARY KEY CLUSTERED  ([PictureTagId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_176] ON [Assets].[PictureTag] ([PictureId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[PictureTag] ADD CONSTRAINT [AKPictureTag] UNIQUE NONCLUSTERED  ([PictureId], [TagId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_227] ON [Assets].[PictureTag] ([TagId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[PictureTag] ADD CONSTRAINT [FK_176] FOREIGN KEY ([PictureId]) REFERENCES [Assets].[Picture] ([PictureId])
GO
ALTER TABLE [Assets].[PictureTag] ADD CONSTRAINT [FK_227] FOREIGN KEY ([TagId]) REFERENCES [Assets].[Tag] ([TagId])
GO
