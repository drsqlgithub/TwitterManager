Assets.SinglePicture$Add
	@SourceFileName = 'Figments 2021_02_13',
	@ThemeParkAreaHashtag = 'EPCOT',
	@ThemeParkAssetHashtag = 'FestivalOfTheArts',
	@Year = '2018',
	@TagList = '{FigmentsInTime}'

Assets.SinglePicture$SetTags

   @SourceFileName  = '2020_HollywoodStudios_Windows_{WindowWednesday}_PIC0020042', 
   @TagList  = '(WWSkyliner)',
   @AppendTags = 1

UPDATE FileAssets.PictureDecoded
SET PictureDecoded.PhysicalFileName = '2018_EPCOT_FestivalOfTheArts_ Mural  {FigmentsInTime}_PIC0021108.jpg'
WHERE PictureDecoded.PhysicalFileName  = '2018_EPCOT_FestivalOfTheArts_ Mural  {FigmentsInTime}_PIC0021108.jpg.jpg'

EXEC assets.[Picture$MakeDetailsMatchFileAssets]

--add picture number to new files
EXEC FileAssets.Picture$AddPictureNumber;
SELECT * FROM [FileAssets].[PictureInvalidImage]

----------------------------
/*
--WindowWednesday
SELECT *
FROM   assets.tag
/*

 



*/