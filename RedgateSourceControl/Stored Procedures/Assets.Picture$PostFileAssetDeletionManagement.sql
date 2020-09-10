SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [Assets].[Picture$PostFileAssetDeletionManagement]
(
	@CleanUpFilesFlag bit = 0
)
AS
BEGIN
	SET XACT_ABORT ON;
	BEGIN TRANSACTION

	IF EXISTS (SELECT *
			   FROM   Assets.DeletedPicture
			   WHERE  PictureInUseFlag = 0)
	  BEGIN
		SELECT CASE @CleanUpFilesFlag WHEN 1 THEN 'These Pictures will be deleted' ELSE 'View only mode. Set @CleanUpFilesFlag = 1 to delete the following files' END
		SELECT *
		FROM   Assets.DeletedPicture
		WHERE  PictureInUseFlag = 0
	  END;

	IF @CleanUpFilesFlag = 1
	 BEGIN
		DELETE PictureTag
		FROM   Assets.Picture
				JOIN Assets.PictureTag
					ON Picture.PictureId = PictureTag.PictureId
		WHERE   EXISTS (SELECT *
						FROM   Assets.DeletedPicture
						WHERE  Picture.PictureId = deletedPicture.PictureId
						  AND  PictureInUseFlag = 0)
		DELETE 
		FROM   Assets.Picture
		WHERE   EXISTS (SELECT *
						FROM   Assets.DeletedPicture
						WHERE  Picture.PictureId = deletedPicture.PictureId
						  AND  PictureInUseFlag = 0)
	  END;

	IF EXISTS (SELECT *
			   FROM   Assets.DeletedPicture
			   WHERE  PictureInUseFlag = 1)
	  BEGIN
		SELECT 'There are files that were referenced that were deleted. Must fix before this procedure will help'
		SELECT *
		FROM   Assets.DeletedPicture
		WHERE  PictureInUseFlag = 1
	  END;

	COMMIT
 END;
GO
