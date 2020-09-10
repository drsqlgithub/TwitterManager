EXIT

--Adding new pictures

--add picture number to new files
EXEC FileAssets.Picture$AddPictureNumber;

--list files to fix
SELECT *
FROM    FileAssets.PictureInvalidImage;


--copy files for fixing to the FixImages folder
FileAssets.PictureInvalidImage$CopyToFix

EXIT
Assets.Picture$MakeDetailsMatchFileAssets



SELECT Picture.PictureId,
       Picture.PictureNumber,
       Picture.ThemeParkAssetId,
       Picture.Year,
       Picture.RowRecoveryPhysicalFileName,
	   row_number() OVER (PARTITION BY PictureNumber  ORDER BY Pictureid) AS RowNumber
INTO #holdRows
FROM   assets.Picture

