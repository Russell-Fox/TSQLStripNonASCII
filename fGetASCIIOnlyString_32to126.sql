/****** Object:  UserDefinedFunction [dbo].[fGetASCIIOnlyString_32to126]    Script Date: 9/15/2016 11:01:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* =============================================
-- Author:			Russell Fox
-- Create date:		9/15/2016
-- Description:		Removes any characters NOT between ASCII values 32 to 127.
-- Usage:
					SELECT TOP 1000
						f.*
						, NewFId = NewFId.CleanedString
					FROM UccDELoad.dbo.Filings f
					OUTER APPLY dbo.fGetASCIIOnlyString_32to126(f.FId) NewFId
-- ===========================================*/

CREATE FUNCTION [dbo].[fGetASCIIOnlyString_32to126]
(	
	@InputString VARCHAR(MAX)
)
RETURNS TABLE 
AS
RETURN 
(

	WITH AllNumbers AS
	(   SELECT 0 AS Number
		UNION ALL
		SELECT Number+1
			FROM AllNumbers
			WHERE Number <= LEN(@InputString)
	)
	, StringCharacters AS
		(SELECT ThisChar = SUBSTRING(a.b, v.number+1, 1)-- COLLATE Latin1_General_BIN
		FROM (SELECT @InputString b) a
		JOIN AllNumbers v on v.number < len(a.b)
		)
	SELECT TOP 1 CleanedString =  
		STUFF((
		SELECT '' + StringCharacters.ThisChar
		FROM StringCharacters 
		WHERE ASCII(StringCharacters.ThisChar) BETWEEN 32 AND 126
		FOR XML PATH (''), TYPE).value('.', 'nvarchar(max)')
		,1,0,'')
	FROM StringCharacters Results

)

GO

