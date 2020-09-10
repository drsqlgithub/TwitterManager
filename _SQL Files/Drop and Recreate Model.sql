USE tempdb
GO
DROP DATABASE TwitterManagerModel;
GO
/****** Object:  Database [TwitterManagerModel]    Script Date: 9/5/2020 11:56:30 AM ******/
CREATE DATABASE [TwitterManagerModel]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TwitterManagerModel', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.THEMEPARK\MSSQL\DATA\TwitterManagerModel.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [FilestreamData] CONTAINS FILESTREAM  DEFAULT
( NAME = N'FilestreamDataFile1', FILENAME = N'c:\sql\filestreamModel' , MAXSIZE = UNLIMITED)
 LOG ON 
( NAME = N'TwitterManagerModel_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.THEMEPARK\MSSQL\DATA\TwitterManagerModel_log.ldf' , SIZE = 335872KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

ALTER DATABASE [TwitterManagerModel] SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'TwitterManagerModel' ) 
GO
USE TwitterManagerModel;
GO



-- ****************** SqlDBM: Microsoft SQL Server ******************
-- ******************************************************************







