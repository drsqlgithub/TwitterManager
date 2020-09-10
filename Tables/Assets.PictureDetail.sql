CREATE TABLE [Assets].[PictureDetail]
(
[Detail] [nvarchar] (280) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PictureId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[PictureDetail] ADD CONSTRAINT [PK_picturedetail] PRIMARY KEY CLUSTERED  ([PictureId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_207] ON [Assets].[PictureDetail] ([PictureId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[PictureDetail] ADD CONSTRAINT [FK_207] FOREIGN KEY ([PictureId]) REFERENCES [Assets].[Picture] ([PictureId])
GO
