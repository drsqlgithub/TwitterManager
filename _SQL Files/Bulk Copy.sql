--Do 1 over
TRUNCATE TABLE FileAssets.PicturePreview

DECLARE @PageNumber int = 1, @RowsOfPage int = 200

INSERT INTO FileAssets.PicturePreview(stream_id,
                                      file_stream,
                                      name,
                                      path_locator,
                                      creation_time,
                                      last_write_time,
                                      last_access_time,
                                      is_directory,
                                      is_offline,
                                      is_hidden,
                                      is_readonly,
                                      is_archive,
                                      is_system,
                                      is_temporary)
SELECT Picture.stream_id,
       Picture.file_stream,
       Picture.name,
       Picture.path_locator,
       Picture.creation_time,
       Picture.last_write_time,
       Picture.last_access_time,
       Picture.is_directory,
       Picture.is_offline,
       Picture.is_hidden,
       Picture.is_readonly,
       Picture.is_archive,
       Picture.is_system,
       Picture.is_temporary
FROM   FileAssets.Picture
WHERE  Picture.NAME IN (
SELECT PictureDecoded.PhysicalFileName
FROM   FileAssets.PictureDecoded
WHERE -- PictureDecoded.PhysicalFileName NOT LIKE '%{Christmas}%'
    PictureDecoded.PhysicalFileName LIKE '%{Halloween}%'
 )
ORDER BY name DESC
OFFSET (@PageNumber-1)*@RowsOfPage ROWS
FETCH NEXT @RowsOfPage ROWS ONLY