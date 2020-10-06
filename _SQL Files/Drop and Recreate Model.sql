USE tempdb
GO
DROP DATABASE TwitterManagerDollywood;
GO
/****** Object:  Database [TwitterManagerDollywood]    Script Date: 9/5/2020 11:56:30 AM ******/
CREATE DATABASE [TwitterManagerDollywood]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TwitterManagerDollywood', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.THEMEPARK\MSSQL\DATA\TwitterManagerDollywood.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [FilestreamData] CONTAINS FILESTREAM  DEFAULT
( NAME = N'FilestreamDataFile1', FILENAME = N'c:\sql\filestreamDollywood' , MAXSIZE = UNLIMITED)
 LOG ON 
( NAME = N'TwitterManagerDollywood_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.THEMEPARK\MSSQL\DATA\TwitterManagerDollywood_log.ldf' , SIZE = 335872KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

ALTER DATABASE [TwitterManagerDollywood] SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'TwitterManagerDollywood' ) 
GO
USE TwitterManagerDollywood;
GO



-- ****************** SqlDBM: Microsoft SQL Server ******************
-- ******************************************************************







