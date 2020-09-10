SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [Tools].[SystemSecurityName$Get]
(
     @AllowSessionContext bit = 1,
     @IgnoreImpersonation bit = 0
)
------------------------------------------------------------------------
-- Get the user’s security context, using SESSION_CONTEXT, SUSER_SNAME,
-- or ORIGINAL_LOGIN
--
-- 2020 Louis Davidson – drsql@hotmail.com – drsql.org 
------------------------------------------------------------------------
RETURNS sysname
AS
 BEGIN
    RETURN (
     CASE WHEN @AllowSessionContext = 1 
                 AND SESSION_CONTEXT(N'ApplicationUserName') IS NOT NULL
              THEN CAST(SESSION_CONTEXT(N'ApplicationUserName') AS sysname)
          WHEN @IgnoreImpersonation = 1
              THEN SUSER_SNAME()
          ELSE ORIGINAL_LOGIN() END)
 END;
GO
