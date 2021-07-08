SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [Assets].[SinglePicture$SetTags]
(
   @SourceFileName nvarchar(255) , 
   @TagList  varchar(200),
   @AppendTags bit 
		) AS 

IF @SourceFileName NOT LIKE '%.jpg'
	SET @SourceFileName = @SourceFileName + '.jpg'

IF NOT EXISTS (SELECT *
				FROM   FileAssets.PictureDecoded
				WHERE PictureDecoded.PhysicalFileName = @SourceFileName)
	THROW 50000,'Invalid source file name',1;

DECLARE @NameBase nvarchar(255) = TRIM(Tools.String$SplitPart(@SourceFileName,'_',1)) + '_' + TRIM(Tools.String$SplitPart(@SourceFileName,'_',2)) + '_' +
		TRIM(Tools.String$SplitPart(@SourceFileName,'_',3)) + '_' 

DECLARE @Picnumber nvarchar(20) = TRIM(Tools.String$SplitPart(@SourceFileName,'_',5))
DECLARE @AppendingTags nvarchar(200) = ' ' + TRIM(Tools.String$SplitPart(@SourceFileName,'_',4)) + ' '

DECLARE @OutputFileName nvarchar(255)

IF @SourceFileName NOT LIKE '%PIC%'
	THROW 50000,'This procedure can only be used to modify tags. Use Assets.SinglePicture$Add to set tags',1;

IF @AppendTags = 1
 BEGIN
 	DECLARE @Tags CURSOR, @checkTag nvarchar(200)
	SET @Tags = CURSOR FOR (SELECT TRIM(Value) AS Value
							FROM   STRING_SPLIT(@TagList,' '))
	OPEN @Tags
	WHILE 1 = 1
	 BEGIN
		FETCH NEXT FROM @Tags INTO @checkTag
		IF @@FETCH_STATUS <> 0
 		  BREAK

		IF @AppendingTags NOT LIKE '% ' + @checkTag + ' %'
			SET @AppendingTags = @AppendingTags + ' ' + @checkTag 
	 
	 END

	 SET @OutputFileName = @NameBase + TRIM(@AppendingTags)
END
ELSE
 BEGIN
  	SET @OutputFileName = @NameBase + @TagList 
 END

 SET @OutputFileName = @OutputFileName + '_' + @Picnumber --note, picnumber includes extension
  
UPDATE FileAssets.PictureDecoded
SET PictureDecoded.PhysicalFileName = @OutputFileName
WHERE  PictureDecoded.PhysicalFileName = @SourceFileName

SELECT *
FROM   FileAssets.PictureDecoded
WHERE  PictureDecoded.PhysicalFileName = @OutputFileName
GO
